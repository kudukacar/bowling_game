require 'spec_helper'

class BowlingGame
  def initialize
    @rolls = []
  end

  def roll(pins)
    @rolls << pins
  end

  def score
    frame_index = 0
    score = 0
    10.times do
      if is_strike?(frame_index)
        score += 10 + strike_bonus(frame_index)
        frame_index += 1
      elsif is_spare?(frame_index)
        score += 10 + spare_bonus(frame_index)
        frame_index += 2
      else
        score += frame_score(frame_index)
        frame_index += 2
      end
    end
    score
  end

  def is_spare?(frame_index)
    @rolls[frame_index] + @rolls[frame_index + 1] == 10
  end

  def is_strike?(frame_index)
    @rolls[frame_index] == 10
  end

  def strike_bonus(frame_index)
    @rolls[frame_index + 1] + @rolls[frame_index + 2]
  end

  def spare_bonus(frame_index)
    @rolls[frame_index + 2]
  end

  def frame_score(frame_index)
    @rolls[frame_index] + @rolls[frame_index + 1]
  end
end

RSpec.describe "BowlingGame" do
  let(:game) { BowlingGame.new }

  def roll_many(n, pins)
    n.times { game.roll(pins) }
  end

  def roll_spare
    2.times { game.roll(5) }
  end

  def roll_strike
    game.roll(10)
  end

  context "with all gutter balls" do
    it "calculates a score of 0" do
      roll_many(20, 0)

      expect(game.score).to eq(0)
    end
  end

  context "with all ones" do
    it "calculates a score of 20" do
      roll_many(20, 1)

      expect(game.score).to eq(20)
    end
  end

  context "with a spare" do
    it "adds the next roll as a bonus to the spare frame's score" do
      roll_spare
      game.roll(3)
      roll_many(17, 0)

      expect(game.score).to eq(16)
    end
  end

  context "with a strike" do
    it "adds the next frame's score as a bonus to the strike's frame's score" do
      roll_strike
      game.roll(3)
      game.roll(4)
      roll_many(16, 0)

      expect(game.score).to eq(24)
    end
  end

  context "with a perfect game of all strikes" do
    it "calculates a score of 300" do
      roll_many(12, 10)

      expect(game.score).to eq(300)
    end
  end
end