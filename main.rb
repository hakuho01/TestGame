require 'dxopal'
include DXOpal

Window.bgcolor = [0, 0, 0]

font_fff16 = Font.new(16, 'ヒラギノ角ゴ')
font_fff14 = Font.new(14, 'ヒラギノ角ゴ')
font_fff12 = Font.new(12, 'ヒラギノ角ゴ')

Image.register(:enemy1, 'images/enemy1.png')
Image.register(:enemy2, 'images/enemy2.png')
Image.register(:enemy3, 'images/enemy3.png')
Image.register(:enemy4, 'images/enemy4.png')
Image.register(:enemy5, 'images/enemy5.png')
Image.register(:enemy6, 'images/enemy6.png')
Image.register(:enemy7, 'images/enemy7.png')
Image.register(:enemy8, 'images/enemy8.png')
Image.register(:enemy9, 'images/enemy9.png')
Image.register(:enemy10, 'images/enemy10.png')
Image.register(:enemy11, 'images/enemy11.png')
Image.register(:enemy12, 'images/enemy12.png')
Image.register(:enemy13, 'images/enemy13.png')
Image.register(:enemy14, 'images/enemy14.png')
Image.register(:enemy15, 'images/enemy15.png')
Image.register(:enemy16, 'images/enemy16.png')
Image.register(:enemy17, 'images/enemy17.png')
Image.register(:background, 'images/background.png')
Image.register(:bg_spring, 'images/bg_spring.png')
Image.register(:bg_battle, 'images/bg_battle.png')
Image.register(:bg_event, 'images/bg_event.png')
Image.register(:bg_map, 'images/bg_map.png')
Image.register(:icon_battle, 'images/icon_battle.png')
Image.register(:icon_rest, 'images/icon_rest.png')
Image.register(:icon_event, 'images/icon_event.png')
Image.register(:route1, 'images/route1.png')
Image.register(:route2, 'images/route2.png')
Image.register(:route3, 'images/route3.png')

# ACTIONテーブル
ACTIONS = [
  { id: 1, name: '攻撃', rank: 0 },
  { id: 2, name: '警戒', rank: 0 },
  { id: 3, name: '防御', rank: 0 },
  { id: 4, name: '貫通', rank: 1 },
  { id: 5, name: '集中', rank: 1 },
  { id: 6, name: '治癒', rank: 1 },
  { id: 7, name: '集錬中', rank: 2 },
  { id: 8, name: '双撃', rank: 2 },
  { id: 9, name: '攻衝撃', rank: 2 },
  { id: 10, name: '警厳戒', rank: 2 },
  { id: 11, name: '警厳静戒', rank: 3 },
  { id: 12, name: '防御壁', rank: 1 },
  { id: 13, name: '貫尖撃', rank: 2 },
  { id: 14, name: '貫炸尖撃', rank: 3 },
  { id: 15, name: '治癒唱', rank: 2 },
  { id: 16, name: '治癒神唱', rank: 4 },
  { id: 17, name: '双天撃', rank: 3 },
  { id: 18, name: '双天崩撃', rank: 4 },
  { id: 19, name: '吸収', rank: 2 },
]

# abnormal
ABNORMALS = [
  { id: 1, name: '火傷' },
  { id: 2, name: '毒' },
  { id: 3, name: '呪詛' },
  { id: 4, name: '加護' },
]

