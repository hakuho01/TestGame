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

$player_actions = [1, 2, 3]
$actions_slot = []

$scene = :map

font_fff16 = Font.new(16, 'ヒラギノ角ゴ')
font_fff12 = Font.new(12, 'ヒラギノ角ゴ')

Image.register(:enemy1, 'images/enemy1.png')
Image.register(:enemy2, 'images/enemy2.png')
Image.register(:enemy3, 'images/enemy3.png')
Image.register(:background, 'images/background.png')
Image.register(:bg_spring, 'images/bg_spring.png')
Image.register(:bg_battle, 'images/bg_battle.png')
Image.register(:bg_event, 'images/bg_event.png')

# ACTIONテーブル
ACTIONS = [1, 2, 3, 4, 5, 6, 7, 8]

# 敵情報
ENEMIES = [
  { id: 1, name: 'らすねこ', hp: 50, atk: 15, def: 5, actions: [1, 1, 2, 3], award: { status: 'max_hp', value: 5 } },
  { id: 2, name: 'マゾ', hp: 60, atk: 22, def: 10, actions: [1, 1, 2, 3], award: { status: 'def', value: 5 } },
  { id: 3, name: '塩屋', hp: 80, atk: 25, def: 8, actions: [1, 1, 2, 2], award: { status: 'atk', value: 5 } }
]

# Mapクラス
class Map
  def initialize
    $floor = 1
    $branch_num = 0
  end

  def execute_map
    if $branch_num == 0
      $branches = []
      $branch_num = rand(1..3)
      $branch_num.times do
        $branches.push([:battle, :event, :rest].sample)
      end
    end

    case $branch_num
    when 1
      $message = '先へ進む'
      if Input.key_push?(K_ENTER)
        $floor += 1
        $scene = $branches[0]
        go_scene($scene)
      end
    when 2
      $message = 'どこへ進む？1.左　2.右'
      if Input.key_push?(K_1)
        $floor += 1
        $scene = $branches[0]
        go_scene($scene)
      elsif Input.key_push?(K_2)
        $floor += 1
        $scene = $branches[1]
        go_scene($scene)
      end
    when 3
      $message = 'どこへ進む？1.左　2.真ん中　3.右'
      if Input.key_push?(K_1)
        $floor += 1
        $scene = $branches[0]
        go_scene($scene)
      elsif Input.key_push?(K_2)
        $floor += 1
        $scene = $branches[1]
        go_scene($scene)
      elsif Input.key_push?(K_3)
        $floor += 1
        $battle = Battle.new
        $scene = $branches[2]
        go_scene($scene)
      end
    end
  end
end

def go_scene(scene)
  case scene
  when :battle
    $battle = Battle.new
  when :event
    $event_id = rand(1..2)
    $event = Event.new
  when :rest
    $rest = Rest.new
  end
  $branch_num = 0
  $scene = :ending if $floor == 10
  fade_in
end

# Restクラス
class Rest
  def initialize
    @rest_step = 0
  end

  def execute_rest
    $title = '回復の温泉'
    case @rest_step
    when 0
      $message = 'どうする？ 1.休憩 2.強化 3.鍛錬'
      if Input.key_push?(K_1)
        $player_stats[:hp] += ($player_stats[:max_hp] * 0.3).floor
        $player_stats[:hp] = $player_stats[:max_hp] if $player_stats[:hp] > $player_stats[:max_hp]
        @rest_step = 1
      elsif Input.key_push?(K_2)
        grow_stats = [:max_hp, :atk, :def].sample
        $player_stats[grow_stats] = ($player_stats[grow_stats] * 1.1).floor
        @rest_step = 2
      elsif Input.key_push?(K_3)
        unaq_actions = ACTIONS - $player_actions
        $player_actions.push(unaq_actions.sample)
        @rest_step = 3
      end
    when 1 # 休憩
      $message = '温泉に浸かって体力が回復した'
      $scene = :map if Input.key_push?(K_ENTER)
    when 2 # 強化
      $message = '温泉の湯を飲んでステータスが上昇した'
      $scene = :map if Input.key_push?(K_ENTER)
    when 3 # 鍛錬
      $message = '鍛錬して新たな技能を身につけた'
      $scene = :map if Input.key_push?(K_ENTER)
    end
  end
