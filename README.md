# Nass Ped Scaler

A comprehensive FiveM script that allows players to scale their character's height/size in real-time with a beautiful web-based interface.

## Features

- **Real-time scaling**: Adjust your character's height from 0.1x to 2.0x scale
- **Modern UI**: Clean, responsive web-based interface
- **Framework Support**: Compatible with ESX, QBCore, and Standalone
- **Multiplayer Sync**: All players see each other's scaled characters
- **Persistent Storage**: Your scale settings are saved and restored
- **Permission System**: Configurable ACE permissions for commands
- **Multi-language**: Support for English and Spanish (easily extensible)

## Installation Guide

### Dependencies

- FiveM Server
- One of the supported frameworks: ESX, QBCore, or Standalone
- Basic knowledge of FiveM resource installation

### Step 1: Download and Extract

1. Download the latest release from our repository
2. Extract the `nass_pedscaler` folder to your server's resources directory
3. Place it in your `resources/[nass-scripts]/` folder (or any folder structure you prefer)

### Step 2: Add to Server Configuration

Add the following line to your `server.cfg`:

```cfg
ensure nass_pedscaler
```

**Important**: Make sure to add this line AFTER your framework initialization (ESX/QBCore).

### Step 3: Framework Configuration

The script automatically detects your framework. No additional configuration is required for:
- **ESX**: Works out of the box
- **QBCore**: Works out of the box  
- **Standalone**: Works without any framework

### Step 4: Start Your Server

1. Start your FiveM server
2. Check the console for any error messages
3. The script should load successfully with the message: `nass_pedscaler started successfully`

## Configuration

### Basic Configuration (`config.lua`)

```lua
Config = {}

-- Commands
Config.commands = {
    openMenu = {
        enabled = true,
        command = "scale"  -- Change this to customize the command
    },
    resetScale = {
        enabled = true,
        command = "resetscale"  -- Change this to customize the command
    }
}

-- Scaling limits
Config.scaling = {
    min = 0.1,    -- Minimum scale (10% of original size)
    max = 2.0,    -- Maximum scale (200% of original size)
    scaleSpeed = {
        enabled = false,  -- Enable/disable speed scaling based on size
        inverse = true,   -- Smaller peds move faster, larger peds move slower
    }
}
```

### Permission System

To enable permissions, set `Config.permissions.enabled = true`:

```lua
Config.permissions = {
    enabled = true,
    defaultPermissions = {
        openSelf = true,    -- Players can open their own menu
        openOther = false,  -- Players cannot open others' menus
        resetSelf = true,   -- Players can reset their own scale
        resetOther = false, -- Players cannot reset others' scales
    },
    acePermissions = {
        ["nass_fighting.scaler"] = {  -- ACE permission name
            openSelf = true,
            openOther = true,
            resetSelf = true,
            resetOther = true,
        }
    }
}
```

### Adding ACE Permissions

To give players admin permissions, add this to your `server.cfg`:

```cfg
# Give admin group access to all scaling commands
add_ace group.admin nass_fighting.scaler allow
```

## Usage

### Commands

- `/scale` - Open the scaling menu
- `/scale [playerid]` - Open scaling menu for another player (requires permission)
- `/resetscale` - Reset your scale to default (1.0)
- `/resetscale [playerid]` - Reset another player's scale (requires permission)

### How to Use

1. **Open the Menu**: Type `/scale` in chat or use the command
2. **Adjust Scale**: Use the slider to adjust your character's height
3. **Preview**: See the changes in real-time as you move the slider
4. **Apply**: Click "Apply" to save your scale permanently
5. **Close**: Click "Close" to exit without saving changes

### Important Notes

- **Vehicle Scaling**: When entering/exiting vehicles, your scale resets to 1.0
- **Terrain Changes**: You may notice slight scale adjustments when changing terrain
- **Persistence**: Your scale is saved and will be restored when you reconnect

## Troubleshooting

### Common Issues

**Script won't start:**
- Check that you have the correct framework installed
- Ensure the resource is in the correct folder
- Verify your `server.cfg` has `ensure nass_pedscaler`

**Menu won't open:**
- Check console for error messages
- Verify you have permission to use the command
- Try restarting the resource: `restart nass_pedscaler`

**Scale not syncing between players:**
- Check that the script is running on both client and server
- Verify network events are working properly
- Try restarting the resource

**Web interface not loading:**
- Check that `web/build/` folder contains the necessary files
- Verify your FiveM server has proper file permissions
- Clear browser cache if using web interface

### Performance Issues

If you experience performance issues:
- Reduce the scaling update frequency in the client script
- Limit the number of players who can use scaling simultaneously
- Consider disabling `scaleSpeed` feature if not needed

### Getting Help

If you're still having issues:

1. **Check the Console**: Look for error messages in your server console
2. **Join our Discord**: Get real-time support from our community
3. **Create an Issue**: Report bugs on our GitHub repository

## Support & Community

If you have any questions, need help, or want to connect with other users, **join our Discord community!**  
We're always happy to help and hear your feedback.

👉 [Join our Discord](https://discord.gg/nass)

By joining, you can:
- Get real-time support
- Suggest new features
- Stay updated with the latest news
- Support the project and help us grow!

## Contributing

We welcome contributions! Please create pull requests or directly contact me on discord.

## License

This script is provided as-is. Please respect the terms of use and support the developers.

---

Thank you for using our script. Your support means a lot to us!