# 敵情報
ENEMIES = [
  {
    stage: 1,
    enemy: [
      { id: 1, name: 'ゴブリン', hp: 50, atk: 25, def: 5, actions: [1, 1, 2, 3], award: { status: 'max_hp', value: 2 } },
      { id: 2, name: 'スライム', hp: 60, atk: 30, def: 10, actions: [1, 3], award: { status: 'def', value: 2 } },
      { id: 3, name: 'ゾンビ', hp: 35, atk: 28, def: 8, actions: [1, 2], award: { status: 'atk', value: 2 } },
      { id: 4, name: 'ゴースト', hp: 40, atk: 25, def: 12, actions: [2, 3, 8], award: { status: 'atk', value: 3 } },
    ]
  },
  {
    stage: 2,
    enemy: [
      { id: 5, name: 'エレメンタル', hp: 50, atk: 30, def: 5, actions: [3, 9], award: { status: 'max_hp', value: 2 } },
      { id: 6, name: 'ペガサス', hp: 60, atk: 33, def: 15, actions: [1, 1, 2, 3], award: { status: 'def', value: 3 } },
      { id: 7, name: 'ゴーレム', hp: 70, atk: 33, def: 18, actions: [1, 5, 5], award: { status: 'atk', value: 3 } },
      { id: 8, name: 'ヴァンパイア', hp: 80, atk: 40, def: 10, actions: [1, 2, 11], award: { status: 'atk', value: 2 } },
    ]
  },
  {
    stage: 3,
    enemy: [
      { id: 9, name: 'ハイドラ', hp: 75, atk: 42, def: 22, actions: [2, 3, 4, 10], award: { status: 'max_hp', value: 3 } },
      { id: 10, name: 'ワイバーン', hp: 90, atk: 35, def: 18, actions: [1, 3, 9], award: { status: 'def', value: 4 } },
      { id: 11, name: 'ガーゴイル', hp: 85, atk: 39, def: 25, actions: [1, 2, 9, 10], award: { status: 'def', value: 2 } },
      { id: 12, name: 'ミノタウロス', hp: 120, atk: 45, def: 20, actions: [2, 4], award: { status: 'atk', value: 4 } },
    ]
  },
  {
    stage: 4,
    enemy: [
      { id: 13, name: 'ケルベロス', hp: 95, atk: 35, def: 30, actions: [4, 4, 6, 9, 10], award: { status: 'max_hp', value: 5 } },
      { id: 14, name: 'クラーケン', hp: 110, atk: 40, def: 35, actions: [4, 4, 5, 5, 6], award: { status: 'def', value: 5 } },
      { id: 15, name: 'バジリスク', hp: 120, atk: 45, def: 38, actions: [5, 5, 6, 10], award: { status: 'atk', value: 5 } },
      { id: 16, name: 'カルキノス', hp: 140, atk: 50, def: 45, actions: [4, 5, 7], award: { status: 'atk', value: 5 } },
    ]
  },
  {
    stage: 5,
    enemy: [
      { id: 17, name: 'ドラゴン', hp: 180, atk: 60, def: 60, actions: [4, 5, 12, 13], award: { status: 'max_hp', value: 5 } },
    ]
  },
]

