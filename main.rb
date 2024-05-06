require 'dxopal'
include DXOpal

Window.bgcolor = [0, 0, 0]

frame_count = 0
$event_id = 1

$player_stats = {
  max_hp: 100,
  hp: 100,
  atk: 20,
  tmp_atk: 0,
  def: 10,
  tmp_def: 0
}

$actions = [1, 2, 3, 4, 5, 6, 8]
$actions_slot = []

$scene = :map

textfont = Font.new(16, 'ヒラギノ角ゴ')

Image.register(:cat1, 'images/cat_1.png')
Image.register(:background, 'images/background.png')

# 敵情報
ENEMIES = [
  { id: 1, name: 'らすねこ', hp: 50, atk: 15, def: 5, actions: [1, 1, 2, 3], award: { status: 'max_hp', value: 1 } },
  { id: 2, name: 'らすねこ2', hp: 60, atk: 17, def: 10, actions: [1, 1, 2, 3], award: { status: 'def', value: 2 } },
  { id: 3, name: 'らすねこ3', hp: 40, atk: 20, def: 3, actions: [1, 1, 2, 2], award: { status: 'atk', value: 2 } }
]

# Mapクラス
class Map
  def initialize
    $floor = 1
  end

  def execute_map
    $message = 'どこへ進む？1.左　2.真ん中　3.右'
    if Input.key_push?(K_1)
      $floor += 1
      $battle = Battle.new
      $scene = :battle
      $scene = :ending if floor == 10
    elsif Input.key_push?(K_2)
      $floor += 1
      $battle = Battle.new
      $scene = :battle
      $scene = :ending if floor == 10
    elsif Input.key_push?(K_3)
      $floor += 1
      $battle = Battle.new
      $scene = :battle
      $scene = :ending if floor == 10
    end
  end
end

# イベントクラス
class Event
  def execute_event
  end
end

# Battleクラス
class Battle
  def initialize
    # TODO: 階層データからランダムに敵idを抽出
    $enemy_data = ENEMIES.sample

    # 敵idから各変数を代入
    $enemy_name = $enemy_data[:name]
    $enemy_hp = $enemy_data[:hp]
    $enemy_atk = $enemy_data[:atk]
    $enemy_def = $enemy_data[:def]
    $enemy_actions = $enemy_data[:actions]

    # 変数初期化
    $player_stats[:tmp_atk] = 0
    $player_stats[:tmp_def] = 0
    $enemy_action_id = 0
    $enemy_tmp_atk = 0
    $enemy_tmp_def = 0
    $battle_phase = :player_action
  end

  def execute_battle
    case $battle_phase
    when :player_action
      action = Action.new
      $enemy_action = EnemyAction.new

      # 敵の行動とプレイヤーの行動スロットの設定
      if $enemy_action_id.zero?
        $enemy_action_id = $enemy_actions.sample
        $enemy_action_name = $enemy_action.fetch_action($enemy_action_id)[:name]
      end
      if $actions_slot.empty?
        tmp_actions = $actions.dup
        4.times do
          act = tmp_actions.delete_at(rand(tmp_actions.length))
          $actions_slot << act
        end
        $actions_slot = $actions_slot.sort
      end

      # ステータス変化の初期化
      $player_tmp_def = 0

      $message = "1. #{action.fetch_action($actions_slot[0])[:name]} 2. #{action.fetch_action($actions_slot[1])[:name]} 3. #{action.fetch_action($actions_slot[2])[:name]} 4. #{action.fetch_action($actions_slot[3])[:name]}"

      # プレイヤーの行動処理
      if Input.key_push?(K_1)
        $player_action_name = action.fetch_action($actions_slot[0])[:name]
        action.execute_action($actions_slot[0])
      elsif Input.key_push?(K_2)
        $player_action_name = action.fetch_action($actions_slot[1])[:name]
        action.execute_action($actions_slot[1])
      elsif Input.key_push?(K_3)
        $player_action_name = action.fetch_action($actions_slot[2])[:name]
        action.execute_action($actions_slot[2])
      elsif Input.key_push?(K_4)
        $player_action_name = action.fetch_action($actions_slot[3])[:name]
        action.execute_action($actions_slot[3])
      end
    when :player_effect
      $actions_slot = []
      if Input.key_push?(K_ENTER)
        $battle_phase = :enemy_action
        $battle_phase = :player_win if $enemy_hp.zero?
      end
    when :enemy_action
      $enemy_tmp_def = 0
      $message = '敵の行動！'
      if Input.key_push?(K_ENTER)
        # 敵の行動処理
        $enemy_action.execute_action($enemy_action_id)
        $battle_phase = :enemy_effect
      end
    when :enemy_effect
      $enemy_action_id = 0
      $battle_phase = :player_action if Input.key_push?(K_ENTER)
    when :player_win
      $message = '勝利した。ステータスが上昇した'
      if Input.key_push?(K_ENTER)
        $player_stats[$enemy_data[:award][:status]] = $player_stats[$enemy_data[:award][:status]] + $enemy_data[:award][:value]
        $scene = :map
      end
    end
  end
end