end

# イベントクラス
class Event
  def initialize
    $steps = 0
  end

  def execute_event(event_id)
    case event_id
    when 1
      $title = 'おぼろの秘密研究室'
      case $steps
      when 0
        $message = 'おぼろ「やぁ！」'
        $steps += 1 if Input.key_push?(K_ENTER)
      when 1
        $message = 'おぼろ「研究の成果を君にも分けてあげよう！」'
        if Input.key_push?(K_ENTER)
          $player_stats[:atk] = ($player_stats[:atk] * 1.1).floor
          $steps += 1
        end
      when 2
        $message = '攻撃力が上がった'
        $scene = :map if Input.key_push?(K_ENTER)
      end
    when 2
      $title = '三十三間堂'
      case $steps
      when 0
        $message = '1000ju「お前、手2本しかないの？」'
        $steps += 1 if Input.key_push?(K_ENTER)
      when 1
        if $player_actions.include?(8)
          $message = '1000ju「いや、なんでもない」'
          $steps = 3 if Input.key_push?(K_ENTER)
        else
          $message = '1000ju「けどまあ2本の手でそれぞれ攻撃すれば2回攻撃できるじゃん」'
          if Input.key_push?(K_ENTER)
            $player_actions.push(8)
            $steps = 2
          end
        end
      when 2
        $message = '双撃を覚えた'
        $scene = :map if Input.key_push?(K_ENTER)
      when 3
        $message = '1000juはパチンコを打ちに行ってしまった'
        $scene = :map if Input.key_push?(K_ENTER)
      end
    when 3
    end
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
    $enemy_max_hp = $enemy_data[:hp]
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
    @win_step = 0
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
        tmp_actions = $player_actions.dup
        3.times do
          act = tmp_actions.delete_at(rand(tmp_actions.length))
          $actions_slot << act
        end
        $actions_slot = $actions_slot.sort
      end

      # ステータス変化の初期化
      $player_stats[:tmp_def] = 0

      $message = "1. #{action.fetch_action($actions_slot[0])[:name]} 2. #{action.fetch_action($actions_slot[1])[:name]} 3. #{action.fetch_action($actions_slot[2])[:name]}"

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
      #elsif Input.key_push?(K_4)
      #  $player_action_name = action.fetch_action($actions_slot[3])[:name]
      #  action.execute_action($actions_slot[3])
      end
    when :player_effect
      $actions_slot = []
      if Input.key_push?(K_ENTER)
        $battle_phase = :enemy_action
        $battle_phase = :player_win if $enemy_hp.zero?
      end
    when :enemy_action
      $enemy_tmp_def = 0
      $message = "#{$enemy_name}の行動！"
      if Input.key_push?(K_ENTER)
        # 敵の行動処理
        $enemy_action.execute_action($enemy_action_id)
        $battle_phase = :enemy_effect
      end
    when :enemy_effect
      $enemy_action_id = 0
      if $player_stats[:hp] == 0
        $battle_phase = :player_lose
      end
      $battle_phase = :player_action if Input.key_push?(K_ENTER)
    when :player_win
      case @win_step
      when 0
        $message = '勝利した'
        if Input.key_push?(K_ENTER)
          $player_stats[$enemy_data[:award][:status]] = $player_stats[$enemy_data[:award][:status]] + $enemy_data[:award][:value]
          @win_step += 1
        end
      when 1
        $message = 'ステータスが上昇した'
        if Input.key_push?(K_ENTER)
          $scene = :map
        end
      end
    when :player_lose
      $message = '敗北した'
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
      { name: '激昂' }
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
      $player_stats[:tmp_atk] = $player_stats[:tmp_atk] + ($player_stats[:atk] * 0.05).floor

      $message = '集中して力を溜めている'

      $battle_phase = :player_effect
    when 6 # 回復
      $player_gain_hp = ($player_stats[:max_hp] - $player_stats[:hp]).positive? ? (($player_stats[:max_hp] - $player_stats[:hp])**(1 / 2.0)).floor : 0
      $player_stats[:hp] = $player_stats[:hp] + $player_gain_hp

      $message = "食料を食べて#{$player_gain_hp}回復した"

      $battle_phase = :player_effect
    when 7 # 激昂
      $player_stats[:tmp_atk] = $player_stats[:tmp_atk] + ($player_stats[:atk] * 0.15).floor

      $message = '激昂して攻撃力が上がった'

      $battle_phase = :player_effect
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

