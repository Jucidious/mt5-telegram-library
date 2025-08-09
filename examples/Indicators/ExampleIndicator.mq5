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
//+-------------------------------------------------------------------+
//|                                             SimpleIndicator.mq5   |
//| A simple MetaTrader 5 indicator for testing the MT5 Telegram Bot  |
//| library. Demonstrates basic functionality, including:             |
//| - Registering the chart with the library on initialization.       |
//| - Sending Telegram notifications on each tick with price data.    |
//| - Unregistering the chart on deinitialization.                    |
//| - Optional debug logging for troubleshooting.                     |
//|                                                                   |
//| The indicator sends the current symbol, timeframe, and close      |
//| price to the Telegram owner chat on each tick.                    |
//+-------------------------------------------------------------------+

#property copyright "Jucidious"
#property link      "https://github.com/Jucidious/mt5-telegram-library"
#property version   "1.00"
#property indicator_chart_window

//--- Include library files
#include <Telegram\TelegramCommon.mqh>
#include <Telegram\TelegramBot.mqh>
#include <Telegram\TelegramServiceUtils.mqh>

//--- Input parameters
input string InpTelegramToken = "";       // Telegram Bot Token
input long   InpOwnerChatId   = 0;       // Owner Chat ID
input bool   InpDebugMode     = false;   // Enable Debug Logging

//--- Global variables
CTelegramBot bot;  // Telegram bot instance

//+------------------------------------------------------------------+
//| Indicator initialization function                                |
//+------------------------------------------------------------------+
int OnInit()
{
   // Validate input parameters
   if(InpTelegramToken == "" || InpOwnerChatId == 0)
   {
      Print("Error: Telegram token or Owner Chat ID is empty");
      return(INIT_PARAMETERS_INCORRECT);
   }

   // Initialize bot
   bot.Init(InpTelegramToken);
   bot.Debug(InpDebugMode); // Enable debug logging if requested

   // Register chart with the library
   if(!RegisterChart(ChartID(), _Symbol, _Period))
   {
      Print("Error: Failed to register chart");
      return(INIT_FAILED);
   }

   // Log successful initialization
   Print("SimpleIndicator initialized successfully");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Unregister chart to clean up
   UnregisterChart(ChartID());

   // Log deinitialization
   Print("SimpleIndicator deinitialized, reason: ", reason);
}

//+------------------------------------------------------------------+
//| Indicator calculation function                                   |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   // Get the latest close price
   double close_price = close[rates_total - 1];

   // Format message with symbol, timeframe, and close price
   string message = StringFormat(
      "Symbol: %s\nTimeframe: %s\nClose Price: %.5f",
      _Symbol,
      PeriodToString(_Period),
      close_price
   );

   // Send notification to Telegram
   if(!SendTelegramNotification(message, true))
   {
      Print("Error: Failed to send Telegram notification");
   }

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Convert timeframe to string                                      |
//+------------------------------------------------------------------+
string PeriodToString(ENUM_TIMEFRAMES timeframe)
{
   switch(timeframe)
   {
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1:  return "H1";
      case PERIOD_H4:  return "H4";
      case PERIOD_D1:  return "D1";
      case PERIOD_W1:  return "W1";
      case PERIOD_MN1: return "MN1";
      default:         return "Unknown";
   }
}

//+------------------------------------------------------------------+