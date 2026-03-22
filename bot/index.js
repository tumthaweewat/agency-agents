require('dotenv').config();
const { Client, GatewayIntentBits, Events } = require('discord.js');

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
  ],
});

const PREFIX = '!';

client.once(Events.ClientReady, (c) => {
  console.log(`Bot is online! Logged in as ${c.user.tag}`);
});

client.on(Events.MessageCreate, (message) => {
  if (message.author.bot) return;
  if (!message.content.startsWith(PREFIX)) return;

  const args = message.content.slice(PREFIX.length).trim().split(/\s+/);
  const command = args.shift().toLowerCase();

  if (command === 'ping') {
    message.reply(`Pong! 🏓 Latency: ${client.ws.ping}ms`);
  }

  if (command === 'hello') {
    message.reply(`Hello ${message.author.username}! 👋`);
  }

  if (command === 'help') {
    message.reply(
      '**Hashbox Bot Commands:**\n' +
      '`!ping` - Check bot latency\n' +
      '`!hello` - Say hello\n' +
      '`!help` - Show this help message'
    );
  }
});

client.login(process.env.DISCORD_TOKEN);
