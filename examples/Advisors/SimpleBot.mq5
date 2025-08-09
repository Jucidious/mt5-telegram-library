// Copyright (c) 2025 Jucidious
// https://github.com/Jucidious/mt5-telegram-library
//
// This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or
// send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
// You are free to:
// - Share: copy and redistribute the material in any medium or format
// - Adapt: remix, transform, and build upon the material
// Under the following terms:
// - Attribution: You must give appropriate credit to Jucidious, provide a link to the license,
//   and indicate if changes were made.
// - NonCommercial: You may not use the material for commercial purposes.
// - ShareAlike: If you remix, transform, or build upon the material, you must distribute your contributions
//   under the same license as the original.
//
//+------------------------------------------------------------------+
//|                                                    SimpleBot.mq5 |
//| A simple MetaTrader 5 service demonstrating the MT5 Telegram Bot |
//| library. Provides basic Telegram bot functionality, including:   |
//| - Processing basic commands (/start, /status).                   |
//| - Sending text messages to authorized users.                     |
//| - Logging bot activity with different levels (INFO, ERROR).      |
//|                                                                  |
//| The service uses the MT5 Telegram Bot library for Telegram API   |
//| interaction, JSON parsing, and user management.                  |
//+------------------------------------------------------------------+

#property copyright "Jucidious"
#property link      "https://github.com/Jucidious/mt5-telegram-library"
#property version   "1.00"
#property service

//--- Include library files
#include <JsonParser.mqh>
#include <Telegram\TelegramCommon.mqh>
#include <Telegram\TelegramBot.mqh>
#include <Telegram\TelegramServiceUtils.mqh>

//--- Input parameters
input string InpTelegramToken = ""; // Telegram Bot Token
input long   Telegram_Chat_ID = 0; // Owner Chat ID

//--- Global variables
CTelegramBot bot;           // Telegram bot instance
CJsonParser  jsonParser;    // JSON parser instance
long         ownerChatId;   // Owner's Telegram chat ID

//+------------------------------------------------------------------+
//| Service initialization                                           |
//+------------------------------------------------------------------+
void OnInit()
{
   // Validate input parameters
   if(InpTelegramToken == "" || Telegram_Chat_ID == 0)
   {
      LogMessage(LOG_ERROR, "Invalid input parameters: Telegram token or Owner Chat ID is empty");
      return;
   }

   // Initialize bot with token
   bot.Init(InpTelegramToken);
   ownerChatId = Telegram_Chat_ID;

   // Log successful initialization
   LogMessage(LOG_INFO, "SimpleBot initialized successfully");
}

//+------------------------------------------------------------------+
//| Service deinitialization                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   LogMessage(LOG_INFO, "SimpleBot deinitialized, reason: " + IntegerToString(reason));
}

//+------------------------------------------------------------------+
//| Service main loop (called periodically)                          |
//+------------------------------------------------------------------+
void OnTick()
{
   // Poll Telegram updates
   string response;
   if(!bot.GetUpdates(response))
   {
      LogMessage(LOG_ERROR, "Failed to get Telegram updates: " + bot.LastError());
      return;
   }

   // Parse JSON response
   if(!jsonParser.Parse(response))
   {
      LogMessage(LOG_ERROR, "Failed to parse JSON response: " + jsonParser.LastError());
      return;
   }

   // Process updates
   ProcessUpdates();
}

//+------------------------------------------------------------------+
//| Process Telegram updates                                         |
//+------------------------------------------------------------------+
void ProcessUpdates()
{
   // Iterate through updates
   for(int i = 0; i < jsonParser.GetArraySize("result"); i++)
   {
      // Get update object
      CJsonNode* update = jsonParser.GetObject("result", i);
      if(update == NULL) continue;

      // Get message object
      CJsonNode* message = update.GetObject("message");
      if(message == NULL) continue;

      // Get chat ID
      long chatId = message.GetLong("chat.id");
      if(chatId == 0) continue;

      // Check if user is authorized
      if(chatId != ownerChatId)
      {
         bot.SendMessage(chatId, "You are not authorized to use this bot.");
         LogMessage(LOG_WARN, "Unauthorized access attempt from chat ID: " + IntegerToString(chatId));
         continue;
      }

      // Get message text
      string text = message.GetString("text");
      if(text == "") continue;

      // Process commands
      if(StringFind(text, "/start") == 0)
      {
         string reply = "Welcome to SimpleBot!\nUse /status to check bot status.";
         bot.SendMessage(chatId, reply, "MarkdownV2");
         LogMessage(LOG_INFO, "Processed /start command from chat ID: " + IntegerToString(chatId));
      }
      else if(StringFind(text, "/status") == 0)
      {
         string reply = "SimpleBot is running.\nToken: " + StringSubstr(InpTelegramToken, 0, 10) + "...\nOwner Chat ID: " + IntegerToString(ownerChatId);
         bot.SendMessage(chatId, reply, "MarkdownV2");
         LogMessage(LOG_INFO, "Processed /status command from chat ID: " + IntegerToString(chatId));
      }
      else
      {
         bot.SendMessage(chatId, "Unknown command. Available commands: /start, /status");
         LogMessage(LOG_INFO, "Unknown command received: " + text);
      }
   }
}

//+------------------------------------------------------------------+
//| Log message with specified level                                 |
//+------------------------------------------------------------------+
void LogMessage(ENUM_LOG_LEVEL level, string message)
{
   // Use logging function from TelegramServiceUtils.mqh
   Log(level, "SimpleBot", message);
}

//+------------------------------------------------------------------+