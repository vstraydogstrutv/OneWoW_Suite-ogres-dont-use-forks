# 🧭 OneWoW Quest Catalog Integration (WIP)

This module introduces a fully integrated **Quest Database + NPC Linking system** into the OneWoW ecosystem, expanding the **Catalog → Quests** tab into a dynamic, searchable, and self-building knowledge system.

---

## 🚀 Overview

The goal of this project is to create a **comprehensive, self-healing quest database** that:

* Tracks **all quests in the game**
* Links quests to **NPCs, maps, and zones**
* Integrates directly into **OneWoW’s Catalog and Notes systems**
* Automatically builds data through **normal gameplay**
* Provides **cross-character completion tracking** (planned/partial)

---

## 🧠 Key Features Implemented

### ✅ Self-Healing Quest Database

* Intelligent merge system prevents bad data overwrites
* Automatically upgrades:

  * NPC data
  * Coordinates
  * Metadata
* Prioritizes higher-quality sources:

  * `world_quest_poi > quest_giver > fallback`

---

### ✅ Automatic NPC Capture (Quest Givers)

* On quest accept:

  * Captures `npcID`, name, map, coordinates
  * Stores in quest DB (`data.start`)
* Automatically adds NPCs to OneWoW Notes:

  * No targeting required
  * No manual “Add Note” needed
* Categorized as **"Quest Giver"**

---

### ✅ Seamless Notes Integration

* Uses native OneWoW Notes system:

  * `notes.NPCs:AddNPC(...)`
  * `pendingNPCSelect`
* Clicking a quest giver:

  * Opens **Notes → NPC tab**
  * Automatically selects the NPC
* Fully compatible with existing OneWoW UI/UX

---

### ✅ Map Integration (Blizzard + Fallback Hybrid)

* Clicking MapID:

  * Uses `C_SuperTrack.SetSuperTrackedQuestID` when available
  * Falls back to waypoint if not
* Guarantees:

  * Map opens
  * Visual feedback (POI or waypoint)
  * Minimap arrow guidance

---

### ✅ Quest ↔ NPC Linking System

Each NPC stores linked quests:

```lua
npcID = {
    name = "...",
    quests = {
        [questID] = true
    }
}
```

Enables:

* Reverse lookup (NPC → quests)
* Future UI expansion (quest lists per NPC)

---

### ✅ Modern API Compliance (Dragonflight+)

* Uses:

  * `C_QuestLog`
  * `C_TaskQuest`
  * `C_Map`
* Removed deprecated APIs
* Added nil-safe handling for async data

---

### ✅ World Quest Filtering

* Prevents invalid NPC entries
* Keeps Notes DB clean and relevant

---

## 📁 File Structure

```
OneWoW_CatalogData_Quests/
│
├── Core/
│   ├── Core.lua
│   ├── MapUtils.lua
│
├── Modules/
│   ├── QuestScanner.lua
│   ├── QuestData.lua
│   ├── QuestIndex.lua
│   ├── QuestNPCLink.lua
│   ├── QuestFavorites.lua
│   ├── CompletionTracker.lua
│
├── UI/
│   ├── t-quests.lua
│
└── Data/
    ├── (future expansion modules / DB)
```

---

## 🆕 Files Created

```
Core/MapUtils.lua
Modules/QuestIndex.lua
Modules/QuestNPCLink.lua
Modules/QuestFavorites.lua
```

---

## ✏️ Files Modified

```
Core/Core.lua
Modules/QuestScanner.lua
Modules/QuestData.lua
Modules/CompletionTracker.lua
UI/t-quests.lua
```

---

## 🔄 Systems Added

### 🔹 Quest Capture Pipeline

* Hooks into quest log
* Builds structured quest data
* Stores into persistent DB

---

### 🔹 NPC Auto-Registration

* Injects directly into OneWoW Notes DB
* Bypasses manual UI workflows

---

### 🔹 Navigation Bridge

* Quest UI → Notes (NPC tab)
* Uses:

  * `OneWoW_Notes.pendingNPCSelect`
  * `OneWoW.GUI:Show("notes")`

---

## 🧪 Current Behavior

### ✔ Accepting a Quest

* NPC automatically added to Notes
* Stored with location and metadata

---

### ✔ Viewing a Quest

* Displays full metadata
* Clickable:

  * Map ID → opens map
  * Quest Giver → opens NPC panel

---

### ✔ Clicking Quest Giver

* Opens Notes → NPC tab
* Selects NPC automatically
* No target required

---

## 🔮 Planned Enhancements

* [ ] Display **quests inside NPC panel**
* [ ] Quest chain visualization
* [ ] Favorites system integration
* [ ] Alt completion tracking UI
* [ ] Advanced filtering (zone, expansion, NPC)
* [ ] Tooltip enhancements (hover data)

---

## 🧠 Design Philosophy

* **Zero user friction**
* **Data builds itself through gameplay**
* **Leverage existing OneWoW systems (not replace them)**
* **Modular and expansion-friendly**
* **Performance-conscious (minimal API calls)**

---

## ⚠️ Notes

* World quests intentionally excluded from NPC auto-registration
* Some quest data (e.g., descriptions) must be cached manually
* NPC creation mirrors OneWoW’s internal structure for compatibility

---

## 🏁 Summary

This system transforms the Quest Catalog into a:

> **Persistent, self-building knowledge layer for World of Warcraft**

It bridges:

* Quests
* NPCs
* Maps
* Player progression

All while remaining fully compatible with OneWoW’s architecture.
