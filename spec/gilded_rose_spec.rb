# require File.join(File.dirname(__FILE__), 'gilded_rose')
require './lib/gilded_rose.rb'

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('Aged Brie', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'Aged Brie'
    end
    it 'quality cannot increase above 50 for Brie and backstage ticket items' do
      items = [
        Item.new('Aged Brie', 20, 50),
        Item.new('Backstage passes to a TAFKAL80ETC concert', 20, 50)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 50
      expect(items[1].quality).to eq 50
    end
    it 'quality cannot decrease below 0 for general items and conjured items' do
      items = [
        Item.new('+5 Dexterity Vest', 10, 0),
        Item.new('Elixir of the Mongoose', -1, 0)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 0
      expect(items[1].quality).to eq 0
    end
    it 'quality of Sulfuras does not change' do
      items = [
        Item.new('Sulfuras, Hand of Ragnaros', 10, 80),
        Item.new('Sulfuras, Hand of Ragnaros', -1, 80)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 80
      expect(items[1].quality).to eq 80
    end
    it 'sell-in changes by -1 except for legendary item Sulfuras' do
      items = [
        Item.new('+5 Dexterity Vest', 10, 0),
        Item.new('Elixir of the Mongoose', -1, 0),
        Item.new('Sulfuras, Hand of Ragnaros', 10, 80),
        Item.new('Conjured Mana Cake', 10, 80),
        Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 10)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 9
      expect(items[1].sell_in).to eq(-2)
      expect(items[2].sell_in).to eq 10
      expect(items[3].sell_in).to eq 9
      expect(items[4].sell_in).to eq 2
    end
  end

  describe 'normal item behaviour' do
    it 'changes quality by -1 if sell_in is positive' do
      items = [
        Item.new('+5 Dexterity Vest', 1, 10),
        Item.new('Elixir of the Mongoose', 1, 5)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 9
      expect(items[1].quality).to eq 4
    end
    it 'changes quality by -2 if sell_in is 0 or negative' do
      items = [
        Item.new('+5 Dexterity Vest', 0, 10),
        Item.new('Elixir of the Mongoose', -2, 5)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 8
      expect(items[1].quality).to eq 3
    end
  end

  describe 'conjured item behaviour' do
    it 'changes quality by -2 if sell_in is positive' do
      items = [
        Item.new('Conjured Mana Cake', 1, 10),
        Item.new('Conjured Mana Cake', 1, 1)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 8
      expect(items[1].quality).to eq 0
    end
    it 'changes quality by -4 if sell_in is 0 or negative' do
      items = [
        Item.new('Conjured Mana Cake', -1, 10),
        Item.new('Conjured Mana Cake', -1, 1)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 6
      expect(items[1].quality).to eq 0
    end
  end

  describe 'Aged Brie item behaviour' do
    it 'changes quality by +1 if sell_in is positive' do
      items = [
        Item.new('Aged Brie', 1, 49),
        Item.new('Aged Brie', 50, 0)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 50
      expect(items[1].quality).to eq 1
    end
    it 'changes quality by +2 if sell_in is 0 or negative' do
      items = [
        Item.new('Aged Brie', 0, 48),
        Item.new('Aged Brie', -10, 48)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 50
      expect(items[1].quality).to eq 50
    end
  end

  describe 'Backstage ticket item behaviour' do
    it 'changes quality by +1 if sell_in is 10 days away or more' do
      items = [
        Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 10),
        Item.new('Backstage passes to a TAFKAL80ETC concert', 50, 10)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 11
      expect(items[1].quality).to eq 11
    end
    it 'changes quality by +2 if sell_in is between 10 and 6 days' do
      items = [
        Item.new('Backstage passes to a TAFKAL80ETC concert', 8, 20),
        Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 20)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 22
      expect(items[1].quality).to eq 22
    end
    it 'changes quality by +3 if sell_in is between 5 and 1 days' do
      items = [
        Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 20),
        Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 20)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 23
      expect(items[1].quality).to eq 23
    end
    it 'changes quality to 0 if sell_in has passed' do
      items = [
        Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 20),
        Item.new('Backstage passes to a TAFKAL80ETC concert', -1, 20)
      ]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 0
      expect(items[1].quality).to eq 0
    end
  end
end
