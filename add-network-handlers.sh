#!/bin/bash
# This script adds the network setup IPC handlers to index.ts

# Line number after which to insert (after the export-logs handler)
LINE_NUM=241

# Create the handlers to insert
cat > /tmp/handlers.txt << 'HANDLERS'
  ipcMain.handle('create-network', async () => {
    const crypto = require('crypto');
    const randomSeed = crypto.randomBytes(32).toString('hex');
    RUN_OPTIONS.networkSeed = randomSeed;
    console.log('Created new network with seed:', randomSeed);
    return randomSeed;
  });
  
  ipcMain.handle('join-network', async (_e, inviteCode: string) => {
    RUN_OPTIONS.networkSeed = inviteCode;
    console.log('Joining network with seed:', inviteCode);
    return inviteCode;
  });
HANDLERS

# Insert the handlers
sed -i.bak "${LINE_NUM}r /tmp/handlers.txt" src/main/index.ts

echo "Handlers added after line $LINE_NUM"
