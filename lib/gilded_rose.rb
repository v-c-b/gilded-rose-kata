class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        case item.sell_in
        when 6..10
          item.quality += 3
        when 1..5
          item.quality += 4
        when -Float::INFINITY..0
          item.quality = 0
        else
          item.quality += 2
        end
      end
      if item.name == "Aged Brie"
        case item.sell_in
        when 1..Float::INFINITY
          item.quality = [item.quality+1, 50].min
        when -Float::INFINITY..0
          item.quality = [item.quality+2, 50].min
        end
      end
      if item.sell_in < 1 and item.name != "Aged Brie"
        item.quality = [item.quality-1, 0].max
      end
      item.quality = [[item.quality-1, 0].max,50].min if item.name != "Aged Brie"
      if item.name == "Sulfuras, Hand of Ragnaros"
        item.quality = 80
        item.sell_in += 1
      end
      item.sell_in -= 1
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
