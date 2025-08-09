# MT5 Telegram Bot

A powerful Telegram bot for MetaTrader 5 (MT5) that allows users to subscribe to chart signals, receive screenshots, and manage subscriptions directly from Telegram. Built with MQL5, this project is a free, open-source alternative to commercial libraries costing 35\$–65$, designed to empower the trading community.

## Features

- **Chart Subscriptions**  
  Subscribe to specific MT5 charts (symbol + timeframe) for real-time updates.

- **Screenshots**  
  Request screenshots of subscribed charts via Telegram.

- **User Management**  
  Bot owner can add or remove allowed users using `/adduser` and `/deluser` commands.

- **Customizable Keyboards**  
  Inline keyboards for easy navigation (charts, subscriptions, screenshots).

- **JSON Parsing**  
  Built-in JSON parser for handling Telegram API responses.

- **Reliable Polling**  
  Handles Telegram updates with retry logic and exponential backoff.

- **Markdown Support**  
  Format messages with MarkdownV2 for better readability.

## Prerequisites

- MetaTrader 5: Installed and configured on your system.
- Telegram Bot Token: Obtain a bot token from BotFather.
- Allowed URLs: Ensure `https://api.telegram.org` is added to MT5's allowed URLs (Tools > Options > Expert Advisors).
- Owner Chat ID: Your Telegram chat ID for bot administration.

## Installation

### Clone the Repository

```bash
git clone https://github.com/Jucidious/mt5-telegram-bot.git
```

### Copy Files to MT5 Directory

Place the contents of the `MQL5` folder into your MT5 data directory:

**Windows:**  
`C:\Users\<YourUser>\AppData\Roaming\MetaQuotes\Terminal\<TerminalID>\MQL5`

Or open MT5, go to *File > Open Data Folder*, and navigate to `MQL5`.

Expected structure:

```
MQL5/
├── Services/
│   └── TelegramService.mq5
├── Include/
│   └── JsonParser.mqh
│   └── Telegram/
│       ├── TelegramCommon.mqh
│       ├── TelegramBot.mqh
│       └── TelegramServiceUtils.mqh
```

### Configure the Bot

Open `TelegramService.mq5` in MetaEditor.  
Set the input parameters:

```mql
input string InpTelegramToken = "123456789:AAFuC3E1ROd_5d_oPnrATv0YNnUzG7SBgM4";
input long   Telegram_Chat_ID = 123456789;
```

### Compile

Press `F7` in MetaEditor to compile the file.

### Run the Service

In MT5, go to *Navigator > Services*, right-click `TelegramService` and select **Enable**.  
The bot will start polling Telegram for updates.

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/start` | Initialize the bot and display the main menu. |
| `/charts` | List available charts for subscription. |
| `/status` | View your active subscriptions. |
| `/screenshot` | Request a screenshot of a subscribed chart. |
| `/adduser <chat_id>` | (Owner only) Add a user to the allowed list. |
| `/deluser <chat_id>` | (Owner only) Remove a user from the allowed list. |

### Example Interaction

1. Send `/start` to the bot.
2. Use `/charts` to see available charts.
3. Click an inline button to subscribe/unsubscribe.
4. Use `/screenshot` to request a chart screenshot.

## File Structure

```
MT5-Telegram-Bot/
├── MQL5/
│   ├── Services/
│   │   └── TelegramService.mq5          # Main Telegram bot service
│   ├── Include/
│   │   └── JsonParser.mqh               # JSON parser for API responses
│   │   └── Telegram/
│   │       ├── TelegramCommon.mqh       # Common Telegram utilities
│   │       ├── TelegramBot.mqh          # Telegram API interaction
│   │       └── TelegramServiceUtils.mqh # Subscription and user management
│   ├── Files/
│   │   ├── TelegramAllowedUsers.txt
│   │   ├── TelegramSubscriptions.txt
│   │   ├── TelegramActiveCharts.txt
│   │   └── TGQ_*.txt
├── docs/
│   └── screenshots/
│       └── telegram_bot.png             # Example screenshot
├── .gitignore
├── LICENSE                              # CC BY-NC-SA 4.0 License
└── README.md                            # Project documentation
```

## Support the Project

If you find this library useful, consider supporting its development:

- **USDT TRC20:** `TEbiqFjSxWUDvWvZ9jasQxAMDmuz8847AM`
- **Bitcoin:** `15FwuY4KzRZhjmxnWe88eSdAj8H8kzpPsH`
- For commercial use or custom features, contact `Jucidious@gmail.com`.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch:  
   `git checkout -b feature/YourFeature`
3. Commit your changes:  
   `git commit -m "Add YourFeature"`
4. Push to the branch:  
   `git push origin feature/YourFeature`
5. Open a Pull Request.

Please ensure your contributions comply with the **CC BY-NC-SA 4.0 License**.

## License

This project is licensed under the *Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License*.  
You are free to use, modify, and share it for non-commercial purposes. For commercial use, please contact `Jucidious@gmail.com`.

## Acknowledgments

- Built with MetaTrader 5 and the Telegram Bot API.

## Author / Contact

**Author:** Jucidious  
**Contact:** Open an issue on GitHub or email `Jucidious@gmail.com`