def fade_in
  $fade_flg = true
  $fade_frames = 45
end

# メインループ
Window.load_resources do
  $event = Event.new
  $map = Map.new
  $rest = Rest.new
  Window.loop do
    frame_count += 1

    case $scene
    when :map
      $title = '進む道を選べ'
      $map.execute_map
    when :battle
      $title = "#{$enemy_name}が現れた"
      $battle.execute_battle
    when :event
      $event.execute_event($event_id)
    when :rest
      $rest.execute_rest
    end

    #---- 描画処理 ----
    $status = "体力:#{$player_stats[:hp]}/#{$player_stats[:max_hp]} 攻撃力:#{$player_stats[:atk]}(+#{$player_stats[:tmp_atk]}) 防御力:#{$player_stats[:def]}(+#{$player_stats[:tmp_def]})"

    # 背景
    case $scene
    when :rest
      Window.draw(0, 0, Image[:bg_spring])
    when :battle
      Window.draw(0, 0, Image[:bg_battle])
    when :event
      Window.draw(0, 0, Image[:bg_event])
    else
      Window.draw(0, 0, Image[:background])
    end

    if $scene == :map
      $branches.each_with_index do |branch, i|
        Window.draw_font(180 + 80 * i, 140, "#{branch}", font_fff16)
      end
    end

    # 敵
    if $scene == :battle
      Window.draw_font(400, 140, "#{$enemy_name}", font_fff16)
      Window.draw_box_fill(400, 166, 480, 175, [0, 0, 0])
      Window.draw_box_fill(400, 166, 400 + (80 * $enemy_hp / $enemy_max_hp).floor, 175, [0, 255, 0])
      Window.draw_font(400, 180, "#{$enemy_hp}/#{$enemy_max_hp}", font_fff12)
      Window.draw_font(400, 210, "#{$enemy_action_name}", font_fff12)
      Window.draw(150, 156, Image['enemy'+$enemy_data[:id].to_s])
    end

    # テキストウィンドウ
    Window.draw_box_fill(0, 360, Window.width, Window.height, [0, 0, 0])
    Window.draw_font(8, 368, $message, font_fff16)
    # ステータス
    Window.draw_font(8, Window.height - 24, $status, font_fff16)
    Window.draw_font(Window.width - font_fff16.get_width("#{$floor}F") - 8, Window.height - 24, "#{$floor}F", font_fff16)
    # タイトル行
    Window.draw_box_fill(0, 0, Window.width, 48, [0, 0, 0])
    Window.draw_font((Window.width - font_fff16.get_width($title)) / 2, 16, $title, font_fff16)

    if $scene == :ending
      Window.draw_box_fill(0, 0, Window.width, Window.height, [0, 0, 0])
      Window.draw_font((Window.width - font_fff16.get_width('THE END')) / 2, 360, 'THE END', font_fff16)
    end

    if $fade_flg
      Window.draw_box_fill(0, 0, Window.width, Window.height, [(255 / 60 * $fade_frames).floor, 0, 0, 0])
      $fade_frames -= 1
      $fade_flg = false if $fade_frames == 0
    end
  end
end
