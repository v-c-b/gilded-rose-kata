class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name == "Aged Brie" or item.name == "Backstage passes to a TAFKAL80ETC concert" # and item.name != "Sulfuras, Hand of Ragnaros"
        item.quality += 1
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          case item.sell_in
            when 6..10
              item.quality += 1
            when 0..5
              item.quality += 2
          end
        end
      else
        item.quality = [item.quality-1, 0].max
      end
      item.quality = [item.quality, 50].min
      if item.name == "Sulfuras, Hand of Ragnaros"
        item.quality = 80
      else
        item.sell_in -= 1
      end
      if item.sell_in < 0
        item.quality = 0 if item.name == "Backstage passes to a TAFKAL80ETC concert"
        if item.name == "Aged Brie" or item.name == "Sulfuras, Hand of Ragnaros"
          item.quality += 1 if item.quality < 50
        else
          item.quality = [item.quality-1, 0].max
        end
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