# Mapクラス
class Map
  def initialize
    $floor = 0
    $branch_num = 0
  end

  def execute_map
    if $branch_num == 0
      $branches = []
      $branch_num = rand(1..3)
      $branch_num.times do
        $branches.push([:battle, :battle, :battle, :battle, :event, :event, :rest].sample)
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
    r = rand(0..9)
    case r
    when 0..3
      $scene = :battle
      $battle = Battle.new
    when 4..5
      $scene = :rest
      $rest = Rest.new
    when 6..9
      $event_id = rand(1..1)
      $event = Event.new
    end
  when :rest
    $rest = Rest.new
  end
  $branch_num = 0
  $scene = :ending if $floor == 51
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
        $player_stats[grow_stats] = ($player_stats[grow_stats] * 1.05).floor
        @rest_step = 2
      elsif Input.key_push?(K_3)
        rank = ($floor / 10).ceil
        unaq_action = ACTIONS.find_all { |hash| hash[:rank] == rank }.sample
        unless $player_actions.include?(unaq_action[:id])
          $player_actions.push(unaq_action[:id])
          $message = "鍛錬して#{unaq_action[:name]}を身につけた"
        else
          $message = '何も得られなかった'
        end
        @rest_step = 3
      end
    when 1 # 休憩
      $message = '温泉に浸かって体力が回復した'
      $scene = :map if Input.key_push?(K_ENTER)
    when 2 # 強化
      $message = '温泉の湯を飲んでステータスが上昇した'
      $scene = :map if Input.key_push?(K_ENTER)
    when 3 # 鍛錬
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
    $enemy_data = ENEMIES.find { |h| h[:stage] == ($floor / 10).ceil }[:enemy].sample

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
      if Input.key_push?(K_1) && $player_stats[:actions] > 0
        $player_action_name = action.fetch_action($actions_slot[0])[:name]
        action.execute_action($actions_slot[0])
      elsif Input.key_push?(K_2) && $player_stats[:actions] > 1
        $player_action_name = action.fetch_action($actions_slot[1])[:name]
        action.execute_action($actions_slot[1])
      elsif Input.key_push?(K_3) && $player_stats[:actions] > 2
        $player_action_name = action.fetch_action($actions_slot[2])[:name]
        action.execute_action($actions_slot[2])
      elsif Input.key_push?(K_4) && $player_stats[:actions] > 3
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
      $message = "#{$enemy_name}の行動！"
      if Input.key_push?(K_ENTER)
        # 敵の行動処理
        $enemy_action.execute_action($enemy_action_id)
        # 状態異常処理
        # 火傷
        if $player_stats[:abnormal].include?(1)
          fire_dmg = ($player_stats[:max_hp] * 0.05).floor - ($player_stats[:def] - $player_stats[:tmp_def])
          fire_dmg = 0 if fire_dmg < 1
          $player_stats[:hp] = $player_stats[:hp] - fire_dmg
          $message = $message + ' 火傷のダメージを受けた'
        end
        # 毒
        if $player_stats[:abnormal].include?(2)
          $player_stats[:hp] = $player_stats[:hp] - ($player_stats[:max_hp] * 0.05).floor
          $message = $message + ' 毒のダメージを受けた'
        end
        # 呪詛
        if $player_stats[:abnormal].include?(3)
          $player_stats[:hp] = $player_stats[:hp] - ($player_stats[:max_hp] * 0.1).floor
          $message = $message + ' 呪いのダメージを受けた'
        end
        # 加護
        if $player_stats[:abnormal].include?(4)
          $player_stats[:hp] = $player_stats[:hp] + ($player_stats[:max_hp] * 0.05).floor
          $message = $message + ' 神の加護で体力が回復した'
        end

        $player_stats[:hp] = 0 if $player_stats[:hp] < 1

        $battle_phase = :enemy_effect
      end
    when :enemy_effect
      $enemy_action_id = 0
      $battle_phase = :player_lose if $player_stats[:hp].zero?
      $battle_phase = :player_action if Input.key_push?(K_ENTER)
    when :player_win
      case @win_step
      when 0
        $message = '勝利した'
        $player_stats[:tmp_atk] = 0
        $player_stats[:tmp_def] = 0
        $player_stats[:abnormal] = []
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
    ACTIONS.find { |hash| hash[:id] == id }
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
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 0.8).floor
      $player_stats[:tmp_def] = ($player_stats[:def] * 0.3).floor
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "防御の構えを取りながら攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 3 # 防御
      $player_stats[:tmp_def] = ($player_stats[:def] * 0.7).floor

      $message = '防御の構えに入った'

      $battle_phase = :player_effect
    when 4 # 貫通
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 0.8).floor
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
    when 6 # 治癒
      $player_gain_hp = ($player_stats[:max_hp] - $player_stats[:hp]).positive? ? (($player_stats[:max_hp] - $player_stats[:hp])**(1 / 2.0)).floor : 0
      $player_stats[:hp] = $player_stats[:hp] + $player_gain_hp

      $message = "体力を#{$player_gain_hp}回復した"

      $battle_phase = :player_effect
    when 7 # 激昂
      $player_stats[:tmp_atk] = $player_stats[:tmp_atk] + ($player_stats[:atk] * 0.15).floor

      $message = '激昂して攻撃力が上がった'

      $battle_phase = :player_effect
    when 8 # 双撃
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 0.8).floor
      $total_give_dmg = $player_dmg * 2 - ($enemy_def + $enemy_tmp_def) * 2
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "#{$player_action_name}！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 9 # 攻衝撃
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 1.5).floor
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "#{$player_action_name}！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 10 # 警厳戒
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 0.8).floor
      $player_stats[:tmp_def] = ($player_stats[:def] * 0.7).floor
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "防御の構えを取りながら攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 11 # 警厳静戒
      $player_dmg = $player_stats[:atk] + $player_stats[:tmp_atk]
      $player_stats[:tmp_def] = ($player_stats[:def] * 0.7).floor
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "防御の構えを取りながら攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 12 # 防御壁
      $player_stats[:tmp_def] = $player_stats[:def]

      $message = '防御の構えに入った'

      $battle_phase = :player_effect
    when 13 # 貫尖撃
      $player_dmg = $player_stats[:atk] + $player_stats[:tmp_atk]
      $total_give_dmg = $player_dmg
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "相手の防御を崩す攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 14 # 貫炸尖撃
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 1.5 ).floor
      $total_give_dmg = $player_dmg
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "相手の防御を崩す攻撃！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 15 # 治癒唱
      $player_gain_hp = ($player_stats[:max_hp] - $player_stats[:hp]).positive? ? (($player_stats[:max_hp] - $player_stats[:hp])**(1 / 2.0)).floor : 0
      $player_stats[:hp] = $player_stats[:hp] + $player_gain_hp
      $player_stats[:abnormal].delete(1) if $player_stats[:abnormal].include?(1)
      $player_stats[:abnormal].delete(2) if $player_stats[:abnormal].include?(2)
      $player_stats[:abnormal].delete(3) if $player_stats[:abnormal].include?(3)

      $message = "体力を#{$player_gain_hp}回復した。状態異常を解除した"

      $battle_phase = :player_effect
    when 16 # 治癒神唱
      $player_gain_hp = ($player_stats[:max_hp] - $player_stats[:hp]).positive? ? (($player_stats[:max_hp] - $player_stats[:hp])**(2 / 3.0)).floor : 0
      $player_stats[:hp] = $player_stats[:hp] + $player_gain_hp
      $player_stats[:abnormal].push(4) unless $player_stats[:abnormal].include?(4)

      $message = "体力を#{$player_gain_hp}回復した。神の加護を得た"

      $battle_phase = :player_effect
    when 17 # 双天撃
      $player_dmg = $player_stats[:atk] + $player_stats[:tmp_atk]
      $total_give_dmg = $player_dmg * 2 - ($enemy_def + $enemy_tmp_def) * 2
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "#{$player_action_name}！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 18 # 双天崩撃
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 1.5).floor
      $total_give_dmg = $player_dmg * 2 - ($enemy_def + $enemy_tmp_def) * 2
      $total_give_dmg = 0 if $total_give_dmg < 1
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "#{$player_action_name}！#{$total_give_dmg}ダメージを与えた"

      $battle_phase = :player_effect
    when 19 # 吸収
      $player_dmg = (($player_stats[:atk] + $player_stats[:tmp_atk]) * 0.8).floor
      $total_give_dmg = $player_dmg - $enemy_def - $enemy_tmp_def
      $total_give_dmg = 0 if $total_give_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] + $total_give_dmg
      $player_stats[:hp] = $player_stats[:max_hp] if $player_stats[:hp] > $player_stats[:max_hp]
      $enemy_hp = $enemy_hp - $total_give_dmg
      $enemy_hp = 0 if $enemy_hp < 1

      $message = "敵から体力を吸収した！#{$total_give_dmg}ダメージを奪った"

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
    when 4
      { name: '大攻撃' }
    when 5
      { name: '大警戒' }
    when 6
      { name: '大防御' }
    when 7
      { name: '怒り' }
    when 8
      { name: '呪い' }
    when 9
      { name: '火吹き' }
    when 10
      { name: '毒牙' }
    when 11
      { name: '吸血' }
    when 12
      { name: '激怒' }
    when 13
      { name: 'ブレス' }
    end
  end

  def execute_action(id)
    case id
    when 1 # 攻撃
      $enemy_dmg = $enemy_atk + $enemy_tmp_atk
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg

      $message = "#{$enemy_name}の#{$enemy_action_name}！#{$total_take_dmg}ダメージを受けた"
    when 2 # 警戒
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 0.7).floor
      $enemy_tmp_def = ($enemy_def * 0.3).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg

      $message = "#{$enemy_name}の#{$enemy_action_name}！#{$total_take_dmg}ダメージを受けた"
    when 3 # 防御
      $enemy_tmp_def = ($enemy_def * 0.8).floor

      $message = "#{$enemy_name}は防御の構えに入った"
    when 4 # 大攻撃
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 1.3).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg

      $message = "#{$enemy_name}の#{$enemy_action_name}！#{$total_take_dmg}ダメージを受けた"
    when 5 # 大警戒
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 0.9).floor
      $enemy_tmp_def = ($enemy_def * 0.5).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg

      $message = "#{$enemy_name}の#{$enemy_action_name}！#{$total_take_dmg}ダメージを受けた"
    when 6 # 大防御
      $enemy_tmp_def = ($enemy_def * 1.1).floor

      $message = "#{$enemy_name}は守りを固めている"
    when 7 # 怒り
      $enemy_tmp_atk = $enemy_tmp_atk + ($enemy_atk * 0.15).floor

      $message = "#{$enemy_name}は怒って攻撃力が上がった"
    when 8 # 呪い
      $player_stats[:abnormal].push(3) unless $player_stats[:abnormal].include?(3)

      $message = "#{$enemy_name}は呪いをかけた"
    when 9 # 火吹き
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 0.7).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg
      $player_stats[:abnormal].push(1) unless $player_stats[:abnormal].include?(1)

      $message = "#{$enemy_name}の火吹き攻撃！#{$total_take_dmg}ダメージを受けた。火傷を負った"
    when 10 # 毒牙
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 0.7).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg
      $player_stats[:abnormal].push(2) unless $player_stats[:abnormal].include?(2)

      $message = "#{$enemy_name}は毒牙を突き立てた！#{$total_take_dmg}ダメージを受けた。毒を受けた"
    when 11 # 吸血
      $enemy_dmg = (($enemy_atk + $enemy_tmp_atk) * 0.7).floor
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg
      $enemy_hp = $enemy_hp + $total_take_dmg
      $enemy_hp = $enemy_max_hp if $enemy_hp > $enemy_max_hp

      $message = "#{$enemy_name}の#{$enemy_action_name}！#{$total_take_dmg}ダメージを吸収された"
    when 12 # 激怒
      $enemy_tmp_atk = $enemy_tmp_atk + ($enemy_atk * 0.25).floor

      $message = "#{$enemy_name}は激怒して攻撃力が上がった"
    when 13 # ブレス
      $enemy_dmg = $enemy_atk + $enemy_tmp_atk
      $total_take_dmg = $enemy_dmg - $player_stats[:def] - $player_stats[:tmp_def]
      $total_take_dmg = 0 if $total_take_dmg < 1
      $player_stats[:hp] = $player_stats[:hp] - $total_take_dmg
      $player_stats[:abnormal].push(1) unless $player_stats[:abnormal].include?(1)

      $message = "#{$enemy_name}のブレス攻撃！#{$total_take_dmg}ダメージを受けた。火傷を負った"
    end
  end
