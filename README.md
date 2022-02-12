<h4 align="center">
	<a href="https://github.com/prefech/Prefech_PlayTime/releases/latest" title=""><img alt="Licence" src="https://img.shields.io/github/release/prefech/Prefech_PlayTime.svg"></a>
	<a href="LICENSE" title=""><img alt="Licence" src="https://img.shields.io/github/license/prefech/Prefech_PlayTime.svg"></a>
	<a href="https://discord.gg/prefech" title=""><img alt="Discord Status" src="https://discordapp.com/api/guilds/721339695199682611/widget.png"></a>
</h4>

### https://discord.gg/prefech

<h4 align="center">
	<img src="https://prefech.com/i/PlayTime.png"><br>
	Get the playtime for your players!<br>
	See how long they have been playing on your server!<br>
</h4>

> ### Download:
> - [Github](https://github.com/prefech/Prefech_playTime)
> - [Download](https://github.com/prefech/Prefech_playTime/releases/latest)

>### Requirements
> - FiveM FXServer
> - OxMySQL
>   - [Forum Topic](https://forum.cfx.re/t/standalone-oxmysql-lightweight-mysql-wrapper/4755120)
>   - [Download](https://github.com/overextended/oxmysql/releases/latest)

> ### Main Features
> - Saves the playtime of every player
> - External accessible info you can use on your website! (SERVER_IP:PORT/Prefech_playTime/info)
> - Export function to get the total play time and current session time in any resource you need it.
>   - Export will return a table with the values in seconds.
>   - `exports.Prefech_PlayTime:getPlayTime(PLAYER_ID)`
>   - Want to give players access to certain things after being x amount of time online. You can simply check with the export if you have played long enough!

> ### Commands
> - `/getPlayTime [PlayerID]`
>   - The `PlayerID` is optional.

> ### Download & Installation
> 1. Download the files
> 2. Put the Prefech_PlayTime folder in the server resource directory
> 3. Add this to your `server.cfg`
> ```
> ensure Prefech_PlayTime
> ```
> 4. Upload the SQL to your database.

https://github.com/prefech/Prefech_playTime


### For more support join my discord: https://discord.gg/prefech
