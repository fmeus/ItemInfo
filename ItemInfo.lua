--[[ =================================================================
    Revision:
        $Id: ItemInfo.lua 772 2013-02-05 15:32:54Z fmeus_lgs $
    ================================================================= --]]

-- Local variables
   local ItemInfo = { Hooks = { OnTooltipSetItem = {}, OnTooltipCleared = {} } };

-- Add sell prices to items in your bag (only used if not already at a merchant)
    function ItemInfo:AddInfo( tooltip )
        -- Get the itemLink
        local itemName, itemLink = tooltip:GetItem();

        -- Does the slot contain an item
        if ( itemLink and IsControlKeyDown() ) then
            -- Get item info
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo( itemLink ) ;
            local _, itemid = strsplit( ":", itemLink );

            -- Add info to tooltip
            tooltip:AddLine( "|n" );
            tooltip:AddLine( "Item info" );
            tooltip:AddLine( "  ID = "..itemid );
            tooltip:AddLine( "  Level = "..itemLevel );
            tooltip:AddLine( "  Minimum level = "..itemMinLevel );
            tooltip:AddLine( "  Type = "..itemType );
            tooltip:AddLine( "  Subtype = "..itemSubType );
            tooltip:AddLine( "  Stackcount = "..itemStackCount );
            tooltip:AddLine( "  Equip loc = "..itemEquipLoc );
            tooltip:AddLine( "  Texture = "..itemTexture );
        end;
    end;

-- Install hooks for the tooltips
    function ItemInfo:HookTooltip( tooltip )
        -- Store default script
        local tooltipName = tooltip:GetName();
        ItemInfo.Hooks.OnTooltipSetItem[tooltipName] = tooltip:GetScript( "OnTooltipSetItem" );
        ItemInfo.Hooks.OnTooltipCleared[tooltipName] = tooltip:GetScript( "OnTooltipCleared" );

        -- Set new script to handle OntooltipSetItem
        tooltip:SetScript( "OnTooltipSetItem", function( self, ... )
            -- Get tooltip name
            local tooltipName = self:GetName();

            -- Call default script
            if ( ItemInfo.Hooks.OnTooltipSetItem[tooltipName] ) then
                ItemInfo.Hooks.OnTooltipSetItem[tooltipName]( self, ... );
            end;

            -- Call new script (adds the item information)
            ItemInfo:AddInfo( self );
        end );

        -- Set new script to handle OnTooltipCleared
        tooltip:SetScript( "OnTooltipCleared", function( self, ... )
            -- Get tooltip name
            local tooltipName = self:GetName();

            -- Call default script
            if ( ItemInfo.Hooks.OnTooltipCleared[tooltipName] ) then
                ItemInfo.Hooks.OnTooltipCleared[tooltipName]( self, ... );
            end;
        end );
     end;

-- Handle startup of the addon
    function ItemInfo:Init()
        -- Hook the Tooltips (OnTooltipSetItem, OnTooltipCleared)
        ItemInfo:HookTooltip( GameTooltip );
        ItemInfo:HookTooltip( ItemRefTooltip );
        ItemInfo:HookTooltip( ShoppingTooltip1 );
        ItemInfo:HookTooltip( ShoppingTooltip2 );
        ItemInfo:HookTooltip( ShoppingTooltip3 );
    end;
    
-- Load the addon
    ItemInfo:Init();