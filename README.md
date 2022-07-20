<h4 align="center">
	<img src="https://img.shields.io/github/release/Prefech/Prefech_playTime.png">
	<img src="https://img.shields.io/github/last-commit/Prefech/Prefech_playTime">
	<img src="https://img.shields.io/github/license/Prefech/Prefech_playTime.png">
	<img src="https://img.shields.io/github/issues/Prefech/Prefech_playTime.png">
	<img src="https://img.shields.io/github/contributors/Prefech/Prefech_playTime.png">
	<a href="https://discord.gg/prefech" title=""><img alt="Discord Status" src="https://discordapp.com/api/guilds/721339695199682611/widget.png"></a>
</h4>

<div align="center">
  <a href="https://github.com/Prefech/Prefech_playTime">
    <img src="https://prefech.com/i/PlayTime.png"><br>
  </a>

  <h1 align="center">Prefech_PlayTime</h1>

  <p align="center">
	Get the playtime for your players!<br>
	See how long they have been playing on your server!<br>
    <br />    
    <a href="https://discord.gg/5WJGmFQUjt">Report Bug</a>
    ·
    <a href="https://discord.gg/E9FceTnsJV">Request Feature</a>
  </p>
  <a href="https://discord.gg/prefech" title=""><img alt="Discord Invite" src="https://discordapp.com/api/guilds/721339695199682611/widget.png?style=banner2"></a>
</div>

### Download:
- [Github](https://github.com/prefech/Prefech_playTime)
- [Download](https://github.com/prefech/Prefech_playTime/releases/latest)

### 🛠 Requirements
- FiveM FXServer


### ✅ Main Features
- Saves the playtime of every player
- External accessible info you can use on your website! (SERVER_IP:PORT/Prefech_playTime/info)
- Export function to get the total play time and current session time in any resource you need it.
  - Export will return a table with the values in seconds.
  - `exports.Prefech_playTime:getPlayTime(PLAYER_ID)`
  - Want to give players access to certain things after being x amount of time online. You can simply check with the export if you have played long enough!

### 📌 Commands
- `/getPlayTime <PlayerID>`
  - The `PlayerID` is optional.

### 🔧 Download & Installation
1. Download the files
2. Put the Prefech_playTime folder in the server resource directory
3. Set a custom token in the `config.lua` (This token is used for the api: `http://{SERVERIP}:{PORT}/Prefech_playTime/info`)
4. Add this to your `server.cfg`
```
ensure Prefech_playTime
```

### 📈 Resmon Values
![](https://prefech.com/i/0bd2635c-5a2d-4cef-b72a-f2e54e13f065.png "Resmon Values") 

Info | |
--- | --- |
Code is accessible | Yes |
Requirements | No |
Documentation | N/A |
Support | Yes, we have a [Discord](https://discord.gg/prefech) server at your disposal