# アクションクラス
class Action
  def fetch_action(id)
    case id
    when 1
      { name: '攻撃' }
    when 2
      { name: '警戒' }
    when 3
      { name: '防御' }
    when 4
      { name: '貫通' }
    when 5
      { name: '集中' }
    when 6
      { name: '回復' }
    when 7
      { name: '魔法' }
    when 8
      { name: '二段攻撃' }
    end
  end

  def execute_action(id)
    case id
    when 1 # 攻撃
      $player_dmg = $player_stats[:atk] + $player_stats[:tmp_atk]
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "#{$player_action_name}！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 2 # 警戒
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 0.5).floor
      $player_stats[:tmp_def] = ($player_stats[:def] * 0.3).floor
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "防御の構えを取りながら攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 3 # 防御
      $player_stats[:tmp_def] = ($player_stats[:def] * 1.8).floor

      $message = '防御の構えに入った'

      $battle_phase = :player_effect
    when 4 # 貫通
      $player_dmg = $player_stats[:atk] + $player_stats[:tmp_atk]
      $total_give_dmg = $player_dmg
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "相手の防御を崩す攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 5 # 集中
      $player_stats[:tmp_atk] = ($player_stats[:atk] * 0.05).floor

      $message = '集中して力を溜めている'

      $battle_phase = :player_effect
    when 6 # 回復
      $player_gain_hp = ($player_stats[:max_hp] - $player_stats[:hp]).positive? ? (($player_stats[:max_hp] - $player_stats[:hp])**(1 / 2.0)).floor : 0
      $player_stats[:hp] = $player_stats[:hp] + $player_gain_hp

      $message = "食料を食べて#{$player_gain_hp}回復した"

      $battle_phase = :player_effect
    when 7 # 魔法
    when 8 # 二段攻撃
      $player_dmg = $player_stats[:atk] + $player_stats[:tmp_atk]
      $total_give_dmg = $player_dmg * 2 - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "#{$player_action_name}！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    end
  end
end

# エネミーアクションクラス
class EnemyAction
  def fetch_action(id)
    case id
    when 1
      { name: '攻撃' }
    when 2
      { name: '警戒' }
    when 3
      { name: '防御' }
    end
  end

  def execute_action(id)
    case id
    when 1
      $enemy_dmg = $enemy_atk + $enemy_tmp_atk
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg
      $player_stats[:hp] = 0 if $player_stats[:hp] < 1

      $message = "#{$enemy_action_name}！#{$total_take_dmg}ダメージを受けた"
    when 2
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 0.5).floor
      $enemy_tmp_def = ($enemy_def * 0.3).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def]- $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg
      $player_stats[:hp] = 0 if $player_stats[:hp] < 1

      $message = "#{$enemy_action_name}！#{$total_take_dmg}ダメージを受けた"
    when 3
      $enemy_tmp_def = ($enemy_def * 1.8).floor

      $message = '防御の構えに入った'
    end
  end
end

# メインループ
Window.load_resources do
  $event = Event.new
  $map = Map.new
  Window.loop do
    frame_count += 1

    case $scene
    when :map
      $map.execute_map
    when :battle
      $battle.execute_battle
    when :event
      $event.execute_event
    end

    #---- 描画処理 ----
    $status = "HP:#{$player_stats[:hp]}/#{$player_stats[:max_hp]} ATK:#{$player_stats[:atk]}(+#{$player_stats[:tmp_atk]}) DEF:#{$player_stats[:def]}(+#{$player_stats[:tmp_def]})"

    # 背景
    Window.draw(0, 0, Image[:background])

    # 敵
    if $scene == :battle
      Window.draw_font(250, 120, "#{$enemy_action_name}", textfont)
      Window.draw_font(250, 280, "#{$enemy_name} HP:#{$enemy_hp}", textfont)
      Window.draw(200, 156, Image[:cat1])
    end

    # テキストウィンドウ
    Window.draw_box_fill(0, 360, Window.width, Window.height, [0, 0, 0])
    Window.draw_font(0, 360, $message, textfont)
    # ステータス
    Window.draw_box_fill(0, 0, Window.width, 36, [0, 0, 0])
    Window.draw_font(0, 0, $status, textfont)
    Window.draw_font(Window.width - 40, 0, "#{$floor}F", textfont)

    if $scene == :ending
      Window.draw_box_fill(0, 0, Window.width, Window.height, [0, 0, 0])
      Window.draw_font(0, 360, 'THE END', textfont)
    end
  end
end

# Window.bgcolor = [120, 12, 12]
# textfont = Font.new(16, font_name="meiryo")
# frame_count = 0
# GROUND_Y = 420

# Image.register(:cat1, 'images/cat_1.png')
# Image.register(:cat2, 'images/cat_2.png')
# Image.register(:cat3, 'images/cat_3.png')
# Image.register(:cat4, 'images/cat_4.png')
# Image.register(:cat5, 'images/cat_5.png')
# Image.register(:cat6, 'images/cat_6.png')
# Image.register(:cat7, 'images/cat_7.png')

# Window.load_resources do

#   Window.loop do
#     frame_count += 1
#     if frame_count == 60
#       frame_count = 0
#     end

#     Window.draw_box_fill(0, 0, Window.width, GROUND_Y, [149, 200, 255])
#     Window.draw_box_fill(0, GROUND_Y, Window.width, Window.height, [105, 187, 89])

#     Window.draw((frame_count / 4).floor * 20, 360, Image["cat#{(frame_count / 4).floor % 7 + 1}"])
#   end
# end
