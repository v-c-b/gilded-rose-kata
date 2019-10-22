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
        when 0..5
          item.quality += 4
        else
          item.quality += 2
        end
      end
      item.quality += 2 if item.name == 'Aged Brie'
      item.quality = [[item.quality-1, 0].max,50].min
      item.sell_in -= 1
      if item.sell_in < 0
        item.quality = [item.quality-1, 0].max
        item.quality = [item.quality+2, 50].min if item.name == "Aged Brie"
        item.quality = 0 if item.name == "Backstage passes to a TAFKAL80ETC concert"
      end
      if item.name == "Sulfuras, Hand of Ragnaros"
        item.quality = 80
        item.sell_in += 1
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
