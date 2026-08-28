# Improved AuctionHouseBot profile for small TBC servers

This repository extends the existing CMaNGOS AuctionHouseBot. It does not add a second bot and does not require an additional database schema.

## Improvements

- Keeps a configurable minimum and maximum number of bot auctions in each auction house.
- Limits additions per update to avoid large database and server-load spikes.
- Produces varied, configurable stack sizes.
- Rejects bind-on-pickup, quest, conjured, loot-container and over-quality items.
- Applies `AuctionHouseBot.Buy.Value` to player-auction purchases (the previous code loaded but did not apply it).
- Can prevent the bot from bidding on its own auctions.
- Limits bids and buyouts to a configurable maximum price.
- Clears deleted `ahbot_items` overrides correctly on `.ahbot reload`.
- Falls back to the configured static level when no characters are online.

## Build and activation

Configure the core with `-DBUILD_AHBOT=ON`, build and install it, then copy the installed `ahbot.conf.dist` to `ahbot.conf` if no active file exists. Existing `ahbot.conf` files must receive the new options from the current template.

The supplied defaults are intended for roughly 1-20 active players:

- 300 minimum and 600 maximum bot auctions per auction house
- at most 25 new auctions per update
- stack sizes between 20% and 100%
- dynamic player-level filtering, excluding GM accounts
- epic as the highest generated quality
- 65% purchase valuation and a 5,000 gold single-auction limit

After changing the configuration, run `.ahbot reload`. To replace existing bot stock immediately, run `.ahbot rebuild`; use `.ahbot rebuild all` only if auctions with player bids may also expire.

## New configuration options

```ini
AuctionHouseBot.Stock.Min = 300
AuctionHouseBot.Stock.Max = 600
AuctionHouseBot.Stock.BatchSize = 25
AuctionHouseBot.Stack.MinPercent = 20
AuctionHouseBot.Stack.MaxPercent = 100
AuctionHouseBot.Filter.MaxQuality = 4
AuctionHouseBot.Filter.ExcludeQuestItems = 1
AuctionHouseBot.Filter.ExcludeConjuredItems = 1
AuctionHouseBot.Buy.NeverBuyBotAuctions = 1
AuctionHouseBot.Buy.MaxPriceGold = 5000
```

Setting `AuctionHouseBot.Buy.MaxPriceGold` to `0` removes the absolute price limit. Stock limits count only auctions owned by AHBot and apply independently to Alliance, Horde and neutral auction houses.