end

def fade_in
  $fade_flg = true
  $fade_frames = 45
end

# メインループ
Window.load_resources do
  frame_count = 0
  $event_id = 1

  $player_stats = {
    max_hp: 100,
    hp: 100,
    atk: 20,
    tmp_atk: 0,
    def: 20,
    tmp_def: 0,
    abnormal: [],
    actions: 3
  }

  $player_actions = [1, 2, 3]
  $actions_slot = []

  $scene = :map

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

    # ---- 描画処理 ----
    abnormal = ''
    $player_stats[:abnormal].each do |a|
      ab = ABNORMALS.find { |hash| hash[:id] == a }
      abnormal = abnormal + ' ' + ab[:name].to_s
    end
    $status = "体力:#{$player_stats[:hp]}/#{$player_stats[:max_hp]} 攻撃力:#{$player_stats[:atk]}(+#{$player_stats[:tmp_atk]}) 防御力:#{$player_stats[:def]}(+#{$player_stats[:tmp_def]}) #{abnormal}"

    # 背景
    case $scene
    when :rest
      Window.draw(0, 0, Image[:bg_spring])
    when :battle
      Window.draw(0, 0, Image[:bg_battle])
    when :event
      Window.draw(0, 0, Image[:bg_event])
    when :map
      Window.draw(0, 0, Image[:bg_map])
      Window.draw(0, 0, Image['route'+$branches.size.to_s])
      case $branches.size
      when 1
        Window.draw(317, 135, Image['icon_' + $branches[0]])
      when 2
        $branches.each_with_index do |branch, i|
          Window.draw(196 + 243 * i, 135, Image['icon_' + branch])
        end
      when 3
        $branches.each_with_index do |branch, i|
          Window.draw(196 + 122 * i, 135, Image['icon_' + branch])
        end
      end
    else
      Window.draw(0, 0, Image[:background])
    end

    # 敵
    if $scene == :battle
      enemy_tmp_msg = ''
      enemy_tmp_msg += '攻UP ' if $enemy_tmp_atk != 0
      enemy_tmp_msg += '防UP ' if $enemy_tmp_def != 0
      Window.draw_font(400, 140, "#{$enemy_name}", font_fff16)
      Window.draw_box_fill(398, 164, 482, 177, [62, 62, 62])
      Window.draw_box_fill(400, 166, 480, 175, [0, 0, 0])
      Window.draw_box_fill(400, 166, 400 + (80 * $enemy_hp / $enemy_max_hp).floor, 175, [0, 255, 0])
      Window.draw_font(400, 180, "#{$enemy_hp}/#{$enemy_max_hp}", font_fff14)
      Window.draw_font(400, 200, enemy_tmp_msg, font_fff12)
      Window.draw_font(400, 220, "#{$enemy_action_name}", font_fff14)
      Window.draw(150, 140, Image['enemy' + $enemy_data[:id].to_s])
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
      opacity = (255 / 45 * $fade_frames).floor
      Window.draw_box_fill(0, 0, Window.width, Window.height, [opacity, 0, 0, 0])
      $fade_frames -= 1
      $fade_flg = false if $fade_frames == 0
    end
  end
end
