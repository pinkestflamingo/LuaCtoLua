# LuaCtoLua
Very simple process, nothing much but could be fun to play with.
Example input:
```
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 Mesh
getfield -1 Destroy
pushvalue -2
pcall 1 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 face
getfield -1 Destroy
pushvalue -2
pcall 1 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getglobal Instance
getfield -1 new
pushstring SpecialMesh
pushvalue -4
pcall 2 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 Mesh
pushstring rbxassetid://23265118
setfield -2 MeshId
pcall 1 0 0
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Head
getfield -1 Mesh
pushstring rbxassetid://450502375
setfield -2 TextureId
```

Output:
```lua
--; Converted from LuaC to Lua using Dimenzia™
local v1 = game;
local v2 = v1['GetService'];
local v3 = v1;
local v4 = 'Players';
local v5 = v2(v3, v4);
local v6 = v5['LocalPlayer'];
local v7 = v6['Character'];
local v8 = v7['Head'];
local v9 = v8['Mesh'];
local v10 = v9['Destroy'];
local v11 = v9;
v10(v11);
local v12 = game;
local v13 = v12['GetService'];
local v14 = v12;
local v15 = 'Players';
local v16 = v13(v14, v15);
local v17 = v16['LocalPlayer'];
local v18 = v17['Character'];
local v19 = v18['Head'];
local v20 = v19['face'];
local v21 = v20['Destroy'];
local v22 = v20;
v21(v22);
local v23 = game;
local v24 = v23['GetService'];
local v25 = v23;
local v26 = 'Players';
local v27 = v24(v25, v26);
local v28 = v27['LocalPlayer'];
local v29 = v28['Character'];
local v30 = v29['Head'];
local v31 = Instance;
local v32 = v31['new'];
local v33 = 'SpecialMesh';
local v34 = v30;
v32(v33, v34);
local v35 = game;
local v36 = v35['GetService'];
local v37 = v35;
local v38 = 'Players';
local v39 = v36(v37, v38);
local v40 = v39['LocalPlayer'];
local v41 = v40['Character'];
local v42 = v41['Head'];
local v43 = v42['Mesh'];
local v44 = 'rbxassetid://23265118';
v43['MeshId'] = v44;
v42(v43);
local v44 = game;
local v45 = v44['GetService'];
local v46 = v44;
local v47 = 'Players';
local v48 = v45(v46, v47);
local v49 = v48['LocalPlayer'];
local v50 = v49['Character'];
local v51 = v50['Head'];
local v52 = v51['Mesh'];
local v53 = 'rbxassetid://450502375';
v52['TextureId'] = v53;
```
