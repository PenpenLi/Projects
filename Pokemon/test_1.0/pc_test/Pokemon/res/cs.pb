
�
cs.protocs"�
User

id (
name (	
level (
vit (
spirit (
refresh_vit_time (
refresh_spirit_time (
exp (
money	 (
gold
 (
prestige (
skill_point (
medal (
tower_score (
fight_value (
battle_token (
battle_token_time (
essence (
forbid_battle_time (
guide_id (

corp_point (
wheel_score (
god_soul (
contest_point (
title_id (!

title_list (2.cs.TitleInfo
spread_sum_score (
coupon (
fid (
fight_score (
cloth_id (

cloth_time  (

cloth_open! (
ksoul_point" (
cnt# (
ksoul_summon_score$ (
ksoul_fight_base% ("�
Knight

id (
base_id (
level (
exp (
time (
user_id ($
training (2.cs.KnightTraining

halo_level (
halo_exp	 (
halo_ts
 (
association (
passive_skill (
awaken_level (
awaken_items (
pulse_level (
frag_consume ("�
KnightTraining

hp (
hp_tmp (

at (
at_tmp (

pd (
pd_tmp (

md (
md_tmp ("�
	Equipment

id (
base_id (
time (
user_id (
level (
refining_level (
refining_exp (
money (
star	 (
star_exp
 (

luck_value ("3
Dress

id (
base_id (
level ("
Pet

id (
base_id (
level (
exp (
addition_exp (
addition_lvl (
fight_value ("z
Treasure

id (
base_id (
time (
user_id (
level (
exp (
refining_level ("
Item

id (
num ("%

AwakenItem

id (
num ("#
Fragment

id (
num ("+
TreasureFragment

id (
num ("�
ArenaBattleUser

id (
name (	
level (
fight_value (
knights (2
.cs.Knight!

equipments (2.cs.Equipment
	treasures (2.cs.Treasure,
fight_equipments (2.cs.FightEquipment*
fight_treasures	 (2.cs.FightTreasure
dresses
 (2	.cs.Dress

dress_slot (
fpet (2.cs.Pet
has_ppet (
ppet (2.cs.Pet
clid (
cltm (
clop ("%
	TitleInfo

id (
time ("�
UserRice
	rice_rank (
	init_rice (
growth_rice (
rice_refresh_time (
rivals (2.cs.RiceRival
rival_flush_time (
revenge_token (
buy_revtoken_times (
	rob_token	 (
rob_token_refresh_time
 (
last_rob_time (
buy_robtoken_times (
achievement_list (

rank_award ("�
	RiceEnemy

id (
user_id (

rob_result (
rob_rice (
revenge (
time (
name (	
fight_value (
	init_rice	 (
base_id
 (

dress_base (
level (
clid (
cltm (
clop ("�
	RiceRival
user_id (
name (	
fight_value (
	init_rice (
base_id (
growth_rice (
corp_id ("�
RiceRankUser
user_id (
	rice_rank (
name (	
rice (
fight_value (
level (
base_id (

dress_base (
clid	 (
cltm
 (
clop ("
C2S_KeepAlive"
S2C_KeepAlive"_
	C2S_Login
token (	
sid (

channel_id (	
	device_id (	
version ("h
	S2C_Login
ret (
uid (
sid (
yzuid (	
platform_uid (	
version ("(

C2S_Create
name (	
type ("3

S2C_Create
ret (
uid (
sid ("
C2S_Offline"
C2S_GetServerTime"/
S2C_GetServerTime
time (
zone ("�
	C2S_Flush
user (
knight (
item (
fragment (
mail (
	gift_mail (
	equipment (
treasure_fragment (
treasure	 (
fight_resource
 (
fight_knight (
vip (
recharge (
chapter (
main_grouth (

hof_points (
dress (
awaken_item (
pet (
ksoul ("�
	S2C_Flush
ret (
user (
knight (
item (
fragment (
mail (
	gift_mail (
	equipment (
treasure_fragment	 (
treasure
 (
fight_resource (
fight_knight (
vip (
recharge (
chapter (
main_grouth (

hof_points (
dress (
awaken_item (
pet (
ksoul ("%
S2C_GetUser
user (2.cs.User",
S2C_GetKnight
knights (2
.cs.Knight"6

S2C_GetPet
pets (2.cs.Pet
	fight_pet ("5
S2C_GetEquipment!

equipments (2.cs.Equipment"<
S2C_GetDress
dresses (2	.cs.Dress
dress_id ("2
S2C_GetTreasure
	treasures (2.cs.Treasure"&
S2C_GetItem
items (2.cs.Item"9
S2C_GetAwakenItem$
awaken_items (2.cs.AwakenItem"2
S2C_GetFragment
	fragments (2.cs.Fragment"K
S2C_GetTreasureFragment0
treasure_fragments (2.cs.TreasureFragment" 
S2C_HOF_Points
points ("P
FightEquipment
slot_1 (
slot_2 (
slot_3 (
slot_4 ("/
FightTreasure
slot_1 (
slot_2 ("m
S2C_FightResource,
fight_equipments (2.cs.FightEquipment*
fight_treasures (2.cs.FightTreasure"L
C2S_AddFightEquipment
team (
pos (
slot (

id ("i
S2C_AddFightEquipment
team (
pos (
slot (

id (
ret (
old_id ("B
C2S_ClearFightEquipment
team (
pos (
slot ("_
S2C_ClearFightEquipment
team (
pos (
slot (
ret (
old_id ("
C2S_AddFightDress

id ("<
S2C_AddFightDress
ret (

id (
old_id ("
C2S_ClearFightDress"2
S2C_ClearFightDress
ret (
old_id ("K
C2S_AddFightTreasure
team (
pos (
slot (

id ("h
S2C_AddFightTreasure
team (
pos (
slot (

id (
ret (
old_id ("A
C2S_ClearFightTreasure
team (
pos (
slot ("^
S2C_ClearFightTreasure
team (
pos (
slot (
ret (
old_id ("8
C2S_RecycleTreasure
treasure_id (
type ("I
S2C_RecycleTreasure
ret (
item (2	.cs.Award
type ("D
C2S_ChatRequest
channel (
content (	
reciver (	"
S2C_ChatRequest
ret ("�
S2C_Chat
channel (
sender (	
senderId (
kid (
content (	
vip (
dress_id (
title_id (
level	 (
fid
 (

sender_sid (
team_id (
clid (
cltm (
clop ("W

S2C_Notify
template_id (
name (	
base_id (
template_args ("�
Friend

id (
name (	
level (
fighting_capacity (
vip (
online (
present (

getpresent (
friend_count	 (
mainrole
 (
dress_id (

guild_name (	
title_id (
fid (
team_pvp_title (
clid (
cltm (
clop ("
C2S_GetFriendList"O
S2C_GetFriendList
friend (2
.cs.Friend

black_list (2
.cs.Friend"
C2S_GetFriendReqList"2
S2C_GetFriendReqList
friend (2
.cs.Friend"9
C2S_RequestAddFriend
name (	
friend_type ("b
S2C_RequestAddFriend
ret (
name (	
friend_type (
friend (2
.cs.Friend":
C2S_RequestDeleteFriend

id (
friend_type ("G
S2C_RequestDeleteFriend
ret (

id (
friend_type ("2
C2S_ConfirmAddFriend

id (
accept ("[
S2C_ConfirmAddFriend
ret (
friend (2
.cs.Friend
accept (

id ("
C2S_FriendPresent

id ("Q
S2C_FriendPresent
ret (

id (
present (

getpresent (""
C2S_GetFriendPresent

id ("o
S2C_GetFriendPresent
ret (

id (
present (

getpresent (
get_present_times ("-
C2S_GetPlayerInfo

id (
name (	"<
S2C_GetPlayerInfo
ret (
friend (2
.cs.Friend"2
S2C_AddFriendRespond
friend (2
.cs.Friend"
C2S_ChooseFriend"/
S2C_ChooseFriend
friends (2
.cs.Friend"
C2S_GetFriendsInfo"@
S2C_GetFriendsInfo
getPresentCount (
	newFriend (""
C2S_KillFriend
targetId ("F
S2C_KillFriend
ret ('
battle_report (2.cs.BattleReport"
S2C_DelFriend

id ("�

BattleUnit

id (

hp (
position (
anger (
dress_id (
awaken (
max_hp (
pet_halo_type (
pet_halo_value	 (
clid
 (
cltm (
clop ("�
BattleSkillVictim
position (
	change_hp (
state (
identity (
is_crit (
is_dodge (

clear_buff (
awards (2	.cs.Award
anger	 (
	is_double
 (
recover (
hitback (
	is_pierce (
resurge (

life_drain ("7

BattleBuff

id (
count (
result ("y
BattleBuffVictim
position (
buff_id (
identity (

id (
	remove_id (
	is_resist ("�
BattleAttack
identity (
position (
buffs (2.cs.BattleBuff
state (
skill_id (,
skill_victims (2.cs.BattleSkillVictim*
buff_victims (2.cs.BattleBuffVictim,
anger_victims (2.cs.BattleSkillVictim
awards	 (2	.cs.Award
anger
 (#
state_buffs (2.cs.BattleBuff,
cbuff_victims (2.cs.BattleSkillVictim
unite_index (
death_hitback (
resurge ("8

BattleTeam
units (2.cs.BattleUnit
pet ("X
BattleStateBuffVictim
position (
bbs (2.cs.BattleBuff
identity ("t
BattleAttackRound.
buff_victim (2.cs.BattleStateBuffVictim!
attacks (2.cs.BattleAttack
type ("_
BattleAttackBout
own_team (

enemy_team (%
rounds (2.cs.BattleAttackRound"q
BattleBriefUser
name (	
dress (
base_id (

fv (

hp (
uid (
sid ("�
BattleBriefReport

tp (
is_win ( 
own (2.cs.BattleBriefUser"
enemy (2.cs.BattleBriefUser
hp_list (
	e_hp_list ("�
BattleReport

tp (!
	own_teams (2.cs.BattleTeam#
enemy_teams (2.cs.BattleTeam#
bouts (2.cs.BattleAttackBout
is_win (
own_name (	

enemy_name (	 
result (2.cs.BattleResult
own_fight_base	 (
enemy_fight_base
 ("`
BattleResult&
left_own_teams (2.cs.BattleTeam(
left_enemy_teams (2.cs.BattleTeam"
C2S_TestBattle"=
S2C_TestBattle
ret (
info (2.cs.BattleReport"�
Chapter

id (

total_star (
breward (
sreward (
greward (
stages (2	.cs.Stage
has_entered ("v
Stage

id (
star (
execute_count (
is_finished (

reset_cost (
reset_count ("
C2S_GetChapterList"�
S2C_GetChapterList
ret (

total_star (
fast_execute_time (
fast_execute_cd (
chapters (2.cs.Chapter"H
ChapterRank
rank (
name (	
star (
user_id ("
C2S_GetChapterRank"T
S2C_GetChapterRank
ret (
	self_rank (
ranks (2.cs.ChapterRank"9
S2C_AddStage
chpt_id (
stage (2	.cs.Stage"
C2S_ExecuteStage

id ("�
S2C_ExecuteStage
ret (

id (
stage (2	.cs.Stage
type (
awards (2	.cs.Award
stage_money (
	stage_exp	 (

stage_star
 (
rebel (
rebel_level ("f
S2C_ExecuteMultiStage
ret (

id (
info (2.cs.BattleReport
next_wave_id ("4
C2S_ExecuteMultiStage

id (
wave_id (""
C2S_FastExecuteStage

id ("�
S2C_FastExecuteStage
ret (

id (
fast_execute_time (
fast_execute_cd (
stage (2	.cs.Stage
awards (2	.cs.Award
stage_money (
	stage_exp (

stage_star	 (
rebel
 (
rebel_level ("
C2S_ChapterAchvRwdInfo";
S2C_ChapterAchvRwdInfo
ret (
finished_rwd ("*
C2S_FinishChapterAchvRwd
rwd_id ("7
S2C_FinishChapterAchvRwd
ret (
rwd_id ("-
C2S_ResetDungeonExecution
stage_id ("m
S2C_ResetDungeonExecution
ret (
stage_id (
stage (2	.cs.Stage
next_reset_cost (":
C2S_FinishChapterBoxRwd
ch_id (
box_type ("G
S2C_FinishChapterBoxRwd
ret (
ch_id (
box_type ("
C2S_ResetDungeonFastTimeCd"]
S2C_ResetDungeonFastTimeCd
ret (
fast_execute_time (
fast_execute_cd ("
C2S_GetArenaInfo"�
S2C_GetArenaInfo
ret (
user_id (
rank (
max_rank (
prestige (3
to_challenge_list (2.cs.ArenaToChallengeUser"�
ArenaToChallengeUser
user_id (
rank (
name (	
level (
base_id (
fight_value (

dress_base (
pet_base_id (
clid	 (
cltm
 (
clop ("
C2S_GetArenaTopInfo"O
S2C_GetArenaTopInfo
ret (+
	user_list (2.cs.ArenaToChallengeUser"'
C2S_GetArenaUserInfo
user_id ("F
S2C_GetArenaUserInfo
ret (!
user (2.cs.ArenaBattleUser""
C2S_ChallengeArena
rank ("�
S2C_ChallengeArena
ret ('
battle_report (2.cs.BattleReport
rewards (2	.cs.Award*
break_record (2.cs.ArenaBreakRecord'
turnover_rewards (2.cs.AwardList3
to_challenge_user (2.cs.ArenaToChallengeUser"'
	AwardList
rewards (2	.cs.Award"X
ArenaBreakRecord
old_rank (
new_rank ( 
break_rewards (2	.cs.Award"2
Award
type (
value (
size (";
C2S_UpgradeEquipment
equipment_id (
times ("k
S2C_UpgradeEquipment
ret (
times (

crit_times (
break_reason (
level ("
C2S_UpgradeDress

id ("
S2C_UpgradeDress
ret ("K
C2S_RefiningEquipment
equipment_id (
item_id (
num ("$
S2C_RefiningEquipment
ret ("m
S2C_FightKnight

first_team (
second_team (
first_formation (
second_formation (";
C2S_ChangeFormation
formation_id (
indexs (""
S2C_ChangeFormation
ret ("D
C2S_ChangeTeamKnight
team (
pos (
	knight_id ("h
S2C_ChangeTeamKnight
ret (
team (
pos (
	knight_id (
old_knight_id ("&
C2S_AddTeamKnight
	knight_id ("@
S2C_AddTeamKnight
ret (
	knight_id (
pos ("
C2S_TowerInfo"�
S2C_TowerInfo
ret (
floor (
reset_count (
score (
next_challenge (
free_refresh_count (
cleanup_time (
doing_cleanup (
cleanup_floor	 (
next_floor_ct
 ("%
C2S_TowerChallenge
buff_id ("d
S2C_TowerChallenge
ret ('
battle_report (2.cs.BattleReport
award (2	.cs.Award"
C2S_TowerStartCleanup":
S2C_TowerStartCleanup
ret (
cleanup_time ("
C2S_TowerStopCleanup"2
S2C_TowerStopCleanup
ret (
floor ("
C2S_TowerReset"
S2C_TowerReset
ret ("!
C2S_TowerGetBuff
floor ("#
S2C_TowerGetBuff
buff_id ("
C2S_TowerRfBuff"/
S2C_TowerRfBuff
ret (
buff_id ("
C2S_TowerRequestReward"%
S2C_TowerRequestReward
ret ("+
TowerRanking
name (	
floor ("
C2S_TowerRankingList"9
S2C_TowerRankingList!
ranking (2.cs.TowerRanking"(
C2S_TowerChallengeGuide
floor ("O
S2C_TowerChallengeGuide
ret ('
battle_report (2.cs.BattleReport".

SimpleMail

id (
mail_info_id ("e
Mail

id (
	source_id (
key (	
value (	
mail_info_id (
time ("1
S2C_GetSimpleMail
mail (2.cs.SimpleMail"1
S2C_AddSimpleMail
mail (2.cs.SimpleMail"6
S2C_GetNewMailCount
count (
recharge ("
C2S_GetMail

id ("2
S2C_GetMail
ret (
mail (2.cs.Mail"I
GiftMail

id (
mail (2.cs.Mail
awards (2	.cs.Award"%
S2C_GetGiftMailCount
count ("
C2S_GetGiftMail":
S2C_GetGiftMail
ret (
mail (2.cs.GiftMail"!
C2S_ProcessGiftMail

id (".
S2C_ProcessGiftMail
ret (

id ("
C2S_TestMail"(
C2S_Mail
content (	
uid ("
S2C_Mail
ret ("
C2S_RecruitInfo"�
S2C_RecruitInfo
lp_free_count (
lp_free_time (
jp_free_time (
jp_recruited_times (
zy_cycle (
zy_recruited_times ("%
C2S_RecruitLp
consume_type ("J
S2C_RecruitLp
ret (
knight_base_id (
consume_type ("(
C2S_RecruitLpTen
consume_type ("M
S2C_RecruitLpTen
ret (
knight_base_id (
consume_type ("%
C2S_RecruitJp
consume_type ("J
S2C_RecruitJp
ret (
knight_base_id (
consume_type ("(
C2S_RecruitJpTen
consume_type ("M
S2C_RecruitJpTen
ret (
knight_base_id (
consume_type ("'
C2S_RecruitJpTw
consume_type ("L
S2C_RecruitJpTw
ret (
knight_base_id (
consume_type ("
C2S_RecruitZy"4
S2C_RecruitZy
ret (
knight_base_id ("E
C2S_Shopping
mode (

id (
size (
index ("R
S2C_Shopping
ret (
mode (

id (
size (
index ("5
C2S_UseItem

id (
index (
num ("A
S2C_UseItem
ret (

id (
awards (2	.cs.Award"
C2S_EnterShop
mode ("6
S2C_EnterShop
mode (

id (
num ("
C2S_MysticalShopInfo"I
S2C_MysticalShopInfo
refresh_count (
free_refresh_count ("'
C2S_MysticalShopRefresh
type ("e
S2C_MysticalShopRefresh
ret (

id (
refresh_count (
free_refresh_count ("
C2S_AwakenShopInfo"G
S2C_AwakenShopInfo
refresh_count (
free_refresh_count ("%
C2S_AwakenShopRefresh
type ("c
S2C_AwakenShopRefresh
ret (

id (
refresh_count (
free_refresh_count ("j
OpKnight"
insert_knights (2
.cs.Knight"
update_knights (2
.cs.Knight
delete_knights ("|
OpEquipment(
insert_equipments (2.cs.Equipment(
update_equipments (2.cs.Equipment
delete_equipments ("g
OpDress!
insert_dresses (2	.cs.Dress!
update_dresses (2	.cs.Dress
delete_dresses ("X
OpPet
insert_pets (2.cs.Pet
update_pets (2.cs.Pet
delete_pets ("v

OpTreasure&
insert_treasures (2.cs.Treasure&
update_treasures (2.cs.Treasure
delete_treasures ("^
OpItem
insert_items (2.cs.Item
update_items (2.cs.Item
delete_items ("p
OpAwakenItem$
insert_items (2.cs.AwakenItem$
update_items (2.cs.AwakenItem
delete_items ("v

OpFragment&
insert_fragments (2.cs.Fragment&
update_fragments (2.cs.Fragment
delete_fragments ("�
OpTreasureFragment7
insert_treasure_fragments (2.cs.TreasureFragment7
update_treasure_fragments (2.cs.TreasureFragment!
delete_treasure_fragments ("�
S2C_OpObject
user_id (
knight (2.cs.OpKnight"
	equipment (2.cs.OpEquipment
item (2
.cs.OpItem 
fragment (2.cs.OpFragment1
treasure_fragment (2.cs.OpTreasureFragment 
treasure (2.cs.OpTreasure
dress (2.cs.OpDress%
awaken_item	 (2.cs.OpAwakenItem
pet
 (2	.cs.OpPet
ksoul (2.cs.OpKsoul"3
Object
mode (
value (
size ("$
C2S_Sell
info (2
.cs.Object"
S2C_Sell
ret ("&
	SkillTree

id (
level ("
C2S_GetSkillTree"S
S2C_GetSkillTree
skill (2.cs.SkillTree!

slot_skill (2.cs.SkillTree"
C2S_LearnSkill

id ("G
S2C_LearnSkill
ret (

id (
skill (2.cs.SkillTree"
C2S_ResetSkill

id ("P
S2C_ResetSkill
ret (
skill (2.cs.SkillTree
skill_point ("
C2S_PlaceSkill

id (")
S2C_PlaceSkill
ret (

id ("/
C2S_FragmentCompound

id (
num ("<
S2C_FragmentCompound
ret (

id (
num ("�
StoryDungeon

id (
execute_count (

barrier_id (
is_finished (

is_entered (
played_barrier (
	has_award ("
C2S_GetStoryList"Z
S2C_GetStoryList
ret ("
dungeons (2.cs.StoryDungeon
execute_count ("M
C2S_ExecuteBarrier

dungeon_id (

barrier_id (
wave_id ("�
S2C_ExecuteBarrier
ret (

dungeon_id (

barrier_id (!
dungeon (2.cs.StoryDungeon
drop_awards (2	.cs.Award!
monster_awards (2	.cs.Award
barrier_money (
barrier_exp (
barrier_star	 (
info
 (2.cs.BattleReport
barrier_fb_gold (
execute_count (
next_wave_id ("@
C2S_FastExecuteBarrier

dungeon_id (

barrier_id ("�
S2C_FastExecuteBarrier
ret (

dungeon_id (

barrier_id (
fast_execute_time (
fast_execute_cd (!
dungeon (2.cs.StoryDungeon
drop_awards (2	.cs.Award!
monster_awards (2	.cs.Award
barrier_money	 (
barrier_exp
 (
barrier_star (
execute_count ("
C2S_SanguozhiAwardInfo":
S2C_SanguozhiAwardInfo
ret (
finished_id ("*
C2S_FinishSanguozhiAward
sgz_id ("R
S2C_FinishSanguozhiAward
ret (
sgz_id (
awards (2	.cs.Award"
C2S_ResetStoryFastTimeCd"[
S2C_ResetStoryFastTimeCd
ret (
fast_execute_time (
fast_execute_cd ("8
S2C_AddStoryDungeon!
dungeon (2.cs.StoryDungeon"%
C2S_SetStoryTag

dungeon_id ("U
S2C_SetStoryTag
ret (

dungeon_id (!
dungeon (2.cs.StoryDungeon"!
C2S_GetBarrierAward

id ("l
S2C_GetBarrierAward
ret (

id (!
dungeon (2.cs.StoryDungeon
awards (2	.cs.Award"<
C2S_UpgradeKnight

upgrade_id (
knight_list (" 
S2C_UpgradeKnight
ret (">
C2S_AdvancedKnight
advanced_id (
knight_list ("5
S2C_AdvancedKnight
ret (

new_knight ("V
C2S_TrainingKnight
	knight_id (
training_type (
training_times ("!
S2C_TrainingKnight
ret ("+
C2S_SaveTrainingKnight
	knight_id ("%
S2C_SaveTrainingKnight
ret ("-
C2S_GiveupTrainingKnight
	knight_id ("'
S2C_GiveupTrainingKnight
ret ("7
RecycleItem
type (
value (
num ("4
C2S_RecycleKnight
	knight_id (
type ("�
S2C_RecycleKnight
ret (
knight_food (
item (2.cs.RecycleItem
essence (
money (
type (
soul (
award (2	.cs.Award"?
C2S_KnightTransform
	knight_id (
advanced_code (">
S2C_KnightTransform
ret (
knight (2
.cs.Knight"$
C2S_KnightOrangeToRed
kid ("$
S2C_KnightOrangeToRed
ret ("*
C2S_UpgradeKnightHalo
	knight_id ("$
S2C_UpgradeKnightHalo
ret ("(
C2S_GetHandbookInfo
	hand_type ("B
S2C_GetHandbookInfo
ret (
	hand_type (
ids ("�
Rebel

id (

hp (
max_hp (
end (
level (
user_id (
public (
name (	
last_att_index	 ("(
S2C_GetRebel
rebel (2	.cs.Rebel"
C2S_EnterRebelUI"b
S2C_EnterRebelUI
exploit_rank (
max_harm (
max_harm_rank (
exploit ("9
AttackRebelInfo
name (	
harm (

id ("B
C2S_RefreshRebelShow
	rebel_ids (
last_att_indexs ("h
S2C_RefreshRebelShow
rebels (2	.cs.Rebel"
infos (2.cs.AttackRebelInfo
	rebel_ids ("0
C2S_AttackRebel
user_id (
mode ("�
S2C_AttackRebel
ret ( 
report (2.cs.BattleReport
exploit (
harm (
public (

new_record (
mode (
award (2	.cs.Award"
C2S_PublicRebel"
S2C_PublicRebel
ret ("
C2S_RebelRank"�
	RebelRank

id (
level (
value (
attack_value (
rank (
name (	
user_id (
dress_id (
clid	 (
cltm
 (
clop ("�
S2C_RebelRank
ret (#
exploit_rank (2.cs.RebelRank$
max_harm_rank (2.cs.RebelRank
my_exploit_rank (
my_max_harm_rank ("
C2S_MyRebelRank
mode ("I
S2C_MyRebelRank
ret (
mode (
rank (2.cs.RebelRank"
C2S_RefreshRebel":
S2C_RefreshRebel
ret (
rebels (2	.cs.Rebel"
C2S_GetExploitAwardType"7
S2C_GetExploitAwardType
mode (
awards ("!
C2S_GetExploitAward

id ("H
S2C_GetExploitAward
ret (

id (
award (2	.cs.Award"1
C2S_GetTreasureFragmentRobList
base_id ("n
S2C_GetTreasureFragmentRobList
ret (
base_id (.
	rob_users (2.cs.TreasureFragmentRobUser"�
TreasureFragmentRobUser
index (
name (	
level (
fight_value (
knights (
rob_rate (
is_robot (

dress_base (",
C2S_FastRobTreasureFragment
index ("�
S2C_FastRobTreasureFragment
ret (
base_id (
battle_times (
break_reason (

rob_result (#
turnover_rewards (2	.cs.Award
rewards (2.cs.AwardList"(
C2S_RobTreasureFragment
index ("�
S2C_RobTreasureFragment
ret (

rob_result ('
battle_report (2.cs.BattleReport'
turnover_rewards (2.cs.AwardList
rewards (2	.cs.Award
base_id ("@
C2S_UpgradeTreasure

upgrade_id (
treasure_list (""
S2C_UpgradeTreasure
ret ("B
C2S_RefiningTreasure
refining_id (
treasure_list ("#
S2C_RefiningTreasure
ret ("7
C2S_ComposeTreasure
treasure_id (
num ("D
S2C_ComposeTreasure
ret (
treasure_id (
num ("3
 C2S_TreasureFragmentForbidBattle
item_id ("@
 S2C_TreasureFragmentForbidBattle
ret (
item_id ("0
C2S_OneKeyRobTreasureFragment
base_id ("�
S2C_OneKeyRobTreasureFragment
ret (

rob_result ("
turnover_reward (2	.cs.Award
rewards (2	.cs.Award
rob_name (	
rob_base_id ("6
C2S_RecycleEquipment
equip_id (
type ("L
S2C_RecycleEquipment
ret (
type (
awards (2	.cs.Award"5
C2S_RebornEquipment
equip_id (
type ("K
S2C_RebornEquipment
ret (
type (
awards (2	.cs.Award"&
C2S_GetKnightAttr
	knight_id ("b
S2C_GetKnightAttr
attack (

hp (
physical_defense (
magical_defense ("
C2S_GetGuideId"
S2C_GetGuideId

id ("
C2S_SaveGuideId

id ("
S2C_SaveGuideId
ret ("

C2S_GetVip"~

S2C_GetVip
ret (
level (
exp (
vip_dungeons (
vip_dungeon_count (
vip_reset_cost ("#
C2S_ExecuteVipDungeon

id ("�
S2C_ExecuteVipDungeon
ret (

id (
vip_dungeon_count (
info (2.cs.BattleReport
drop_awards (2	.cs.Award
extra_award (2	.cs.Award
least_award (2	.cs.Award"
C2S_ResetVipDungeonCount"Z
S2C_ResetVipDungeonCount
ret (
vip_dungeon_count (
vip_reset_cost ("
C2S_GetRecharge" 
Recharge
recharge_ids ("R
	MonthCard
mc_id (
mc_days (
last_use_time (
mc_use ("h
S2C_GetRecharge
ret (
recharge (2.cs.Recharge
mc (2.cs.MonthCard
bonus (""
S2C_RechargeSuccess
ret (""
C2S_GetRechargeBonus

id ("Y
S2C_GetRechargeBonus
ret (

id (
awards (2	.cs.Award
bonus ("
C2S_LiquorInfo"2
S2C_LiquorInfo
state (
	next_time ("
	C2S_Drink"5
	S2C_Drink
ret (
gold (
state ("
C2S_UseMonthCard

id ("+
S2C_UseMonthCard
ret (

id ("
C2S_MrGuanInfo"M
S2C_MrGuanInfo
today_count (
total_count (
	next_time ("
C2S_Worship"4
S2C_Worship
ret (
award (2	.cs.Award"
C2S_LoginRewardInfo"�
S2C_LoginRewardInfo
total1 (

last_time1 (
vipid (
last_time_vip (
cost (
vip_available ("
C2S_LoginReward
type ("X
S2C_LoginReward
ret (
mult (
total (
type (
vipid ("A
DailyMission

id (
progress (
is_finished ("
C2S_GetDailyMission"�
S2C_GetDailyMission
ret ('
fixed_mission (2.cs.DailyMission&
rand_mission (2.cs.DailyMission

reset_cost (
reset_count (
score (&
score_awards (2.cs.DailyMission
level ("$
C2S_FinishDailyMission

id ("�
S2C_FinishDailyMission
ret (

id ('
daily_mission (2.cs.DailyMission
awards (2	.cs.Award
score ("&
C2S_GetDailyMissionAward

id ("N
S2C_GetDailyMissionAward
ret (

id (
awards (2	.cs.Award"
C2S_ResetDailyMission"v
S2C_ResetDailyMission
ret ('
daily_mission (2.cs.DailyMission

reset_cost (
reset_count ("#
C2S_FirstEnterChapter

id ("N
S2C_FirstEnterChapter
ret (

id (
chapter (2.cs.Chapter"@
S2C_FlushDailyMission'
daily_mission (2.cs.DailyMission"
C2S_WushInfo"�
S2C_WushInfo
floor (
reset_count (

star_total (
star_cur (
star_his (
star (
buffs (
failed (
buy_id	 (
bought
 (
	max_clean ("
C2S_WushGetBuff""
S2C_WushGetBuff
buff_id ("1
C2S_WushChallenge
index (
clean ("�
S2C_WushChallenge
ret ('
battle_report (2.cs.BattleReport
award (2	.cs.Award
index (
buy_id ("
C2S_WushReset"/
S2C_WushReset
ret (
	max_clean (")
WushRanking
name (	
star ("
C2S_WushRankingList"7
S2C_WushRankingList 
ranking (2.cs.WushRanking"$
C2S_WushApplyBuff
buff_id ("1
S2C_WushApplyBuff
ret (
buff_id ("
C2S_WushBuy"
S2C_WushBuy
ret ("
C2S_GiftCode
code (	"
S2C_GiftCode
ret ("
S2C_RollNotice
msg (	">

TargetInfo	
t (

id (
step (
num ("
C2S_TargetInfo".
S2C_TargetInfo
info (2.cs.TargetInfo" 
C2S_TargetGetReward	
t ("-
S2C_TargetGetReward
ret (	
t ("
C2S_GetMainGrouthInfo"5
S2C_GetMainGrouthInfo
ret (
used_mg ("2
C2S_UseMainGrouthInfo

id (
index ("Z
S2C_UseMainGrouthInfo
ret (

id (
index (
awards (2	.cs.Award"
C2S_GetDaysActivityInfo"K
DaysActivity

id (
status (
progress (
count ("�
S2C_GetDaysActivityInfo
ret (
status (

start_time (
end_time (
current_day ('
days_activity (2.cs.DaysActivity"3
C2S_FinishDaysActivity

id (
index ("�
S2C_FinishDaysActivity
ret (

id (
index ('
days_activity (2.cs.DaysActivity
awards (2	.cs.Award"8
AcitivitySell

id (
num (
bought ("
C2S_GetDaysActivitySell"H
S2C_GetDaysActivitySell
ret ( 
sells (2.cs.AcitivitySell"&
C2S_PurchaseActivitySell

id ("o
S2C_PurchaseActivitySell
ret (

id (
sell (2.cs.AcitivitySell
awards (2	.cs.Award"<
S2C_FlushDaysActivity#
	activitys (2.cs.DaysActivity"
C2S_GetFundInfo"X
S2C_GetFundInfo
ret (

start_time (
	buy_count (
	open_time ("
C2S_GetUserFund":
S2C_GetUserFund
ret (
fund (2.cs.UserFund"4
UserFund
buy (
award (
weal ("
C2S_BuyFund"6
S2C_BuyFund
ret (
fund (2.cs.UserFund"
C2S_GetFundAward

id (";
S2C_GetFundAward
ret (
fund (2.cs.UserFund"
C2S_GetFundWeal

id (":
S2C_GetFundWeal
ret (
fund (2.cs.UserFund"
C2S_HOF_UIInfo
kind ("�
HOF_Info

id (
name (	
value (
points (
info (	
base_id (
dress_id (
clid (
cltm	 (
clop
 ("K
S2C_HOF_UIInfo
kind (
points (
infos (2.cs.HOF_Info"
C2S_HOF_Confirm

id (":
S2C_HOF_Confirm
ret (

id (
points ("
C2S_HOF_Sign
info (	")
S2C_HOF_Sign
ret (
info (	"G
C2S_HOF_RankInfo
kind (

start_rank (
	stop_rank ("�
HOF_RankInfo

id (
name (	
level (

fv (
base_id (
dress_id (
	sept_name (	
clid (
cltm	 (
clop
 ("{
S2C_HOF_RankInfo
kind (

start_rank (
	stop_rank (
infos (2.cs.HOF_RankInfo
	self_rank ("Q

CityIEvent

id (
start (
end (
name (	
times (":

CityREvent

id (
	reward_id (
times ("�
City

id (
start (
kac (
duration (

efficiency (
ie (2.cs.CityIEvent
re (2.cs.CityREvent
reward (
skac	 (
	sduration
 (
sefficiency (
level ("
C2S_CityTechUp

id ("8
S2C_CityTechUp
ret (

id (
level ("
C2S_CityInfo

id ("j
S2C_CityInfo

id (
assist_count (
city (2.cs.City
speed (
	totaltime ("
C2S_CityAttack"`
S2C_CityAttack
ret ('
battle_report (2.cs.BattleReport
award (2	.cs.Award"T
C2S_CityPatrol
city (
knight (
duration (

efficiency ("5
S2C_CityPatrol
ret (
city (2.cs.City"
C2S_CityReward
city ("J
S2C_CityReward
ret (
award (2	.cs.Award
	totaltime ("*
C2S_CityAssist

id (
city ("7
S2C_CityAssist
ret (
award (2	.cs.Award"
C2S_CityCheck

id ("F
S2C_CityCheck

id (
num (
patrol (
riot ("=
S2C_CityAssisted

id (
city_id (
name (	"
C2S_CityOneKeyReward"P
S2C_CityOneKeyReward
ret (
award (2	.cs.Award
	totaltime ("W
CityOneKeyPatrolSet

id (
skac (
	sduration (
sefficiency ("<
C2S_CityOneKeyPatrol$
tmp (2.cs.CityOneKeyPatrolSet"9
S2C_CityOneKeyPatrol!
citys (2.cs.S2C_CityPatrol"A
C2S_CityOneKeyPatrolSet&
cokps (2.cs.CityOneKeyPatrolSet"&
S2C_CityOneKeyPatrolSet
ret ("�
UserCustomActivityQuest
act_id (
quest_id (
time (
progress (

award_time (
award_times ("�
CustomActivity
act_id (
act_type (
title (	
	sub_title (	
desc (	
preview_time (

start_time (
end_time	 (

award_time
 (
	vip_level (
	icon_type (

icon_value (
	role_icon (
level (
max_vip (
	max_level (
	series_id ("�
CustomActivityQuest
quest_id (
act_id (

quest_type (
param1 (
param2 (
param3 (
consume_type1 (
consume_value1 (
consume_size1	 (
consume_type2
 (
consume_value2 (
consume_size2 (
consume_type3 (
consume_value3 (
consume_size3 (
consume_type4 (
consume_value4 (
consume_size4 (
award_type1 (
award_value1 (
award_size1 (
award_type2 (
award_value2 (
award_size2 (
award_type3 (
award_value3 (
award_size3 (
award_type4 (
award_value4 (
award_size4 (
award_select (
award_limit  (
server_limit! (
server_times" ("
C2S_GetCustomActivityInfo"�
S2C_GetCustomActivityInfo
ret ($
activity (2.cs.CustomActivity&
quest (2.cs.CustomActivityQuest/

user_quest (2.cs.UserCustomActivityQuest"�
S2C_UpdateCustomActivity$
activity (2.cs.CustomActivity&
quest (2.cs.CustomActivityQuest
delete_activity ("P
S2C_UpdateCustomActivityQuest/

user_quest (2.cs.UserCustomActivityQuest"]
C2S_GetCustomActivityAward
act_id (
quest_id (
award_id (
num ("j
S2C_GetCustomActivityAward
ret (
act_id (
quest_id (
award_id (
num ("3
S2C_UpdateCustomSeriesActivity
	series_id ("0
C2S_GetCustomSeriesActivity
	series_id ("�
S2C_GetCustomSeriesActivity
ret ($
activity (2.cs.CustomActivity&
quest (2.cs.CustomActivityQuest/

user_quest (2.cs.UserCustomActivityQuest
	series_id ("�
CorpSnapShot

id (
level (
size (
name (	
leader_name (	
announcement (	
icon_pic (

icon_frame (
has_join	 (
exp
 (".
C2S_GetCorpList
start (
tail ("\
S2C_GetCorpList
ret (
start (
tail (
corps (2.cs.CorpSnapShot"
C2S_GetJoinCorpList"C
S2C_GetJoinCorpList
ret (
corps (2.cs.CorpSnapShot"�

CorpDetail

id (
level (
size (
name (	
leader_name (	
announcement (	
icon_pic (

icon_frame (
exp	 (
notification
 (	
history_index (
position ("
C2S_GetCorpDetail"~
S2C_GetCorpDetail
ret (
has_corp (
corp (2.cs.CorpDetail
quit_corp_cd (
join_corp_time ("�

CorpMember

id (
name (	
level (
fight_value (
total_contribute (

worship_id (
worship_exp (
online (
	main_role	 (
join_corp_time
 (
position (
vip (
dress_id (
worship_point (
worship_time (
clid (
cltm (
clop ("
C2S_GetCorpMember"A
S2C_GetCorpMember
ret (
members (2.cs.CorpMember"T
CorpHistory

id (
info_id (
time (
key (	
value (	"1
C2S_GetCorpHistory
start (
tail ("`
S2C_GetCorpHistory
ret (
start (
tail ( 
history (2.cs.CorpHistory"(
S2C_NotifyCorpDismiss
dismiss ("D
C2S_CreateCorp
name (	
icon_pic (

icon_frame ("
S2C_CreateCorp
ret ("!
C2S_RequestJoinCorp

id ("N
S2C_RequestJoinCorp
ret (

id (
corp (2.cs.CorpSnapShot" 
C2S_DeleteJoinCorp

id ("M
S2C_DeleteJoinCorp
ret (

id (
corp (2.cs.CorpSnapShot"
C2S_QuitCorp"
S2C_QuitCorp
ret ("
C2S_SearchCorp
name (	"=
S2C_SearchCorp
ret (
corp (2.cs.CorpSnapShot"
C2S_ExchangeLeader"2
S2C_ExchangeLeader
ret (
user_id ("7
C2S_ConfirmJoinCorp
user_id (
confirm ("D
S2C_ConfirmJoinCorp
ret (
user_id (
confirm ("b
C2S_ModifyCorp
announcement (	
icon_pic (

icon_frame (
notification (	"
S2C_ModifyCorp
ret ("#
C2S_DismissCorpMember

id ("0
S2C_DismissCorpMember
ret (

id ("
C2S_GetCorpJoin"�
CorpJoin

id (
name (	
level (
fight_value (
online (
	main_role (
vip (
dress_id (
quit_corp_cd	 (
clid
 (
cltm (
clop (";
S2C_GetCorpJoin
ret (
joins (2.cs.CorpJoin"
C2S_DismissCorp"
S2C_DismissCorp
ret ("
S2C_MyCorpChangedByCorpLeader"-
C2S_CorpStaff

id (
position (":
S2C_CorpStaff
ret (

id (
position ("
C2S_GetCorpWorship"�
S2C_GetCorpWorship
ret (
worship_level (
worship_point (
worship_count (

worship_id
 (
worship_exp (
worship_crit (
worship_award (" 
C2S_CorpContribute

id ("l
S2C_CorpContribute
ret (

id (
worship_crit (
worship_exp (

corp_point ("+
C2S_GetCorpContributeAward
index ("S
S2C_GetCorpContributeAward
ret (
index (
awards (2	.cs.Award"7
CorpShopItem

id (
num (
bought ("
C2S_GetCorpSpecialShop"`
S2C_GetCorpSpecialShop
ret (
next_refresh_time (
item (2.cs.CorpShopItem"%
C2S_CorpSpecialShopping

id ("m
S2C_CorpSpecialShopping
ret (

id (
awards (2	.cs.Award
item (2.cs.CorpShopItem"
C2S_GetHolidayEventInfo"Z
S2C_GetHolidayEventInfo
ret (
time ($
award (2.cs.HolidayEventAward",
HolidayEventAward

id (
num ("&
C2S_GetHolidayEventAward

id ("@
S2C_GetHolidayEventAward
ret (

id (
num ("
C2S_GetCorpChapter"�
S2C_GetCorpChapter
ret (

chapter_id (

today_chid (

hp (
max_hp (
chapter_count (
chapters (

reset_cost ("{
CorpDungeon

id (
info_id (
max_hp (

hp ( 
monster (2.cs.CorpMonster
	kill_name (	"8
CorpMonster
index (

hp (
max_hp (",
C2S_GetCorpDungeonInfo

chapter_id ("[
S2C_GetCorpDungeonInfo
ret (

chapter_id ( 
dungeon (2.cs.CorpDungeon"5
C2S_ExecuteCorpDungeon

id (
info_id ("�
S2C_ExecuteCorpDungeon
ret (

id (
info_id (
info (2.cs.BattleReport 
dungeon (2.cs.CorpDungeon
harm (

corp_point (
final_award	 (2	.cs.Award"r
S2C_FlushCorpDungeon 
dungeon (2.cs.CorpDungeon

hp (
name (	
last_hit (
harm (""
C2S_SetCorpChapterId

id ("/
S2C_SetCorpChapterId
ret (

id ("
C2S_GetDungeonAwardList"H
DungeonAward

id (
user_id (
name (	
index ("~
S2C_GetDungeonAwardList
ret (
	has_award (
list (2.cs.DungeonAward
	has_point (
has_auth ("$
C2S_GetDungeonAward
index ("}
S2C_GetDungeonAward
ret (
index (
	has_award (
da (2.cs.DungeonAward
awards (2	.cs.Award"5
S2C_FlushDungeonAward
da (2.cs.DungeonAward"
C2S_GetDungeonAwardCorpPoint"R
S2C_GetDungeonAwardCorpPoint
ret (

corp_point (
	has_point ("�
CorpChapterGlobalRank

id (
name (	
harm (
rank (
corp_id (
	corp_name (	
	main_role (
dress_id (
vip	 (
clid
 (
cltm (
clop ("
C2S_GetDungeonCorpRank"b
S2C_GetDungeonCorpRank
ret (
	self_rank ((
ranks (2.cs.CorpChapterGlobalRank"
C2S_GetDungeonCorpMemberRank"�
CorpChapterRank

id (
name (	
harm (
	main_role (
dress_id (
vip (
sp1 (
clid (
cltm	 (
clop ("O
S2C_GetDungeonCorpMemberRank
ret ("
ranks (2.cs.CorpChapterRank"
C2S_ResetDungeonCount"$
S2C_ResetDungeonCount
ret ("&
	C2S_Share

id (
extra ("$
	S2C_Share
ret (

id ("&

ShareState

id (
step ("
C2S_GetShareState	
t ("G
S2C_GetShareState
state (2.cs.ShareState
share_count ("
C2S_GetPhoneBindNotice"(
S2C_GetPhoneBindNotice
notice (	"
C2S_GetRechargeBack"f
S2C_GetRechargeBack
ret (
has_recharge (
money (
gold (
vip_exp ("
C2S_RechargeBackGold"9
S2C_RechargeBackGold
ret (
has_recharge ("�
CorpChapterIdRank

id (
level (
size (
name (	
leader_name (	
icon_pic (

icon_frame (

chapter_id	 (
rank
 ("
C2S_GetCorpChapterRank"K
S2C_GetCorpChapterRank
ret ($
ranks (2.cs.CorpChapterIdRank"#
C2S_ComposeAwakenItem

id ("0
S2C_ComposeAwakenItem
ret (

id ("4
C2S_FastComposeAwakenItem

id (
num ("A
S2C_FastComposeAwakenItem
ret (

id (
num (";
C2S_PutonAwakenItem
kid (
pos (

id (""
S2C_PutonAwakenItem
ret ("4
C2S_AwakenKnight
kid (
knight_list ("
S2C_AwakenKnight
ret ("
C2S_GetCorpCrossBattleInfo"V
S2C_GetCorpCrossBattleInfo
ret (
state (
apply (
field ("
C2S_ApplyCorpCrossBattle"'
S2C_ApplyCorpCrossBattle
ret ("
C2S_QuitCorpCrossBattle"&
S2C_QuitCorpCrossBattle
ret ("
C2S_GetCorpCrossBattleList"&

BattleCorp

id (
name (	"H
S2C_GetCorpCrossBattleList
ret (
corps (2.cs.BattleCorp"I
S2C_FlushCorpCrossBattleList
add (
corp (2.cs.BattleCorp"
C2S_GetCrossBattleEncourage"�
S2C_GetCrossBattleEncourage
ret (
total_hp_count (
total_atk_count (
hp_count (
	atk_count ("*
C2S_CrossBattleEncourage
e_type ("�
S2C_CrossBattleEncourage
ret (
e_type (
success (
total_hp_count (
total_atk_count (
hp_count (
	atk_count ("
C2S_GetCrossBattleField"�
CrossBattleCorp
sid (
sname (	
corp_id (
name (	
	total_exp (
level (
fire_on (
rob_exp (

robbed_exp	 (
total_hp
 (
	total_atk (
icon_pic (

icon_frame (
each_exp (
total_robbed_exp ("�
S2C_GetCrossBattleField
ret (

kill_count (
rob_exp (

refresh_cd (
	battle_cd (
battle_cost (!
corp
 (2.cs.CrossBattleCorp"O
C2S_GetCrossBattleEnemyCorp
sid (
corp_id (

is_refresh ("�
CrossBattleUser

id (
name (	
	main_role (
dress_id (
fight_value (
times (
score (
clid (
cltm	 (
clop ("�
S2C_GetCrossBattleEnemyCorp
ret (
sid (
corp_id (

is_refresh (
	is_finish (

refresh_cd ("
users (2.cs.CrossBattleUser"N
C2S_CrossBattleChallengeEnemy
sid (
corp_id (
user_id ("�
S2C_CrossBattleChallengeEnemy
ret (
sid (
corp_id (
user_id (
info (2.cs.BattleReport

corp_point (
corp_exp (
	battle_cd (!
user	 (2.cs.CrossBattleUser"!
C2S_ResetCrossBattleChallengeCD"V
S2C_ResetCrossBattleChallengeCD
ret (
	battle_cd (
battle_cost ("8
C2S_SetCrossBattleFireOn
sid (
corp_id ("E
S2C_SetCrossBattleFireOn
ret (
sid (
corp_id ("
C2S_CrossBattleMemberRank"�
CrossBattleRank
user_id (
name (	
rob_exp (

kill_count (
	main_role (
dress_id (
vip (
clid (
cltm	 (
clop ("L
S2C_CrossBattleMemberRank
ret ("
ranks (2.cs.CrossBattleRank"#
S2C_BroadCastState
state ("
C2S_GetCorpCrossBattleTime"9

BattleTime
state (
start (
close ("H
S2C_GetCorpCrossBattleTime
ret (
times (2.cs.BattleTime".
S2C_FlushCorpCrossBattleField
field ("c
S2C_FlushCorpEncourage
sid (
corp_id (
hp_encourage (
atk_encourage ("?
S2C_FlushCorpBattleResult"
corps (2.cs.CrossBattleCorp"/
S2C_FlushFireOn
sid (
corp_id ("Q
S2C_FlushBattleMemberInfo
user_id (

kill_count (
rob_exp ("
C2S_WheelInfo"�
S2C_WheelInfo
score (
score_total (
pool (

got_reward (
pool2 (
start (
end (
present (
bought_times1	 (
bought_times2
 ("*
C2S_PlayWheel

id (
times ("u
S2C_PlayWheel
ret (
money (
	reward_id (

id (
rank (
pool (
pool2 ("
C2S_WheelReward"8
S2C_WheelReward
ret (
award (2	.cs.Award"y
WheelRanking
name (	
score (
mainrole (
dress_id (
clid (
cltm (
clop ("
C2S_WheelRankingList"F
S2C_WheelRankingList!
ranking (2.cs.WheelRanking
ret ("
C2S_Hard_GetChapterList"�
S2C_Hard_GetChapterList
ret (

total_star (
fast_execute_time (
fast_execute_cd (
chapters (2.cs.Chapter"
C2S_Hard_GetChapterRank"Y
S2C_Hard_GetChapterRank
ret (
	self_rank (
ranks (2.cs.ChapterRank">
S2C_Hard_AddStage
chpt_id (
stage (2	.cs.Stage"#
C2S_Hard_ExecuteStage

id ("�
S2C_Hard_ExecuteStage
ret (

id (
stage (2	.cs.Stage
type (
awards (2	.cs.Award
stage_money (
	stage_exp	 (

stage_star
 (
rebel (
rebel_level ("9
C2S_Hard_ExecuteMultiStage

id (
wave_id ("k
S2C_Hard_ExecuteMultiStage
ret (

id (
info (2.cs.BattleReport
next_wave_id ("'
C2S_Hard_FastExecuteStage

id ("�
S2C_Hard_FastExecuteStage
ret (

id (
fast_execute_time (
fast_execute_cd (
stage (2	.cs.Stage
awards (2	.cs.Award
stage_money (
	stage_exp (

stage_star	 (
rebel
 (
rebel_level ("2
C2S_Hard_ResetDungeonExecution
stage_id ("r
S2C_Hard_ResetDungeonExecution
ret (
stage_id (
stage (2	.cs.Stage
next_reset_cost ("?
C2S_Hard_FinishChapterBoxRwd
ch_id (
box_type ("L
S2C_Hard_FinishChapterBoxRwd
ret (
ch_id (
box_type ("S
ChapterRoit
ch_id (
	open_time (
roit_id (
	is_finish ("
C2S_Hard_GetChapterRoit"F
S2C_Hard_GetChapterRoit
ret (
roits (2.cs.ChapterRoit"+
C2S_Hard_FinishChapterRoit
ch_id ("�
S2C_Hard_FinishChapterRoit
ret (
ch_id (
roit (2.cs.ChapterRoit
info (2.cs.BattleReport
awards (2	.cs.Award
money (
exp ("(
C2S_Hard_FirstEnterChapter

id ("S
S2C_Hard_FirstEnterChapter
ret (

id (
chapter (2.cs.Chapter"
C2S_VipDiscountInfo".
S2C_VipDiscountInfo

id (
ret (" 
C2S_BuyVipDiscount

id ("!
S2C_BuyVipDiscount
ret (";
C2S_GetTencentReward
award_id (
	server_id ("
C2S_GetCrossBattleInfo"V
S2C_GetCrossBattleInfo
ret (
state (
group (
	has_arena ("
C2S_GetCrossBattleTime"D
S2C_GetCrossBattleTime
ret (
times (2.cs.BattleTime"+
C2S_SelectCrossBattleGroup
group ("8
S2C_SelectCrossBattleGroup
ret (
group ("
C2S_EnterScoreBattle"�
S2C_EnterScoreBattle
ret (
score (
rank (
refresh_cost (
battle_cost (
wins (
refresh_count (
battle_count (
max_wins	 (

buy_battle
 ("-
C2S_GetCrossBattleEnemy

is_refresh ("�
CrossSingleUser

id (
name (	
	main_role (
dress_id (
fight_value (
sid (
sname (	
group (
c_type	 (
	has_fight
 (
clid (
cltm (
clop ("a
S2C_GetCrossBattleEnemy
ret (
refresh_count ("
users (2.cs.CrossSingleUser"=
C2S_ChallengeCrossBattleEnemy
sid (
user_id ("�
S2C_ChallengeCrossBattleEnemy
ret (
sid (
user_id (
info (2.cs.BattleReport
battle_count (
awards (2	.cs.Award
max_wins (
wins (
score	 (
rank
 ("
C2S_GetWinsAwardInfo"0
S2C_GetWinsAwardInfo
ret (
ids ("!
C2S_FinishWinsAward

id ("I
S2C_FinishWinsAward
ret (

id (
awards (2	.cs.Award"'
C2S_GetCrossBattleRank
group ("X
S2C_GetCrossBattleRank
ret (
group ("
ranks (2.cs.CrossSingleRank"�
CrossSingleRank
user_id (
sid (
name (	
sname (	
	main_role (
dress_id (
score (
max_wins	 (
fight_value
 (
rank (
clid (
cltm (
clop ("8
C2S_CrossCountReset

reset_type (
count ("�
S2C_CrossCountReset
ret (

reset_type (
refresh_cost (
refresh_count (
battle_cost (
battle_count (

buy_battle (
count ("<
S2C_FlushCrossContestScore
user_id (
score (":
S2C_FlushCrossContestRank
user_id (
rank (",
C2S_RecycleDress

id (
type ("G
S2C_RecycleDress
ret (
award (2	.cs.Award
type ("
C2S_ChangeTitle

id ("*
S2C_ChangeTitle
ret (

id ("
C2S_GetTimeDungeonList"H
S2C_GetTimeDungeonList
ret (!
info (2.cs.TimeDungeonInfo"=
S2C_FlushTimeDungeonList!
info (2.cs.TimeDungeonInfo"H
TimeDungeonInfo
type_id (

start_time (
end_time ("
C2S_GetTimeDungeonInfo"L
S2C_GetTimeDungeonInfo
ret (%
info (2.cs.UserTimeDungeonInfo"W
UserTimeDungeonInfo

id (
time (
dungeon_index (
buff_id ("L
C2S_AddTimeDungeonBuff

id (
dungeon_index (
buff_id ("L
S2C_AddTimeDungeonBuff
ret (%
info (2.cs.UserTimeDungeonInfo":
C2S_AttackTimeDungeon

id (
dungeon_index ("�
S2C_AttackTimeDungeon
ret ('
battle_report (2.cs.BattleReport%
info (2.cs.UserTimeDungeonInfo
award (2	.cs.Award"
C2S_RichInfo"�
S2C_RichInfo
step (
score (

got_reward (
	shop_item (
shop_item_count (
round_award (
start (
end (
present	 (
bought_times
 ("9
C2S_RichMove
dice (
count (
step ("�
S2C_RichMove
ret (
dice (
reroll (
award (2	.cs.Award
goods (
count (
event ("(
C2S_RichBuy

id (
count ("
S2C_RichBuy
ret ("*
C2S_RichReward
type (

id ("
S2C_RichReward
ret ("
C2S_RichRankingList"E
S2C_RichRankingList!
ranking (2.cs.WheelRanking
ret ("
C2S_GetCodeId"
S2C_GetCodeId

id (	"
C2S_GetCode"
S2C_GetCode
code (	"
C2S_SetCDLevel
level ("
S2C_SetCDLevel
ret ("
C2S_UpdateFightValue"
C2S_GetSpreadId"*
S2C_GetSpreadId
ret (

id (	"
C2S_RegisterId

id (	"3
S2C_RegisterId
ret (
invitor_code (	"
C2S_InvitorGetRewardInfo"z
InvitorRewardInfo
	reward_id (
invited_qua (
invited_name (	

invited_id (
invited_sid ("�
S2C_InvitorGetRewardInfo
score (
	sum_score (
invited_num ()

can_reward (2.cs.InvitorRewardInfo)

has_reward (2.cs.InvitorRewardInfo"
C2S_InvitorDrawScoreReward"*
S2C_InvitorDrawScoreReward
rret ("�
C2S_InvitorDrawLvlReward
	reward_id (

invited_id (
invited_sid (
invited_name (	
invited_qua ("#
C2S_InvitedDrawReward

id ("
C2S_InvitedGetDrawReward")
InvitedReward

id (
stat (";
S2C_InvitedGetDrawReward
list (2.cs.InvitedReward"
C2S_QueryRegisterRelation")
S2C_QueryRegisterRelation
rret ("'
S2C_InvitorDrawLvlReward
ret ("$
S2C_InvitedDrawReward
ret ("
C2S_GetCrossArenaInfo"s
S2C_GetCrossArenaInfo
ret (
invited (
challenge_count (
	buy_count (
buy_cost ("
C2S_GetCrossArenaInvitation"j
S2C_GetCrossArenaInvitation
ret (
invite_type (
rank (
group (
time ("�
	CrossUser

id (
sid (
name (	
sname (	
dress_id (
	main_role (
fight_value (
sp1 (
sp2	 (
	fight_pet
 (
level (
fid (
vip (
sp3 (
sp4 (
sp5 (
sp6 (
sp7 (
sp8 (
clid (
cltm (
clop ("
C2S_GetCrossArenaBetsInfo"j
S2C_GetCrossArenaBetsInfo
ret (
	total_bet (
bet ( 
	bet_users (2.cs.CrossUser"
C2S_GetCrossArenaBetsList"F
S2C_GetCrossArenaBetsList
ret (
users (2.cs.CrossUser"H
C2S_CrossArenaPlayBets
user_id (
sid (
bet_rank ("s
S2C_CrossArenaPlayBets
ret (
user_id (
sid (
bet_rank (
users (2.cs.CrossUser"
C2S_GetCrossArenaRankTop"E
S2C_GetCrossArenaRankTop
ret (
users (2.cs.CrossUser"
C2S_GetCrossArenaRankUser"T
S2C_GetCrossArenaRankUser
ret (
rank (
users (2.cs.CrossUser"5
C2S_CrossArenaRankChallenge
challenge_rank ("�
S2C_CrossArenaRankChallenge
ret (
challenge_rank ('
battle_report (2.cs.BattleReport
challenge_count (
awards (2	.cs.Award")
C2S_CrossArenaCountReset
count ("t
S2C_CrossArenaCountReset
ret (
count (
challenge_count (
	buy_count (
buy_cost ("
C2S_GetCrossArenaBetsAward"k
S2C_GetCrossArenaBetsAward
ret (
award (
award_id (

award_size (
bet ("
C2S_CrossArenaServerAwardInfo"9
S2C_CrossArenaServerAwardInfo
ret (
ids ("-
C2S_FinishCrossArenaServerAward

id ("U
S2C_FinishCrossArenaServerAward
ret (

id (
awards (2	.cs.Award"
C2S_FinishCrossArenaBetsAward"V
S2C_FinishCrossArenaBetsAward
ret (
award (
awards (2	.cs.Award"%
C2S_CrossArenaAddBets
size ("A
S2C_CrossArenaAddBets
ret (
size (
total ("6
C2S_GetCrossUserDetail
user_id (
sid ("f
S2C_GetCrossUserDetail
ret (
user_id (
sid (!
user (2.cs.ArenaBattleUser"�
	RebelBoss

id (

hp (
max_hp (
level (
killer_name (	
killer_time (
last_att_index (
produce_time ("
C2S_EnterRebelBossUI"�
S2C_EnterRebelBossUI
ret (
total_honor (
group_thonor_rank (
max_harm (
group_mharm_rank (
	corp_rank (!

rebel_boss (2.cs.RebelBoss
state	 (,
group_first_ranks
 (2.cs.RebelBossRank
	att_count (
remain_pur_count (
group (
end_time ("
C2S_FlushBossACountTime"A
S2C_FlushBossACountTime
ret (
attack_count_time ("/
C2S_SelectAttackRebelBossGroup
group ("<
S2C_SelectAttackRebelBossGroup
ret (
group ("&
C2S_ChallengeRebelBoss
time ("�
S2C_ChallengeRebelBoss
ret ( 
report (2.cs.BattleReport
honor (
harm (
faward (2	.cs.Award
kaward (2	.cs.Award
crit_id ("�
RebelBossRank

id (
fight_value (
mode (
value (
rank (
name (	
	corp_name (	
user_id (
dress_id	 (
group
 (
clid (
cltm (
clop ("A
RebelBossSimpleRank
rank (
group (
value ("0
C2S_RebelBossRank
mode (
group ("�
S2C_RebelBossRank
ret (
mode (
group ($
	rbh_ranks (2.cs.RebelBossRank%

rbmh_ranks (2.cs.RebelBossRank,
rbh_my_rank (2.cs.RebelBossSimpleRank-
rbmh_my_rank (2.cs.RebelBossSimpleRank"&
C2S_RebelBossAwardInfo
mode ("C
S2C_RebelBossAwardInfo
ret (
mode (
status (".
C2S_RebelBossAward
mode (

id ("H
S2C_RebelBossAward
ret (

id (
awards (2	.cs.Award"1
AttackRebelBossInfo
name (	
harm (".
C2S_RefreshRebelBoss
last_att_index ("n
S2C_RefreshRebelBoss
ret (!

rebel_boss (2.cs.RebelBoss&
infos (2.cs.AttackRebelBossInfo"(
C2S_PurchaseAttackCount
count ("V
S2C_PurchaseAttackCount
ret (
attack_count (
remain_pur_count ("
C2S_GetRebelBossReport"�

BossReport
boss_id (

boss_level (
time1 (
name1 (	
award1 (2	.cs.Award
time2 (
name2 (	
award2 (2	.cs.Award"F
S2C_GetRebelBossReport
ret (
reports (2.cs.BossReport"
C2S_RebelBossCorpAwardInfo"P
RBCRS
activity_status (
award_status (
condition_status ("^
RebelBoss_CorpRank
rank (
	corp_name (	
honor (
state (2	.cs.RBCRS"y
S2C_RebelBossCorpAwardInfo
ret (%
ranks (2.cs.RebelBoss_CorpRank'
my_rank (2.cs.RebelBoss_CorpRank"
C2S_GetBlackcardWarning"*
S2C_GetBlackcardWarning
warning ("
C2S_VipDailyInfo"+
S2C_VipDailyInfo

id (
ret ("
C2S_BuyVipDaily"
S2C_BuyVipDaily
ret ("
C2S_ShopTimeInfo"g
S2C_ShopTimeInfo
ret (
progress (
time (

rechargeId (

extra_gold ("
C2S_ShopTimeRewardInfo"Q
S2C_ShopTimeRewardInfo
ret (

welfare_id (
recharge_count ("#
C2S_ShopTimeGetReward

id ("?
S2C_ShopTimeGetReward
ret (
awards (2	.cs.Award"k
S2C_ShopTimePurchase
ret (
progress (
time (

rechargeId (

extra_gold ("
C2S_ShopTimeStartTime"8
S2C_ShopTimeStartTime
ret (

start_time ("
C2S_GetUserRice"
S2C_GetUserRice
ret ("5
S2C_UpdateUserRice
	user_rice (2.cs.UserRice"
C2S_FlushRiceRivals""
S2C_FlushRiceRivals
ret ("
C2S_RobRice
user_id ("�
S2C_RobRice
ret ('
battle_report (2.cs.BattleReport
rewards (2	.cs.Award
rob_init_rice (
rob_growth_rice (
rob_crit_rice ("{
S2C_ChangeUserRice
user_id (
	init_rice (
growth_rice (
rice_refresh_time (
	rice_rank ("
C2S_GetRiceEnemyInfo"B
S2C_GetRiceEnemyInfo
ret (
enemys (2.cs.RiceEnemy"(
C2S_RevengeRiceEnemy
enemy_id ("�
S2C_RevengeRiceEnemy
ret (
enemy_id ('
battle_report (2.cs.BattleReport
rewards (2	.cs.Award
rob_init_rice (
rob_growth_rice (
rob_crit_rice ("0
C2S_GetRiceAchievement
achievement_id ("Y
S2C_GetRiceAchievement
ret (
achievement_id (
rewards (2	.cs.Award"
C2S_GetRiceRankList"X
S2C_GetRiceRankList
ret (#
	rank_list (2.cs.RiceRankUser
my_rank ("
C2S_GetRiceRankAward"M
S2C_GetRiceRankAward
ret (
rank (
rewards (2	.cs.Award"3
C2S_BuyRiceToken

token_type (
num ("
S2C_BuyRiceToken
ret ("7
S2C_FlushRiceRank
user_id (
	rice_rank ("
C2S_PushSingleInfo"Y
S2C_PushSingleInfo
content (	
pushtime (
level (
	vip_level ("*
C2S_GetInvitorName
invitor_code (	"<
S2C_GetInvitorName
ret (
sid (
name (	"{
MonthFundTime
recharge_start_time (
recharge_end_time (
reward_start_time (
reward_end_time ("
C2S_GetMonthFundBaseInfo"�
S2C_GetMonthFundBaseInfo
ret (#
mfd_time (2.cs.MonthFundTime
	fund_kind (
activate (
buy_big (
	buy_small ("J
	MonthFund
day (
award_days_big (
award_days_small ("
C2S_GetMonthFundAwardInfo"E
S2C_GetMonthFundAwardInfo
ret (
fund (2.cs.MonthFund"2
C2S_GetMonthFundAward
day (
type ("A
S2C_GetMonthFundAward
ret (
fund (2.cs.MonthFund"=
CorpChapterSnapShot

id (

hp (
max_hp ("1
C2S_SetNewCorpRollbackChapter
rollback (">
S2C_SetNewCorpRollbackChapter
ret (
rollback ("
C2S_CorpUpLevel":
S2C_CorpUpLevel
ret (
level (
exp ("6
S2C_CorpUpLevelBroadcast
level (
exp ("/
CorpTech
tech_id (

tech_level ("
C2S_GetCorpTechInfo"f
S2C_GetCorpTechInfo
ret ( 

corp_techs (2.cs.CorpTech 

user_techs (2.cs.CorpTech"&
C2S_DevelopCorpTech
tech_id ("T
S2C_DevelopCorpTech
ret (
tech_id (

tech_level (
exp ("@
S2C_DevelopCorpTechBroadcast 

corp_techs (2.cs.CorpTech"$
C2S_LearnCorpTech
tech_id ("E
S2C_LearnCorpTech
ret (
tech_id (

tech_level ("
C2S_GetNewCorpChapter"�
S2C_GetNewCorpChapter
ret ()
chapters (2.cs.CorpChapterSnapShot
	finish_ch (
chapter_count (

reset_cost (
finish_awards (
rollback_chapter ("/
C2S_GetNewCorpDungeonInfo

chapter_id ("^
S2C_GetNewCorpDungeonInfo
ret (

chapter_id ( 
dungeon (2.cs.CorpDungeon"'
C2S_ExecuteNewCorpDungeon

id ("�
S2C_ExecuteNewCorpDungeon
ret (

id (
info (2.cs.BattleReport 
dungeon (2.cs.CorpDungeon
harm (

corp_point (
final_award	 (2	.cs.Award
star
 ("i
S2C_FlushNewCorpDungeon 
dungeon (2.cs.CorpDungeon
name (	
last_hit (
harm ("0
C2S_GetNewDungeonAwardList

dungeon_id ("�
S2C_GetNewDungeonAwardList
ret (

dungeon_id (
	has_award (
list (2.cs.DungeonAward
has_auth (";
C2S_GetNewDungeonAward

dungeon_id (
index ("�
S2C_GetNewDungeonAward
ret (

dungeon_id (
index (
	has_award (
da (2.cs.DungeonAward
awards (2	.cs.Award"!
C2S_GetNewDungeonCorpMemberRank"R
S2C_GetNewDungeonCorpMemberRank
ret ("
ranks (2.cs.CorpChapterRank"L
S2C_FlushNewDungeonAward

dungeon_id (
da (2.cs.DungeonAward"
C2S_ResetNewDungeonCount"R
S2C_ResetNewDungeonCount
ret (
chapter_count (

reset_cost ("$
C2S_GetNewChapterAward

id ("L
S2C_GetNewChapterAward
ret (

id (
awards (2	.cs.Award"
C2S_GetNewDungeonAwardHint"a
	AwardHint

id (
	has_award (
has_auth (
	is_finish (
award_id ("G
S2C_GetNewDungeonAwardHint
ret (
hints (2.cs.AwardHint"8
C2S_TreasureSmelt
index (
treasure_ids (" 
S2C_TreasureSmelt
ret ("
C2S_TreasureForge

id (">
S2C_TreasureForge
ret (

id (
forge_id ("
C2S_GetNewCorpChapterRank"N
S2C_GetNewCorpChapterRank
ret ($
ranks (2.cs.CorpChapterIdRank"
C2S_ThemeDropZY"y
S2C_ThemeDropZY
ret (
zy_cycle (

star_value (
left_consume_times (
left_free_times ("8
C2S_ThemeDropAstrology
type (
zy_cycle ("R
AstrologyResult

star_value (
	knight_id (
award (2	.cs.Award"�
S2C_ThemeDropAstrology
ret (
left_consume_times (
left_free_times (
type (
sv_sum (#
result (2.cs.AstrologyResult";
C2S_ThemeDropExtract
	knight_id (
zy_cycle ("D
S2C_ThemeDropExtract
ret (

star_value (
kid ("^
SpeXialRankInfo
user_id (
rank (
score (
name (	
base_id ("
C2S_GetSpeXialScoreInfo"E
S2C_GetSpeXialScoreInfo
ret (
score (
awards ("
C2S_GetSpeXialScoreRank"_
S2C_GetSpeXialScoreRank
ret (&
	rank_list (2.cs.SpeXialRankInfo
my_rank (",
C2S_GetSpeXialScoreAward
award_id ("9
S2C_GetSpeXialScoreAward
ret (
award_id ("
C2S_WushBossInfo"Y
S2C_WushBossInfo
	active_id (
first_id (
times (
	buy_times ("#
C2S_WushBossChallenge

id ("s
S2C_WushBossChallenge
ret ('
battle_report (2.cs.BattleReport
award (2	.cs.Award

id ("
C2S_WushBossBuy"
S2C_WushBossBuy
ret ("�
GroupBuyTime
name (	
content (	

start_time (
end_time (
award_end_time (
	vip_level (
level ("�
GroupBuyItem

id (
type (
value (
size (
initial_price (
initial_off (
coupon_use_percent (
buyer_num_1 (
off_price_1	 (
buyer_num_2
 (
off_price_2 (
buyer_num_3 (
off_price_3 (
buyer_num_4 (
off_price_4 (
buy_max_day (
coupon_give_percent (
level (
	vip_level ("H
GroupBuyItemData

id (
server_count (

self_count ("$
C2S_GetGroupBuyConfig
md5 (	"R
S2C_GetGroupBuyConfig
ret (
md5 (	
items (2.cs.GroupBuyItem"
C2S_GetGroupBuyMainInfo"_
S2C_GetGroupBuyMainInfo
ret (
score ((

item_datas (2.cs.GroupBuyItemData";
C2S_GetGroupBuyRanking
type (
max_rank_id ("�
S2C_GetGroupBuyRanking
ret (
type (
self_rank_id (
handred_score (
gb_user (2.cs.CrossUser"
C2S_GetGroupBuyTaskAwardInfo"{
S2C_GetGroupBuyTaskAwardInfo
ret (

self_score (
server_score (
	back_gold (
	award_ids ("&
C2S_GetGroupBuyTaskAward

id ("U
S2C_GetGroupBuyTaskAward
ret (
awards (2	.cs.Award
	award_ids ("
C2S_GetGroupBuyEndInfo"�
S2C_GetGroupBuyEndInfo
ret (
self_rank_id (

self_score (
is_acquired (
gb_user (2.cs.CrossUser"
C2S_GetGroupBuyRankAward"W
S2C_GetGroupBuyRankAward
ret (
is_acquired (
awards (2	.cs.Award"'
C2S_GroupBuyPurchaseGoods

id ("m
S2C_GroupBuyPurchaseGoods
ret (

id (

self_count (
server_count (
score ("
C2S_GetGroupBuyTimeInfo"J
S2C_GetGroupBuyTimeInfo
ret ("
time_cfg (2.cs.GroupBuyTime"
C2S_RookieInfo"G
S2C_RookieInfo
create_time (
award_id (
active ("!
C2S_GetRookieReward

id (".
S2C_GetRookieReward
ret (

id (""
C2S_SetPictureFrame
fid ("/
S2C_SetPictureFrame
ret (
fid ("�
BattleFieldSample

id (
sid (
user_id (
fight_value (
hp_rate (
name (	
level (")
C2S_GetBattleFieldInfo
bf_type ("�
S2C_GetBattleFieldInfo
ret (
bf_type (
bf_tag (+
battle_field (2.cs.BattleFieldSample
challenge_count (

reset_cost (
reset_count (

current_id (
history_pet_point	 (
current_pet_point
 ("O
ChallengeKnightHp
index (

hp (
max_hp (
base_id ("#
C2S_BattleFieldDetail

id ("�
S2C_BattleFieldDetail
ret (

id (&
knights (2.cs.ChallengeKnightHp
user (2.cs.CrossUser
	pet_point ("&
C2S_ChallengeBattleField

id ("�
S2C_ChallengeBattleField
ret (

id (
info (2.cs.BattleReport
	pet_point (
challenge_count (%
sample (2.cs.BattleFieldSample
awards (2	.cs.Award"
C2S_BattleFieldAwardInfo"^
S2C_BattleFieldAwardInfo
ret (
drop_id (
	drop_cost (
	drop_time ("
C2S_GetBattleFieldAward"x
S2C_GetBattleFieldAward
ret (
awards (2	.cs.Award
drop_id (
	drop_cost (
	drop_time ("
C2S_BattleFieldShopInfo"L
S2C_BattleFieldShopInfo
refresh_count (
free_refresh_count ("*
C2S_BattleFieldShopRefresh
type ("h
S2C_BattleFieldShopRefresh
ret (

id (
refresh_count (
free_refresh_count ("
C2S_GetBattleFieldRank"C
S2C_GetBattleFieldRank
ret (
users (2.cs.CrossUser"?
C2S_PetUpLvl
pet_id (
consume_items (2.cs.Item"M
S2C_PetUpLvl
ret (
pet_id (
pet_exp (
pet_lvl ("
C2S_PetUpStar
pet_id (">
S2C_PetUpStar
ret (
pet_id (
pet_star ("C
C2S_PetUpAddition
pet_id (
consume_item (2.cs.Item"d
S2C_PetUpAddition
ret (
pet_id (
pet_addition_exp (
pet_addition_lvl ("$
C2S_ChangeFightPet
pet_id ("E
S2C_ChangeFightPet
ret (
pet_id (

old_pet_id (".
C2S_RecyclePet
pet_id (
type ("h
S2C_RecyclePet
ret (
item (2	.cs.Award
money (
type (
fight_score ("
C2S_GetPetProtect"#
S2C_GetPetProtect
pet_id ("0
C2S_SetPetProtect
pos (
pet_id ("=
S2C_SetPetProtect
ret (
pos (
pet_id ("
C2S_DungeonDailyInfo"$
S2C_DungeonDailyInfo
dids ("<
C2S_DungeonDailyChallenge
did (

hard_level ("v
S2C_DungeonDailyChallenge
ret (
dids (
info (2.cs.BattleReport
drop_awards (2	.cs.Award"K
TrigramInfo
awards (2	.cs.Award
award_level (
open ("
C2S_TrigramInfo"�
S2C_TrigramInfo
score (

got_reward (
info (2.cs.TrigramInfo
count (
start (
end (
present ("
C2S_TrigramPlay
pos ("v
S2C_TrigramPlay
ret (
pos (
open_id ()
new_trigram_info (2.cs.TrigramInfo
score ("
C2S_TrigramPlayAll"[
S2C_TrigramPlayAll
ret ()
new_trigram_info (2.cs.TrigramInfo
score ("
C2S_TrigramRefresh"L
S2C_TrigramRefresh
ret ()
new_trigram_info (2.cs.TrigramInfo"
C2S_TrigramReward";
S2C_TrigramReward
ret (
awards (2	.cs.Award"J
Ranking
name (	
score (
mainrole (
dress_id ("
C2S_GetTrigramRank"A
S2C_GetTrigramRank
ranking (2.cs.CrossUser
ret (":
C2S_UpStarEquipment
	cost_type (
equip_id ("q
S2C_UpStarEquipment
ret (
equip_id (
star (
exp (

luck_value (
crit (""
C2S_FragmentSale
frgids ("
S2C_FragmentSale
ret ("a
CrossPvpInfo
stage (
	level_min (
	level_max (
max (
current (":
CrossPvpSchedule&
activity (2.cs.CrossPvpActivity"W
CrossPvpActivity
info (2.cs.CrossPvpInfo#
details (2.cs.CrossPvpDetail"�
CrossPvpDetail
round (
has_bet (

start_time (
	view_time (
pre_time (
battle_time (
end_time ("S
CrossPvpArena
flag (
sid (
uid (
name (	
time ("?
CrossPvpObInfo
stage (
round (
room_id ("
C2S_GetCrossPvpSchedule"N
S2C_GetCrossPvpSchedule
ret (&
schedule (2.cs.CrossPvpSchedule"
C2S_GetCrossPvpBaseInfo"�
S2C_GetCrossPvpBaseInfo
ret (
	has_apply (
stage (
state (
round (
time (
current_attack_buff	 (
current_defend_buff
 ("
C2S_GetCrossPvpScheduleInfo"J
S2C_GetCrossPvpScheduleInfo
ret (
info (2.cs.CrossPvpInfo""
C2S_ApplyCrossPvp
stage ("<
S2C_ApplyCrossPvp
ret (
stage (
num ("
C2S_GetAtcAndDefCrossPvp"a
S2C_GetAtcAndDefCrossPvp
ret (
current_attack_buff (
current_defend_buff ("?
C2S_ApplyAtcAndDefCrossPvp

apply_type (
count ("]
S2C_ApplyAtcAndDefCrossPvp
ret (

apply_type (
count (
current ("
C2S_GetCrossPvpRole"]
S2C_GetCrossPvpRole
ret (
round (
stage (
room (
score ("
C2S_CrossWaitInit"�
S2C_CrossWaitInit
ret (
stage (
rank (
score (
battle_count (
	win_count (
	has_award (#
flower_award (2.cs.CrossUser 
	egg_award	 (2.cs.CrossUser
	room_rank
 ("
C2S_CrossWaitInitFlowerInfo"�
S2C_CrossWaitInitFlowerInfo
ret (
ranks (2.cs.CrossUser

flower_get (
egg_get (&
flower_receiver (2.cs.CrossUser#
egg_receiver (2.cs.CrossUser"A
C2S_CrossWaitRank
stage (
start (
finish ("l
S2C_CrossWaitRank
ret (
stage (
start (
finish (
ranks (2.cs.CrossUser"_
C2S_CrossWaitFlower
sid (
role_id (
stage (
type (
count ("l
S2C_CrossWaitFlower
ret (
sid (
role_id (
stage (
type (
count ("F
C2S_CrossWaitFlowerRank
type (
start (
finish ("�
S2C_CrossWaitFlowerRank
ret (
type (
start (
finish (
ranks (2.cs.CrossUser
	self_rank ("(
C2S_CrossWaitFlowerAward
type ("P
S2C_CrossWaitFlowerAward
ret (
type (
awards (2	.cs.Award"3
C2S_GetCrossPvpArena
stage (
room ("2
S2C_GetCrossPvpArena
ret (
flags ("a
S2C_FlushCrossPvpArena
stage (
room (
arena (2.cs.CrossUser
type ("d
S2C_FlushCrossPvpSpecific
stage (
room (
type (
arena (2.cs.CrossUser"2
C2S_GetCrossPvpRank
stage (
room ("@
S2C_GetCrossPvpRank
ret (
ranks (2.cs.CrossUser"?
C2S_CrossPvpBattle
stage (
room (
flag ("�
S2C_CrossPvpBattle
ret (
method (
is_win (
score (
flag ( 
report (2.cs.BattleReport"7
S2C_FlushCrossPvpScore
score (
method ("
C2S_GetCrossPvpDetail"M
S2C_GetCrossPvpDetail
ret (
battle_count (
	win_count ("
C2S_CrossPvpGetAward">
S2C_CrossPvpGetAward
ret (
awards (2	.cs.Award" 
C2S_ItemCompose
index ("F
S2C_ItemCompose
ret (
index (
item (2	.cs.Award"
C2S_GetCrossPvpOb"S
S2C_GetCrossPvpOb
ret (
has_ob (!
rooms (2.cs.CrossPvpObInfo"b
SpecialHolidayActivityInfo

id (
progress (
award_count (
	can_award ("
C2S_GetSpecialHolidayActivity"�
S2C_GetSpecialHolidayActivity

in_holiday (

start_time (
end_time (-
infos (2.cs.SpecialHolidayActivityInfo"P
 S2C_UpdateSpecialHolidayActivity,
info (2.cs.SpecialHolidayActivityInfo"1
#C2S_GetSpecialHolidayActivityReward

id ("`
#S2C_GetSpecialHolidayActivityReward
ret (,
info (2.cs.SpecialHolidayActivityInfo"
C2S_GetSpecialHolidaySales";
S2C_GetSpecialHolidaySales

id (
	buyed_cnt ("4
C2S_BuySpecialHolidaySale

id (
cnt ("G
S2C_BuySpecialHolidaySale
ret (

id (
	buyed_cnt ("%
C2S_GetBulletScreenInfo

id ("p
S2C_GetBulletScreenInfo
ret (

id (
last_send_time (
	min_index (
	max_index ("U
C2S_SendBulletScreenInfo

id (
content (	
bs_type (
sp1 ("]
S2C_SendBulletScreenInfo
ret (
bs (2.cs.BulletScreen
last_send_time ("u
BulletScreen

id (
content (	
bs_type (
time (
sid (
user_id (
sp1 ("5
S2C_FlushBulletScreen
bs (2.cs.BulletScreen"
C2S_VipWeekShopInfo";
S2C_VipWeekShopInfo

id (
num (
ret ("-
C2S_VipWeekShopBuy

id (
num ("!
S2C_VipWeekShopBuy
ret ("'
ExDuShopItem

id (
num ("�
ExDuChapter

id (
star (
has_awarded (
has_entered (
stages (2.cs.ExDuStage
items (2.cs.ExDuShopItem"�
	ExDuStage

id (
target1 (
target2 (
target3 (
max_uid (
max_name (	
max_fv (
min_uid (
min_name	 (	
min_fv
 ("$
"C2S_GetExpansiveDungeonChapterList"T
"S2C_GetExpansiveDungeonChapterList
ret (!
chapters (2.cs.ExDuChapter"3
C2S_ExcuteExpansiveDungeonStage
stage_id ("�
S2C_ExcuteExpansiveDungeonStage
ret (

chapter_id (
stage (2.cs.ExDuStage 
report (2.cs.BattleReport
awards (2	.cs.Award
	stage_exp (":
$C2S_GetExpansiveDungeonChapterReward

chapter_id ("b
$S2C_GetExpansiveDungeonChapterReward
ret (

chapter_id (
awards (2	.cs.Award"3
%C2S_FirstEnterExpansiveDungeonChapter

id ("b
%S2C_FirstEnterExpansiveDungeonChapter
ret (

id ( 
chapter (2.cs.ExDuChapter"S
S2C_AddExpansiveDungeonNewStage

chapter_id (
stage (2.cs.ExDuStage"A
$C2S_PurchaseExpansiveDungeonShopItem

id (
count ("i
$S2C_PurchaseExpansiveDungeonShopItem
ret (

id (
count (
awards (2	.cs.Award"
C2S_TeamPVPStatus"�
S2C_TeamPVPStatus
ret (
status (
team_id (#
team_members (2.cs.CrossUser

leader_pos (
only_invited (
online_buff (
	corp_buff (
friend_buff	 (
kicked
 ("
C2S_TeamPVPCreateTeam"$
S2C_TeamPVPCreateTeam
ret ("
C2S_TeamPVPJoinTeam""
S2C_TeamPVPJoinTeam
ret ("
C2S_TeamPVPLeave"
S2C_TeamPVPLeave
ret ("7
C2S_TeamPVPChangePosition
pos1 (
pos2 ("(
S2C_TeamPVPChangePosition
ret ("G
C2S_TeamPVPKickTeamMember

kicked_sid (
kicked_user_id ("(
S2C_TeamPVPKickTeamMember
ret ("5
C2S_TeamPVPSetTeamOnlyInvited
only_invited (",
S2C_TeamPVPSetTeamOnlyInvited
ret ("=
C2S_TeamPVPInvite
invited_user_id (
team_id (" 
S2C_TeamPVPInvite
ret ("H
S2C_TeamPVPBeInvited
invitor_user_id (
invitor_team_id ("N
C2S_TeamPVPInvitedJoinTeam
invitor_user_id (
invitor_team_id (")
S2C_TeamPVPInvitedJoinTeam
ret ("E
S2C_TeamPVPInviteCanceled
team_id (
invitor_user_id ("
C2S_TeamPVPInviteNPC"#
S2C_TeamPVPInviteNPC
ret ("'
C2S_TeamPVPAgreeBattle
agree ("%
S2C_TeamPVPAgreeBattle
ret ("
C2S_TeamPVPMatchOtherTeam"(
S2C_TeamPVPMatchOtherTeam
ret ("
C2S_TeamPVPStopMatch"#
S2C_TeamPVPStopMatch
ret ("�
TeamPVPSingleBattleReport
	team1_pos (
	team2_pos (
team1_fight_first (%
report (2.cs.BattleBriefReport
continue_win3 (
continue_win ("�
TeamPVPBattleReport
	battle_id (
team1_id (
team1_leader_pos ($
team1_members (2.cs.CrossUser
team2_id (
team2_leader_pos ($
team2_members (2.cs.CrossUser
	team1_win (.
reports	 (2.cs.TeamPVPSingleBattleReport
team1_award_buff
 (
team2_award_buff ("v
S2C_TeamPVPBattleResult'
report (2.cs.TeamPVPBattleReport
score (
honor (
double_award ("
C2S_TeamPVPBattleTeamChange"*
S2C_TeamPVPBattleTeamChange
ret ("
S2C_TeamPVPCrossServerLost" 
C2S_TeamPVPHistoryBattleReport"I
S2C_TeamPVPHistoryBattleReport'
report (2.cs.TeamPVPBattleReport"#
!S2C_TeamPVPHistoryBattleReportEnd"
C2S_TeamPVPGetRank"M
S2C_TeamPVPGetRank
ret (
user (2.cs.CrossUser
honor ("
C2S_TeamPVPGetUserInfo"�
S2C_TeamPVPGetUserInfo
ret (
honor (
score (
	award_cnt (
buyed_award_cnt (
npc_cd (
rank (
title (
accept_invite	 (
pop_chat
 ("
C2S_TeamPVPBuyAwardCnt"%
S2C_TeamPVPBuyAwardCnt
ret (")
C2S_TeamPVPAcceptInvite
accept ("&
S2C_TeamPVPAcceptInvite
ret ("
C2S_GetAccountBindingInfo"8
S2C_GetAccountBindingInfo
ret (
awards ("(
C2S_GetAccountBindingAward

id ("5
S2C_GetAccountBindingAward
ret (

id ("&
C2S_TeamPVPPopChat
pop_chat ("!
S2C_TeamPVPPopChat
ret ("
C2S_GetShopTag"*
S2C_GetShopTag
ret (
ids ("
C2S_AddShopTag

id ("*
S2C_AddShopTag
ret (
ids ("
C2S_DelShopTag

id ("*
S2C_DelShopTag
ret (
ids ("F
C2S_FastRefineEquipment
eid (
consume_item (2.cs.Item"3
S2C_FastRefineEquipment
ret (
eid ("
C2S_GetOlderPlayerInfo"�
S2C_GetOlderPlayerInfo
ret (
is_older (
activity_id (
activity_start (
activity_end (

limit_time (
vip (
awards (
limit_level	 ("
C2S_GetOlderPlayerVipAward")
S2C_GetOlderPlayerVipAward
ret ("*
C2S_GetOlderPlayerLevelAward

id ("7
S2C_GetOlderPlayerLevelAward
ret (

id ("
C2S_GetOlderPlayerVipExp"4
S2C_GetOlderPlayerVipExp
ret (
exp (""
C2S_ChangeName
new_name (	"/
S2C_ChangeName
ret (
new_name (	"
C2S_RCardInfo"�
S2C_RCardInfo
score (
score_total (
start (
end (
reset1 (
ids1 (
reset2 (
ids2 (
pos1	 (
pos2
 (
play1 (
play2 ("(
C2S_PlayRCard

id (
pos ("B
S2C_PlayRCard
ret (

id (
cid (
pos ("
C2S_ResetRCard

id (")
S2C_ResetRCard
ret (

id ("$
C2S_SetClothSwitch
isOpen ("$
S2C_SetClothSwitch
isOpen ("
C2S_GetDays7CompInfo"E
Days7CompInfo

id (
name (	
rank (
flag ("r
S2C_GetDays7CompInfo
ret (
me (2.cs.Days7CompInfo 
infos (2.cs.Days7CompInfo
oszt ("
C2S_GetDays7CompAward"?
S2C_GetDays7CompAward
ret (
awards (2	.cs.Award" 
Ksoul

id (
num ("
C2S_GetKsoul"�
S2C_GetKsoul
ksouls (2	.cs.Ksoul
ksoul_groups (
ksoul_targets (
free_summon (
summon_count ("
summon_exchange (2	.cs.Ksoul
dungeon_challenge_cnt (
dungeon_refresh_cnt	 (",
C2S_RecycleKsoul
ksoul (2	.cs.Ksoul"4
S2C_RecycleKsoul
ret (
ksoul_point ("d
OpKsoul 
insert_ksouls (2	.cs.Ksoul 
update_ksouls (2	.cs.Ksoul
delete_ksouls (""
C2S_ActiveKsoulGroup

id ("/
S2C_ActiveKsoulGroup
ret (

id ("#
C2S_ActiveKsoulTarget

id ("0
S2C_ActiveKsoulTarget
ret (

id ("!
C2S_SummonKsoul
s_type ("�
S2C_SummonKsoul
ret (
s_type (
awards (2	.cs.Award
scores (2	.cs.Award
free_summon (
summon_score (
summon_count ("%
C2S_SummonKsoulExchange

id ("�
S2C_SummonKsoulExchange
ret (

id ("
summon_exchange (2	.cs.Ksoul
summon_score (
award (2	.cs.Award"1
C2S_GetCommonRank
r_id (
r_type ("n
S2C_GetCommonRank
ret (
r_id (
r_type (
rank (2.cs.CrossUser
	self_rank ("
C2S_KsoulShopInfo"\
S2C_KsoulShopInfo

id (
num (
refresh_cnt (
next_refresh_time ("
C2S_KsoulShopBuy

id (":
S2C_KsoulShopBuy
ret (

id (
index ("
C2S_KsoulShopRefresh"#
S2C_KsoulShopRefresh
ret ("
C2S_KsoulDungeonInfo"N
S2C_KsoulDungeonInfo

id (
refresh_cnt (
challenge_cnt ("
C2S_KsoulDungeonRefresh"&
S2C_KsoulDungeonRefresh
ret ("
C2S_KsoulDungeonChallenge"e
S2C_KsoulDungeonChallenge
ret ( 
report (2.cs.BattleReport
awards (2	.cs.Award"
C2S_ShareFriendAwardInfo";
ShareFriendAwardInfo

id (
last_award_time ("P
S2C_ShareFriendAwardInfo
ret ('
datas (2.cs.ShareFriendAwardInfo"%
C2S_ShareFriendGetAward

id ("O
S2C_ShareFriendGetAward
ret ('
datas (2.cs.ShareFriendAwardInfo"#
C2S_KsoulSetFightBase

id ("0
S2C_KsoulSetFightBase
ret (

id ("Q
FortuneBuySilverInfo
time (
silver (
multi (
gold ("
C2S_FortuneInfo"X
S2C_FortuneInfo
times (
boxids (&
buys (2.cs.FortuneBuySilverInfo"
C2S_FortuneBuySilver"J
S2C_FortuneBuySilver
ret (%
buy (2.cs.FortuneBuySilverInfo"
C2S_FortuneGetBox

id ("H
S2C_FortuneGetBox
ret (
bid (
awards (2	.cs.Award*�}
RET
	RET_ERROR 

RET_OK
RET_SERVER_MAINTAIN
RET_USER_NOT_EXIST
RET_LOGIN_REPEAT
RET_USER_NAME_REPEAT
RET_CHAT_OUT_OF_LENGTH
RET_CHAT_CHAN_INEXISTENCE
RET_ITEM_BAG_FULL
RET_FRIEND_FULL_1	
RET_FRIEND_FULL_2

RET_STAGEDUNGEON_OVERLIMIT
RET_NOT_ENOUGH_VIT
RET_STAGEBOX_REWARDED
RET_FASTEXECUTE_LOCK&
"RET_CHAPTERACHVRWD_ALREAD_FINISHED
RET_NOT_ENOUGH_STAR
RET_CHAPTERBOX_REWARDED"
RET_NOT_ENOUGH_CHAPTERBOX_STAR
RET_NOT_ENOUGH_GOLD
RET_NOT_ENOUGH_MONEY
RET_KNIGHT_BAG_FULL
RET_EQUIP_BAG_FULL
RET_DUNGEON_NOT_FINISHED
RET_IS_NOT_UP_TO_LEVEL
RET_NOT_ENOUGH_SPIRIT
RET_VIP_SHOP_UP_LIMIT
RET_NOT_ENOUGH_PRESTIGE
RET_KNIGHT_NOT_EXIST
RET_CANNOT_UPGRADE_MAINROLE$
 RET_KNIGHT_LEVEL_EXCEED_MAINROLE"
RET_MAINROLE_CANNOT_BE_UPGRADE#
RET_BE_UPGRADE_KNIGHT_NOT_EXIST  
RET_BE_UPGRADE_KNIGHT_REPEAT!'
#RET_ONTEAM_KNIGHT_CANNOT_BE_UPGRADE"*
&RET_KNIGHT_ADVANCED_LEVEL_EXCEED_LIMIT#&
"RET_KNIGHT_ADVANCED_NOT_ENOUGH_NUM$ 
RET_ADVANCED_COST_KNIGHT_ERR%(
$RET_ONTEAM_KNIGHT_CANNOT_BE_ADVANCED&
RET_ITEM_NUM_NOT_ENOUGH'
RET_FRONT_SKILL_NOTLEARNED(
RET_SKILL_REACH_MAXLEVEL)
RET_NOT_ENOUGH_SKILLPOINT*
RET_SKILL_NOT_FOUND+
RET_NOT_ENOUGH_PEER_SKILL,
RET_ILLEAGAL_SKILL_SLOT-*
&RET_KNIGHT_TRAINING_VALUE_EXCEED_LIMIT.
RET_ILLEGAL_RESET_SLOT/
RET_STORYDUNGEON_OVERLIMIT0 
RET_SGZAWARD_ALREAD_FINISHED1
RET_EQIUP_NOT_EXIST2 
RET_EQUIP_LEVEL_EXCEED_LIMIT3)
%RET_EQUIP_REFINING_LEVEL_EXCEED_LIMIT4
RET_ITEM_TYPE_ERROR5&
"RET_KNIGHT_HALO_LEVEL_EXCEED_LIMIT6+
'RET_KNIGHT_HALO_ADVANCE_LEVEL_NOT_REACH7
RET_MYSTICAL_SHOP_UP_LIMIT8
RET_NOT_ENOUGH_ESSENCE9
RET_REBEL_NOT_VAILD:
RET_NOT_ENOUGH_BATTLE_TOKEN;#
RET_NO_FIND_REBEL_EXPLOIT_AWARD<
RET_TREASURE_BAG_FULL=!
RET_KNIGHT_CANNOT_BE_ADVANCED>
RET_TREASURE_NOT_EXIST?"
RET_BE_UPGRADE_TREASURE_REPEAT@(
$RET_TREASURE_REFINING_NOT_ENOUGH_NUMA$
 RET_TREASURE_FRAGMENT_NOT_ENOUGHB
RET_REBEL_NOT_PUBLICC
RET_REBEL_NOT_FRIENDD!
RET_TREASURE_IN_FIGHT_POSTIONE 
RET_TREASURE_CANNOT_STRENGTHF
RET_NOT_ENOUGH_MEDALG
RET_NOT_ENOUGH_TOWERSCOREH
RET_ARENA_RANK_LOCKI
RET_EQUIP_NOT_EXISTJ 
RET_NOT_SKILL_NOTENOUGH_ITEMK
RET_ILLEGAL_SKILL_LEVELL
RET_USER_DATA_LOCKM 
RET_TREASURE_FRAGMENT_ROBBEDN
RET_USER_OFFLINEO
RET_NOT_FRIENDP
RET_SCORE_SHOP_UP_LIMITQ!
RET_SCORE_SHOP_NO_ARENA_LIMITR!
RET_SCORE_SHOP_NO_TOWER_LIMITS
RET_VIP_DUNGEON_NOT_OPENT
RET_VIP_DUNGEON_MAX_COUNTU
RET_VIP_LEVEL_NOT_ENOUGHV
RET_CHAT_HIGH_FREQUENCYW
RET_HUODONG_OVERX
RET_MONTHCARD_ALREADY_USEDY
RET_WORSHIP_CDZ#
RET_DAILYMISSION_PROGRESS_ERROR[#
RET_DAILIYMISSION_ALREAD_FINISH\'
#RET_DAILIYMISSION_BOX_ALREAD_FINISH]*
&RET_DAILIYMISSION_BOX_NOT_ENOUGH_POINT^
RET_RESET_COUNT_MAX_
RET_CHAT_FORBID`
RET_LOGIN_BAN_USERa
RET_KNIGHT_LEVEL_NOT_REACHb
RET_LOGIN_TOKEN_TIME_OUTc
RET_LOGIN_BAN_USER2d"
RET_USER_IN_FORBID_BATTLE_TIMEe
RET_ARENA_RANK_NOT_REACH_20f
RET_GIFT_CODE_ERRg
RET_VERSION_ERRh
RET_HOF_SIGN_LENGTH_ERRORi
RET_HOF_SIGN_GOLD_ERRORj
RET_SERVER_NOT_OPENk
RET_FUND_BUY_TIME_EXPIREl
RET_FUND_BUY_REPEATEm
RET_USER_NOT_BUY_FUNDn
RET_FUND_WEAL_TIME_EXPIREo
RET_FUND_HAS_AWARDp
RET_FUND_HAS_WEALq
RET_FUND_CANNOT_WEALr!
RET_ACTIVITY_STATUS_NO_PERMITs 
RET_ACTIVITY_DEC_NOT_ENOUGHTt$
 RET_ACTIVITY_SELL_ALREADY_BOUGHTu
RET_ACTIVITY_SELL_MAXv
RET_ACTIVITY_CLOSEDw
RET_RIOT_ASSISTEDx
RET_GC_TIME_OUTy
RET_GC_NOT_ENOUGH_PARAMz
RET_GC_PARAM_ERR{
RET_GC_ACT_CODE_NOT_USE|
RET_GC_CODE_NOT_USE}
RET_GC_CODE_NOT_EXIST~
RET_GC_ACT_TIMEOUT
RET_GC_CODE_USE_MORE_TIME�
RET_GC_ACT_CODE_ERR�
RET_GC_USER_ERR�
RET_GC_VERIFY_CODE_ERR�
RET_CORP_NOT_EXIST�
RET_CORP_NAME_ILLEGAL�
RET_CORP_NAME_REPEAT�
RET_JOIN_CORP_EXIST�
RET_JOIN_CORP_MAX�
RET_QUIT_CORP_INCD�
RET_CORP_MEMBER_FULL�
RET_CORP_AUTH_NO_PERMIT�%
 RET_USER_HAS_JOINED_ANOTHER_CORP�#
RET_CORP_FRAME_DEMAND_NOT_MEET�
RET_CORP_VLEADER_FULL�
RET_DISMISS_MEMBER_ILLEGAL�"
RET_CORP_WORSHIP_ALREADY_DONE�
RET_CORP_WORSHIP_AWARD_GOT�#
RET_CORP_WORSHIP_POINT_ILLEGAL�
RET_NOT_ENOUGH_CORP_POINT�$
RET_CA_AWARD_TIMES_EXCEED_LIMIT�+
&RET_CA_AWARD_TIMES_EXCEED_SERVER_LIMIT� 
RET_CA_QUEST_ISNOT_COMPLETE�
RET_CA_AWARD_ID_ERROR�
RET_KNIGHT_NUM_NOT_ENOUGH�
RET_EQUIP_NUM_NOT_ENOUGH� 
RET_TREASURE_NUM_NOT_ENOUGH�
RET_CA_AWARD_TIMENOT_REACH�"
RET_CORP_NOT_IN_EXCHANGE_TIME� 
RET_CORP_LEADER_CANNOT_QUIT�"
RET_CORP_SHOP_REQUEST_OVERDUE�
RET_USER_HAS_NO_CORP�
RET_USER_HAS_CORP�!
RET_DRESS_LEVEL_EXCEED_LIMIT�
RET_DRESS_NOT_EXIST�
RET_CORP_SHOP_HAS_BOUGHT�!
RET_CORP_SET_CHAPTER_ILLEGAL�!
RET_CORP_CHAPTER_EXECUTE_MAX�'
"RET_CORP_CHAPTER_INFORMATION_ERROR�
RET_CORP_CHAPTER_FINISHED�(
#RET_CORP_CHAPTER_DUNGEON_NOT_FINISH�&
!RET_CORP_CHAPTER_DUNGEON_NO_AWARD�#
RET_CORP_CHAPTER_AWARD_HAS_GOT�)
$RET_HOLIDAY_AWARD_TIMES_EXCEED_LIMIT�"
RET_HOLIDAY_EVENT_IS_NOT_OPEN�
RET_ITEM_IS_EXPIRE�,
'RET_CORP_CHAPTER_AWARD_BELONG_TO_OTHERS�"
RET_CORP_ANNOUNCEMENT_ILLEGAL�"
RET_CORP_NOTIFICATION_ILLEGAL�
RET_GIFT_CODE_OP_TOO_FAST�
RET_JOIN_CORP_INCD�)
$RET_JOIN_CORP_USER_REQUEST_NOT_EXIST�
RET_CORP_WORSHIP_MAX_COUNT�!
RET_SERVER_USER_OVER_CEILING�
RET_CORP_SHOP_NO_LEFT�
RET_DISMISS_CORP_INCD� 
RET_VIP_DUNGEON_RESET_ERROR�
RET_RECHARGE_BACK_ENDED�&
!RET_RECHARGE_BACK_REQUEST_ILLEGAL�&
!RET_RECHARGE_BACK_FAILED_FINISHED�
RET_RECHARGE_BACK_FAILED�
RET_AWAKEN_ITEM_BAG_FULL�
RET_NOT_ENOUGH_WHEEL�
RET_NOT_ENOUGH_WHEEL_TOTAL�
RET_AWAKEN_ITEM_NOT_ENOUGH�
RET_KNIGHT_CANNOT_AWAKEN�%
 RET_KNIGHT_AWAKEN_ITEM_POS_ERROR�
RET_AWAKEN_ITEM_NOT_EXIST�)
$RET_KNIGHT_AWAKEN_LEVEL_EXCEED_LIMIT�(
#RET_KNIGHT_AWAKEN_ITEM_NOT_COMPLETE�!
RET_AWAKEN_KNIGHT_NOT_ENOUGH�
RET_AWAKEN_COST_KNIGHT_ERR�'
"RET_ONTEAM_KNIGHT_CANNOT_BE_AWAKEN�
RET_NOT_ENOUGH_SOUL�
RET_CORP_REQUEST_MAX�
RET_CORP_DUNGEON_RESET_MAX�
RET_TITLE_IN_USE�
RET_TITLE_IS_EXPIRED�!
RET_NOT_ENOUGH_CONTEST_POINT�#
RET_NOT_ENOUGH_CORPPOINT_TOTAL�%
 RET_NOT_ENOUGH_CONTESTWINS_TOTAL�
RET_TIME_DUNGEON_NOT_OPEN�"
RET_TIME_DUNGEON_IS_COMPLETED�
RET_GAME_TIME_ERROR1�
RET_GAME_TIME_ERROR2�
RET_PAY_PRICE_TYPE_NIL�
RET_GAME_TIME_ERROR0�
RET_USER_CHAT_NOT_EXIST�
RET_MAIL_LONG� 
RET_HARD_CHAPTER_ROIT_ERROR�
RET_BATTLE_TOO_FREQUENT�
RET_USER_RECOVER�
RET_CREATE_LIMIT�
RET_CLIENT_REQUEST_ERROR�
RET_REBEL_BOSS_NOT_OPEN�#
RET_CHALLENGE_COUNT_NOT_ENOUGH�$
RET_REBEL_BOSS_NOT_REPEAT_AWARD�
RET_REBEL_BOSS_DIE�
RET_LOGIN_BLACKCARD_USER�
RET_REBEL_BOSS_GROUP_EXIST�
RET_SPREAD_USER_LVL_LIMIT�
RET_SPREAD_MAX_COUNT�
RET_SPREAD_DRAW_ERROR�
RET_SPREAD_NOT_ENOUGH�
RET_RICE_ROB_TIME_END�
RET_RICE_ROB_NOT_OPEN�
RET_USER_NOT_JOIN_RICE_ROB� 
RET_RICE_RIVALS_FLUSH_IN_CD�"
RET_RICE_ROB_TOKEN_NOT_ENOUGH�
RET_RICE_ROB_IN_CD� 
RET_USER_NOT_IN_RICE_RIVALS�&
!RET_RICE_REVENGE_TOKEN_NOT_ENOUGH�
RET_RICE_ENEMY_NOT_EXIST�#
RET_RICE_ENEMY_CANNOT_REVENGED�"
RET_RICE_ACHIEVEMENT_ID_ERROR�"
RET_RICE_ACHIEVEMEN_NOT_REACH�$
RET_RICE_ENEMY_NOT_NEED_REVENGE�"
RET_SHOPTIME_GOODS_NOT_ENOUGH�$
RET_SHOPTIME_ACTIVITY_NOT_START�
RET_OUTLET_SHOP_UP_LIMIT�%
 RET_OUTLET_SHOP_REWARD_HAS_AWARD�+
&RET_OUTLET_SHOP_REWARD_CAN_NOT_WELFARE�!
RET_NOT_RICE_RANK_AWARD_TIME�%
 RET_RICE_RANK_AWARD_HAS_RECEIVED�
RET_RICE_RANK_NOT_AWARD�$
RET_RICE_TOKEN_EXCEED_BUY_LIMIT�#
RET_RICE_TOKEN_BUY_PRICE_ERROR�)
$RET_OUTLET_SHOP_RECHARGE_NOT_FIND_ID�$
RET_OUTLET_SHOP_GET_GOODS_ERROR�
RET_SPREAD_INVALID_INPUT�
RET_REGISTER_SPREAD_ERROR�
RET_REGISTERING_SPREAD�
RET_REGISTERING_ERROR�(
#RET_REBEL_BOSS_REFRESH_TOO_FREQUENT�'
"RET_REBEL_BOSS_BATTLE_TOO_FREQUENT�$
RET_REBEL_BOSS_REWARD_NO_PERMIT�%
 RET_REGISTER_CONNECT_CROSS_ERROR�*
%RET_REBEL_BOSS_CORP_REWARD_NOT_PERMIT�'
"RET_RICE_RANK_ACHIEVEMENT_RECEIVED�$
RET_CORP_CHAPTER_AWARD_FINISHED�&
!RET_CORP_CHAPTER_DUNGEON_NOT_OPEN�&
!RET_MONTH_FUND_ACTIVITY_CFG_ERROR�&
!RET_MONTH_FUND_ACTIVITY_NOT_START�&
!RET_MONTH_FUND_NOT_FIND_USER_DATA�%
 RET_MONTH_FUND_NOT_IN_AWARD_TIME�&
!RET_MONTH_FUND_AWARD_HAS_ACQUIRED�'
"RET_MONTH_FUND_HAVE_NOT_BUY_BEFORE�(
#RET_CUSTOM_ACTIVITY_LEVEL_NOT_MATCH�&
!RET_CUSTOM_ACTIVITY_VIP_NOT_MATCH�
RET_MAIL_STRANGER_LEVEL�
RET_MAIL_STRANGER_COUNT�
RET_ROOKIE_INACTIVE�
RET_THEME_DROP_ZY_CHANGE�
RET_THEME_DROP_TIMES_LACK� 
RET_THEME_DROP_KNIGHT_ERROR�
RET_THEME_DROP_SV_LACK�'
"RET_GROUP_BUY_PURCHASE_COUNT_LIMIT�*
%RET_GROUP_BUY_GET_TASK_AWARD_ID_ERROR�7
2RET_GROUP_BUY_GET_TASK_AWARD_SELF_SCORE_NOT_ENOUGH�6
1RET_GROUP_BUY_GET_TASK_AWARD_MAX_SCORE_NOT_ENOUGH�(
#RET_GROUP_BUY_TASK_AWARD_GET_BEFORE�-
(RET_GROUP_BUY_TASK_AWARD_BACK_GOLD_ERROR�'
"RET_GROUP_BUY_VIP_LEVLE_NOT_ENOUGH�#
RET_GROUP_BUY_LEVLE_NOT_ENOUGH�"
RET_GROUP_BUY_NOT_IN_BUY_TIME�"
RET_GROUP_BUY_USER_DATA_ERROR�'
"RET_GROUP_BUY_NOT_IN_ACTIVITY_TIME�$
RET_GROUP_BUY_NOT_IN_AWARD_TIME�%
 RET_GROUP_BUY_USER_DATA_NOT_LOAD�
RET_PICTURE_FRAME_ID_ERROR�
RET_PET_BAG_FULL�
RET_PET_NOT_EXIST�
RET_PET_IS_IN_FIGHT�"
RET_BATTLE_FIELD_GONEXT_ERROR�!
RET_BATTLE_FIELD_RESET_ERROR�
RET_BATTLE_FIELD_OUTOFDATE�!
RET_BATTLE_FIELD_AWARD_ERROR�%
 RET_BATTLE_FIELD_CHALLENGE_ERROR�
RET_BATTLE_FIELD_LOADING�#
RET_BATTLE_FIELD_SHOP_UP_LIMIT�%
 RET_CORP_DUNGEON_AWARD_OVER_DIFF�
RET_FIGHT_SCORE_NOT_ENOUGH�
RET_DELAY_RELOAD_ERROR�
RET_CORP_TECH_ID_NOT_OPEN�
RET_CORP_TECH_ID_NOT_EXIST�%
 RET_CORP_TECH_ID_REACH_MAX_LEVEL�1
,RET_CORP_TECH_ID_USER_LEVEL_REACH_CORP_LEVEL�&
!RET_CORP_TECH_CORP_EXP_NOT_ENOUGH�&
!RET_CORP_UP_LEVEL_REACH_MAX_LEVEL�%
 RET_CORP_UP_LEVEL_NOT_ENOUGH_EXP�#
RET_CROSS_PVP_RANK_LIMIT_ERROR�&
!RET_CROSS_PVP_INSPIRE_COUNT_LIMIT�
RET_CROSS_RANK_BUSY�
RET_GAME_TIME_ERROR3�&
!RET_CROSS_PVP_FLOWER_SELF_ILLEGAL� 
RET_CROSS_PVP_STAGE_ILLEGAL�&
!RET_CROSS_PVP_FLOWER_TYPE_ILLEGAL�
RET_CROSS_PVP_CONFIG_ERROR�#
RET_CROSS_PVP_SLAVE_DATA_ERROR�'
"RET_CROSS_PVP_INSPIRE_TYPE_ILLEGAL�"
RET_CROSS_PVP_GET_AWARD_ERROR�(
#RET_CROSS_PVP_FLOWER_COUNT_TOO_MUCH�*
%RET_SPECIAL_HOLIDAY_TASK_NOT_FINISHED�)
$RET_SPECIAL_HOLIDAY_TASK_NOT_IN_TIME�&
!RET_SPECIAL_HOLIDAY_TASK_FINISHED�'
"RET_SPECIAL_HOLIDAY_SALE_REACH_MAX�.
)RET_SPECIAL_HOLIDAY_SALE_PRICE_NOT_ENOUGH�)
$RET_SPECIAL_HOLIDAY_SALE_NOT_IN_TIME�
RET_BULLET_SCREEN_IN_CD�&
!RET_BULLET_SCREEN_CONTENT_ILLEGAL�
RET_BULLET_SCREEN_BUSY�)
$RET_EXPANSIVE_DUNGEON_STAGE_NOT_OPEN�+
&RET_EXPANSIVE_DUNGEON_CHAPTER_NOT_OPEN�
RET_HAVE_GET_MAX_STAR�
RET_HAS_GET_CHAPTER_AWARD�$
RET_BATTLE_ON_SLOT_KNIGHT_ERROR�/
*RET_EXPANSIVE_DUNGEON_SHOP_BUY_COUNT_ERROR�.
)RET_EXPANSIVE_DUNGEON_SHOP_ITEM_NOT_EXIST�2
-RET_EXPANSIVE_DUNGEON_SHOP_CHAPTER_NOT_FINISH�%
 RET_FRAGMENT_COMPOUND_NOT_ENOUGH�
RET_OLDER_PLAYER_VIP_AWARD�
RET_NOT_OLDER_PLAYER�!
RET_OLDER_PLAYER_LEVEL_AWARD�
RET_GET_OLDER_PLAYER_INFO�$
RET_EXPANSIVE_DUNGEON_NOT_START�!
RET_ACCOUNT_BINDING_REWARDED�
RET_CONNECT_CROSS_ERROR�
RET_NOT_ENOUGH_KSOUL�
RET_NOT_ENOUGH_KSOUL_POINT�
RET_ACTIVE_DEMAND_NOT_MEET�
RET_HAS_ALREAD_ACTIVE�
RET_KSOUL_SHOP_ITEM_BUYED�"
RET_KSOUL_SHOP_ITEM_NOT_EXIST�
RET_KSOUL_SUMMON_ERROR�&
!RET_KSOUL_SUMMON_POINT_NOT_ENOUGH�"
RET_KSOUL_SUMMON_EXCHANGE_MAX�
RET_CITY_ALL_NO_OPEN�
RET_CITY_PATROL_CONFIG�
RET_CITY_TECH_CONFIG�#
RET_CITY_TECHUP_TIME_NO_ATTACH�&
!RET_CITY_TECHUP_CONSUME_NO_ATTACH�*
%RET_KNIGHT_GOD_NO_ATTACH_POTENTIALITY�
RET_KNIGHT_GOD_CONFIG�%
 RET_KNIGHT_GOD_CONSUME_NO_ENOUGH�-
(RET_KNIGHT_TRANSFORM_NO_SAME_GROUP_LEVEL�)
$RET_DAYS_SEVEN_COMP_NO_IN_AWARD_TIME�&
!RET_NOT_ENOUGH_KSOUL_SUMMON_SCORE�&
!RET_DAYS_SEVEN_COMP_RANK_IS_EMPTY�#
RET_DAYS_SEVEN_COMP_NO_ON_RANK�"
RET_DAYS_SEVEN_COMP_CONF_EROR�"
RET_DAYS_SEVEN_COMP_HAD_AWARD�%
 RET_DAYS_SEVEN_COMP_SWITCH_CLOSE�(
#RET_SHARE_FRIEND_AWARD_NO_LOAD_CONF�(
#RET_SHARE_FRIEND_AWARD_NO_LOAD_DATA�&
!RET_SHARE_FRIEND_AWARD_CONF_ERROR�&
!RET_SHARE_FRIEND_AWARD_HAVE_AWARD� 
RET_FORTUNE_TODAY_TIMES_MAX�$
RET_FORTUNE_BOX_TIMES_NO_ENOUGH� 
RET_FORTUNE_BOX_ID_NO_EXIST�!
RET_FORTUNE_BOX_ID_HAD_AWARD�%
 RET_FORTUNE_BOX_AWARD_CONF_ERROR�"
RET_CORP_CROSS_PK_STATE_ERROR� 
RET_CORP_CROSS_PK_HAS_APPLY�$
RET_CORP_CROSS_PK_HAS_NOT_APPLY�&
!RET_CORP_CROSS_PK_DEMAND_NOT_MEET�)
$RET_CORP_CROSS_PK_ENCOURAGE_OVER_MAX�/
*RET_CORP_CROSS_PK_ENCOURAGE_OVER_MEMBERMAX�$
RET_CORP_CROSS_PK_IN_REFRESH_CD�
RET_CORP_CROSS_PK_IN_PK_CD�#
RET_CORP_CROSS_PK_NOT_IN_PK_CD�%
 RET_CORP_CROSS_PK_FIELD_NOT_EXIT�
RET_CORP_QUERY_ERROR�$
RET_CORP_CROSS_PK_CORP_NOT_EXIT�0
+RET_CORP_CROSS_PK_CORP_MEMBER_MAX_CHALLENGE�,
'RET_CORP_CROSS_PK_CORP_SET_FIREON_ERROR�&
!RET_CORP_CROSS_PK_CORP_STATE_LOCK�#
RET_CORP_CROSS_PK_SERVER_ERROR� 
RET_CORP_CROSS_PK_RESET_MAX�#
RET_USER_CROSS_PK_SERVER_ERROR�"
RET_USER_CROSS_PK_STATE_ERROR�"
RET_USER_CROSS_PK_GROUP_ERROR�$
RET_USER_CROSS_PK_REFRESH_ERROR�&
!RET_USER_CROSS_PK_FREQUENCE_ERROR�#
RET_USER_CROSS_PK_BATTLE_ERROR�&
!RET_USER_CROSS_PK_USER_CHALLENGED�(
#RET_USER_CROSS_PK_USER_NO_CHALLENGE�&
!RET_USER_CROSS_PK_GET_ENEMY_ERROR�*
%RET_USER_CROSS_PK_ARENA_NO_INVITATION�&
!RET_USER_CROSS_PK_ARENA_BET_ERROR�-
(RET_USER_CROSS_PK_ARENA_HAS_SERVER_AWARD�/
*RET_USER_CROSS_PK_ARENA_AWARD_NOT_PREPARED�*
%RET_USER_CROSS_PK_ARENA_AWARD_ILLEGAL�%
 RET_USER_CROSS_PK_ARENA_NOT_OPEN�%
 RET_USER_CROSS_PK_ARENA_BET_INIT�'
"RET_USER_CROSS_PK_ARENA_BET_FINISH�,
'RET_USER_CROSS_PK_ARENA_CHALLENGE_ERROR�+
&RET_USER_CROSS_PK_ARENA_CHALLENGE_LOCK�$
RET_USER_CROSS_PK_ARENA_BET_MAX�-
(RET_USER_CROSS_PK_ARENA_BET_AWARD_FINISH�+
&RET_USER_CROSS_PK_GET_USER_INFO_FAILED�(
#RET_USER_CROSS_GB_NOT_IN_AWARD_TIME�(
#RET_USER_CROSS_GB_NOT_IN_AWARD_RANK�,
'RET_USER_CROSS_GB_GET_RANK_AWARD_BEFORE�$
RET_TEAM_PVP_CROSS_SERVER_ERROR�
RET_TEAM_PVP_HAS_TEAM�
RET_TEAM_PVP_JOINING_TEAM�
RET_TEAM_PVP_NOT_IN_TEAM�!
RET_TEAM_PVP_NOT_TEAM_LEADER�%
 RET_TEAM_PVP_KICK_NO_TEAM_MEMBER�#
RET_TEAM_PVP_CAN_NOT_KICK_SELF�*
%RET_TEAM_PVP_INVITE_TARGET_NOT_ONLINE�*
%RET_TEAM_PVP_INVITE_TARGET_NOT_FRIEND�#
RET_TEAM_PVP_INVITOR_QUIT_TEAM�'
"RET_TEAM_PVP_INVITE_TICKET_INVALID�
RET_TEAM_PVP_TEAM_FULL�&
!RET_TEAM_PVP_ALREADY_INVITING_NPC�
RET_TEAM_PVP_TEAM_NOT_FULL�"
RET_TEAM_PVP_TEAM_IS_MATCHING�'
"RET_TEAM_PVP_TEAM_MEMBERS_DISAGREE�)
$RET_TEAM_PVP_CHANGE_POSITION_INVALID�&
!RET_TEAM_PVP_TEAM_IS_NOT_MATCHING�'
"RET_TEAM_PVP_USER_LEVEL_NOT_ENOUGH�
RET_TEAM_PVP_NPC_SEARCH_CD�"
RET_TEAM_PVP_NOT_ENOUGH_SCORE�"
RET_TEAM_PVP_NOT_ENOUGH_HONOR�
RET_CROSS_PVP_APPLY_FULL�
RET_CROSS_PVP_ROLE_EXIST�"
RET_CROSS_PVP_NO_EXIST_ACT_ID�
RET_CROSS_PVP_NO_FIND_ROOM�
RET_SERVER_BUSY�#
RET_CROSS_PVP_NO_FIND_RESOURCE�
RET_CROSS_PVP_NO_EXIST_ID�
RET_PVP_LOCK�
RET_PVP_COLDDOWN�

RET_PVPING�
RET_PVP_OCCUPY�
RET_PVP_M2M�
RET_CROSS_PVP_STATE_ERROR�
RET_CROSS_PVP_LEVEL_ERROR�
RET_CROSS_PVP_TYPE_ERROR�
RET_CROSS_PVP_BUFF_MAX�"
RET_CROSS_PVP_BUFF_TYPE_ERROR�
RET_FLOWER_EGG_TYPE_ERROR�
RET_CROSS_PVP_NO_BET�
RET_FLOWER_EGG_ONLY_ONE�
RET_FLOWEREGG_AWARDED�
RET_FLOWEREGG_NOT_MEET�!
RET_CROSS_PVP_RANK_GOT_AWARD�
RET_CROSS_PVP_NOT_OB�*��
ID
ID_C2S_KeepAlive�N
ID_S2C_KeepAlive�N
ID_C2S_Login�N
ID_S2C_Login�N
ID_C2S_Create�N
ID_S2C_Create�N
ID_C2S_Offline�N
ID_C2S_GetServerTime�N
ID_S2C_GetServerTime�N
ID_C2S_Flush�N
ID_S2C_Flush�N
ID_S2C_GetUser�N
ID_S2C_GetKnight�N
ID_C2S_TestBattle�N
ID_S2C_TestBattle�N
ID_S2C_FightKnight�N
ID_C2S_ChangeFormation�N
ID_S2C_ChangeFormation�N
ID_C2S_ChangeTeamKnight�N
ID_S2C_ChangeTeamKnight�N
ID_C2S_AddTeamKnight�N
ID_S2C_AddTeamKnight�N
ID_S2C_GetItem�N
ID_S2C_GetFragment�N
ID_C2S_Shopping�N
ID_S2C_Shopping�N
ID_C2S_UseItem�N
ID_S2C_UseItem�N
ID_S2C_GetEquipment�N
ID_C2S_EnterShop�N
ID_S2C_EnterShop�N
ID_S2C_OpObject�N
ID_C2S_Sell�N
ID_S2C_Sell�N
ID_C2S_FragmentCompound�N
ID_S2C_FragmentCompound�N
ID_C2S_MysticalShopInfo�N
ID_S2C_MysticalShopInfo�N
ID_C2S_MysticalShopRefresh�N
ID_S2C_MysticalShopRefresh�N
ID_S2C_GetTreasureFragment�N
ID_S2C_GetTreasure�N
ID_S2C_FightResource�N
ID_C2S_AddFightEquipment�N
ID_S2C_AddFightEquipment�N
ID_C2S_ClearFightEquipment�N
ID_S2C_ClearFightEquipment�N
ID_C2S_AddFightTreasure�N
ID_S2C_AddFightTreasure�N
ID_C2S_ClearFightTreasure�N
ID_S2C_ClearFightTreasure�N
ID_C2S_GiftCode�N
ID_S2C_GiftCode�N
ID_S2C_RollNotice�N
ID_S2C_HOF_Points�N
ID_S2C_GetAwakenItem�N
ID_C2S_AwakenShopInfo�N
ID_S2C_AwakenShopInfo�N
ID_C2S_AwakenShopRefresh�N
ID_S2C_AwakenShopRefresh�N
ID_C2S_GetTencentReward�N
ID_C2S_ChangeTitle�N
ID_S2C_ChangeTitle�N
ID_C2S_UpdateFightValue�N
ID_C2S_FragmentSale�N
ID_S2C_FragmentSale�N
ID_C2S_ItemCompose�N
ID_S2C_ItemCompose�N
ID_C2S_ChangeName�N
ID_S2C_ChangeName�N
ID_C2S_ChatRequest�N
ID_S2C_ChatRequest�N
ID_S2C_Chat�N
ID_S2C_Notify�N
ID_C2S_GetFriendList�O
ID_S2C_GetFriendList�O
ID_C2S_GetFriendReqList�O
ID_S2C_GetFriendReqList�O
ID_C2S_RequestAddFriend�O
ID_S2C_RequestAddFriend�O
ID_C2S_RequestDeleteFriend�O
ID_S2C_RequestDeleteFriend�O
ID_C2S_ConfirmAddFriend�O
ID_S2C_ConfirmAddFriend�O
ID_C2S_FriendPresent�O
ID_S2C_FriendPresent�O
ID_C2S_GetFriendPresent�O
ID_S2C_GetFriendPresent�O
ID_C2S_GetPlayerInfo�O
ID_S2C_GetPlayerInfo�O
ID_S2C_AddFriendRespond�O
ID_C2S_ChooseFriend�O
ID_S2C_ChooseFriend�O
ID_C2S_GetFriendsInfo�O
ID_S2C_GetFriendsInfo�O
ID_C2S_KillFriend�O
ID_S2C_KillFriend�O
ID_S2C_DelFriend�O
ID_C2S_GetChapterList�P
ID_S2C_GetChapterList�P
ID_C2S_GetChapterRank�P
ID_S2C_GetChapterRank�P
ID_S2C_AddStage�P
ID_C2S_ExecuteStage�P
ID_S2C_ExecuteStage�P
ID_C2S_FastExecuteStage�P
ID_S2C_FastExecuteStage�P
ID_C2S_ChapterAchvRwdInfo�P
ID_S2C_ChapterAchvRwdInfo�P 
ID_C2S_FinishChapterAchvRwd�P 
ID_S2C_FinishChapterAchvRwd�P
ID_C2S_FinishChapterBoxRwd�P
ID_S2C_FinishChapterBoxRwd�P!
ID_C2S_ResetDungeonExecution�P!
ID_S2C_ResetDungeonExecution�P"
ID_C2S_ResetDungeonFastTimeCd�P"
ID_S2C_ResetDungeonFastTimeCd�P
ID_S2C_ExecuteMultiStage�P
ID_C2S_ExecuteMultiStage�P
ID_S2C_FirstEnterChapter�P
ID_C2S_FirstEnterChapter�P
ID_C2S_GetArenaInfo�Q
ID_S2C_GetArenaInfo�Q
ID_C2S_ChallengeArena�Q
ID_S2C_ChallengeArena�Q
ID_C2S_GetArenaTopInfo�Q
ID_S2C_GetArenaTopInfo�Q
ID_C2S_GetArenaUserInfo�Q
ID_S2C_GetArenaUserInfo�Q
ID_C2S_TowerInfo�R
ID_S2C_TowerInfo�R
ID_C2S_TowerChallenge�R
ID_S2C_TowerChallenge�R
ID_C2S_TowerStartCleanup�R
ID_S2C_TowerStartCleanup�R
ID_C2S_TowerStopCleanup�R
ID_S2C_TowerStopCleanup�R
ID_C2S_TowerReset�R
ID_S2C_TowerReset�R
ID_C2S_TowerGetBuff�R
ID_S2C_TowerGetBuff�R
ID_C2S_TowerRfBuff�R
ID_S2C_TowerRfBuff�R
ID_C2S_TowerRequestReward�R
ID_S2C_TowerRequestReward�R
ID_C2S_TowerRankingList�R
ID_S2C_TowerRankingList�R
ID_C2S_TowerChallengeGuide�R
ID_S2C_TowerChallengeGuide�R
ID_S2C_GetSimpleMail�R
ID_S2C_AddSimpleMail�R
ID_S2C_GetNewMailCount�R
ID_C2S_GetMail�R
ID_S2C_GetMail�R
ID_S2C_GetGiftMailCount�R
ID_C2S_GetGiftMail�R
ID_S2C_GetGiftMail�R
ID_C2S_ProcessGiftMail�R
ID_S2C_ProcessGiftMail�R
ID_C2S_TestMail�R
ID_C2S_Mail�R
ID_S2C_Mail�R
ID_C2S_RecruitInfo�S
ID_S2C_RecruitInfo�S
ID_C2S_RecruitLp�S
ID_S2C_RecruitLp�S
ID_C2S_RecruitLpTen�S
ID_S2C_RecruitLpTen�S
ID_C2S_RecruitJp�S
ID_S2C_RecruitJp�S
ID_C2S_RecruitJpTen�S
ID_S2C_RecruitJpTen�S
ID_C2S_RecruitJpTw�S
ID_S2C_RecruitJpTw�S
ID_C2S_RecruitZy�S
ID_S2C_RecruitZy�S
ID_C2S_GetSkillTree�T
ID_S2C_GetSkillTree�T
ID_C2S_LearnSkill�T
ID_S2C_LearnSkill�T
ID_C2S_ResetSkill�T
ID_S2C_ResetSkill�T
ID_C2S_PlaceSkill�T
ID_S2C_PlaceSkill�T
ID_C2S_GetStoryList�U
ID_S2C_GetStoryList�U
ID_C2S_ExecuteBarrier�U
ID_S2C_ExecuteBarrier�U
ID_C2S_FastExecuteBarrier�U
ID_S2C_FastExecuteBarrier�U
ID_C2S_SanguozhiAwardInfo�U
ID_S2C_SanguozhiAwardInfo�U 
ID_C2S_FinishSanguozhiAward�U 
ID_S2C_FinishSanguozhiAward�U 
ID_C2S_ResetStoryFastTimeCd�U 
ID_S2C_ResetStoryFastTimeCd�U
ID_S2C_AddStoryDungeon�U
ID_C2S_SetStoryTag�U
ID_S2C_SetStoryTag�U
ID_C2S_GetBarrierAward�U
ID_S2C_GetBarrierAward�U
ID_C2S_UpgradeKnight�U
ID_S2C_UpgradeKnight�U
ID_C2S_AdvancedKnight�U
ID_S2C_AdvancedKnight�U
ID_C2S_TrainingKnight�U
ID_S2C_TrainingKnight�U
ID_C2S_SaveTrainingKnight�U
ID_S2C_SaveTrainingKnight�U 
ID_C2S_GiveupTrainingKnight�V 
ID_S2C_GiveupTrainingKnight�V
ID_C2S_RecycleKnight�V
ID_S2C_RecycleKnight�V
ID_C2S_UpgradeKnightHalo�V
ID_S2C_UpgradeKnightHalo�V
ID_C2S_GetKnightAttr�V
ID_S2C_GetKnightAttr�V
ID_C2S_KnightTransform�V
ID_S2C_KnightTransform�V
ID_C2S_KnightOrangeToRed�V
ID_S2C_KnightOrangeToRed�V
ID_C2S_UpgradeEquipment�]
ID_S2C_UpgradeEquipment�]
ID_C2S_RefiningEquipment�]
ID_S2C_RefiningEquipment�]
ID_C2S_RecycleEquipment�]
ID_S2C_RecycleEquipment�]
ID_C2S_RebornEquipment�]
ID_S2C_RebornEquipment�]
ID_C2S_UpStarEquipment�]
ID_S2C_UpStarEquipment�]
ID_C2S_FastRefineEquipment�]
ID_S2C_FastRefineEquipment�]
ID_C2S_GetHandbookInfo�^
ID_S2C_GetHandbookInfo�^
ID_S2C_GetRebel�_
ID_C2S_EnterRebelUI�_
ID_S2C_EnterRebelUI�_
ID_C2S_AttackRebel�_
ID_S2C_AttackRebel�_
ID_C2S_PublicRebel�_
ID_S2C_PublicRebel�_
ID_C2S_RebelRank�_
ID_S2C_RebelRank�_
ID_C2S_MyRebelRank�_
ID_S2C_MyRebelRank�_
ID_C2S_RefreshRebel�_
ID_S2C_RefreshRebel�_
ID_C2S_GetExploitAward�_
ID_S2C_GetExploitAward�_
ID_C2S_GetExploitAwardType�_
ID_S2C_GetExploitAwardType�_
ID_C2S_RefreshRebelShow�_
ID_S2C_RefreshRebelShow�_&
!ID_C2S_GetTreasureFragmentRobList�`&
!ID_S2C_GetTreasureFragmentRobList�`
ID_C2S_RobTreasureFragment�`
ID_S2C_RobTreasureFragment�`
ID_C2S_UpgradeTreasure�`
ID_S2C_UpgradeTreasure�`
ID_C2S_RefiningTreasure�`
ID_S2C_RefiningTreasure�`
ID_C2S_ComposeTreasure�`
ID_S2C_ComposeTreasure�`(
#ID_C2S_TreasureFragmentForbidBattle�`(
#ID_S2C_TreasureFragmentForbidBattle�`
ID_C2S_RecycleTreasure�`
ID_S2C_RecycleTreasure�`#
ID_C2S_FastRobTreasureFragment�`#
ID_S2C_FastRobTreasureFragment�`
ID_C2S_TreasureSmelt�`
ID_S2C_TreasureSmelt�`
ID_C2S_TreasureForge�`
ID_S2C_TreasureForge�`%
 ID_C2S_OneKeyRobTreasureFragment�`%
 ID_S2C_OneKeyRobTreasureFragment�`
ID_C2S_GetGuideId�`
ID_S2C_GetGuideId�`
ID_C2S_SaveGuideId�`
ID_S2C_SaveGuideId�`
ID_C2S_GetVip�a
ID_S2C_GetVip�a
ID_C2S_ExecuteVipDungeon�a
ID_S2C_ExecuteVipDungeon�a 
ID_C2S_ResetVipDungeonCount�a 
ID_S2C_ResetVipDungeonCount�a
ID_C2S_LiquorInfo�b
ID_S2C_LiquorInfo�b
ID_C2S_Drink�b
ID_S2C_Drink�b
ID_C2S_GetRecharge�c
ID_S2C_GetRecharge�c
ID_C2S_UseMonthCard�c
ID_S2C_UseMonthCard�c
ID_S2C_RechargeSuccess�c
ID_C2S_GetRechargeBonus�c
ID_S2C_GetRechargeBonus�c
ID_C2S_MrGuanInfo�d
ID_S2C_MrGuanInfo�d
ID_C2S_Worship�d
ID_S2C_Worship�d
ID_C2S_LoginRewardInfo�d
ID_S2C_LoginRewardInfo�d
ID_C2S_LoginReward�d
ID_S2C_LoginReward�d
ID_C2S_GetDailyMission�e
ID_S2C_GetDailyMission�e
ID_C2S_FinishDailyMission�e
ID_S2C_FinishDailyMission�e 
ID_C2S_GetDailyMissionAward�e 
ID_S2C_GetDailyMissionAward�e
ID_C2S_ResetDailyMission�e
ID_S2C_ResetDailyMission�e
ID_S2C_FlushDailyMission�e
ID_C2S_WushInfo�f
ID_S2C_WushInfo�f
ID_C2S_WushGetBuff�f
ID_S2C_WushGetBuff�f
ID_C2S_WushChallenge�f
ID_S2C_WushChallenge�f
ID_C2S_WushReset�f
ID_S2C_WushReset�f
ID_C2S_WushRankingList�f
ID_S2C_WushRankingList�f
ID_C2S_WushApplyBuff�f
ID_S2C_WushApplyBuff�f
ID_C2S_WushBuy�f
ID_S2C_WushBuy�f
ID_C2S_TargetInfo�g
ID_S2C_TargetInfo�g
ID_C2S_TargetGetReward�g
ID_S2C_TargetGetReward�g
ID_C2S_GetMainGrouthInfo�g
ID_S2C_GetMainGrouthInfo�g
ID_C2S_UseMainGrouthInfo�g
ID_S2C_UseMainGrouthInfo�g
ID_C2S_HOF_UIInfo�h
ID_S2C_HOF_UIInfo�h
ID_C2S_HOF_Confirm�h
ID_S2C_HOF_Confirm�h
ID_C2S_HOF_Sign�h
ID_S2C_HOF_Sign�h
ID_C2S_HOF_RankInfo�h
ID_S2C_HOF_RankInfo�h
ID_C2S_GetFundInfo�i
ID_S2C_GetFundInfo�i
ID_C2S_GetUserFund�i
ID_S2C_GetUserFund�i
ID_C2S_BuyFund�i
ID_S2C_BuyFund�i
ID_C2S_GetFundAward�i
ID_S2C_GetFundAward�i
ID_C2S_GetFundWeal�i
ID_S2C_GetFundWeal�i
ID_C2S_CityInfo�j
ID_S2C_CityInfo�j
ID_C2S_CityAttack�j
ID_S2C_CityAttack�j
ID_C2S_CityPatrol�j
ID_S2C_CityPatrol�j
ID_C2S_CityReward�j
ID_S2C_CityReward�j
ID_C2S_CityAssist�j
ID_S2C_CityAssist�j
ID_C2S_CityCheck�j
ID_S2C_CityCheck�j
ID_S2C_CityAssisted�j
ID_C2S_CityOneKeyReward�j
ID_S2C_CityOneKeyReward�j
ID_C2S_CityOneKeyPatrol�j
ID_S2C_CityOneKeyPatrol�j
ID_C2S_CityOneKeyPatrolSet�j
ID_S2C_CityOneKeyPatrolSet�j
ID_C2S_CityTechUp�j
ID_S2C_CityTechUp�j!
ID_C2S_GetCustomActivityInfo�k!
ID_S2C_GetCustomActivityInfo�k 
ID_S2C_UpdateCustomActivity�k%
 ID_S2C_UpdateCustomActivityQuest�k"
ID_C2S_GetCustomActivityAward�k"
ID_S2C_GetCustomActivityAward�k&
!ID_S2C_UpdateCustomSeriesActivity�k#
ID_C2S_GetCustomSeriesActivity�k#
ID_S2C_GetCustomSeriesActivity�k
ID_C2S_GetHolidayEventInfo�k
ID_S2C_GetHolidayEventInfo�k 
ID_C2S_GetHolidayEventAward�k 
ID_S2C_GetHolidayEventAward�k
ID_C2S_ComposeAwakenItem�l
ID_S2C_ComposeAwakenItem�l
ID_C2S_PutonAwakenItem�l
ID_S2C_PutonAwakenItem�l
ID_C2S_AwakenKnight�l
ID_S2C_AwakenKnight�l!
ID_C2S_FastComposeAwakenItem�l!
ID_S2C_FastComposeAwakenItem�l
ID_C2S_GetDaysActivityInfo�m
ID_S2C_GetDaysActivityInfo�m
ID_C2S_FinishDaysActivity�m
ID_S2C_FinishDaysActivity�m
ID_C2S_GetDaysActivitySell�m
ID_S2C_GetDaysActivitySell�m 
ID_C2S_PurchaseActivitySell�m 
ID_S2C_PurchaseActivitySell�m
ID_S2C_FlushDaysActivity�m
ID_C2S_UpgradeDress�n
ID_S2C_UpgradeDress�n
ID_S2C_GetDress�n
ID_C2S_AddFightDress�n
ID_S2C_AddFightDress�n
ID_C2S_ClearFightDress�n
ID_S2C_ClearFightDress�n
ID_C2S_RecycleDress�n
ID_S2C_RecycleDress�n
ID_C2S_Share�n
ID_S2C_Share�n
ID_C2S_GetShareState�n
ID_S2C_GetShareState�n
ID_C2S_GetPhoneBindNotice�n
ID_S2C_GetPhoneBindNotice�n
ID_C2S_GetRechargeBack�o
ID_S2C_GetRechargeBack�o
ID_C2S_RechargeBackGold�o
ID_S2C_RechargeBackGold�o
ID_C2S_GetCorpList�}
ID_S2C_GetCorpList�}
ID_C2S_GetJoinCorpList�}
ID_S2C_GetJoinCorpList�}
ID_C2S_GetCorpDetail�}
ID_S2C_GetCorpDetail�}
ID_C2S_GetCorpMember�}
ID_S2C_GetCorpMember�}
ID_C2S_GetCorpHistory�}
ID_S2C_GetCorpHistory�}
ID_S2C_NotifyCorpDismiss�}
ID_C2S_CreateCorp�}
ID_S2C_CreateCorp�}
ID_C2S_RequestJoinCorp�}
ID_S2C_RequestJoinCorp�}
ID_C2S_DeleteJoinCorp�}
ID_S2C_DeleteJoinCorp�}
ID_C2S_QuitCorp�}
ID_S2C_QuitCorp�}
ID_C2S_SearchCorp�}
ID_S2C_SearchCorp�}
ID_C2S_ExchangeLeader�}
ID_S2C_ExchangeLeader�}
ID_C2S_ConfirmJoinCorp�~
ID_S2C_ConfirmJoinCorp�~
ID_C2S_ModifyCorp�~
ID_S2C_ModifyCorp�~
ID_C2S_DismissCorpMember�~
ID_S2C_DismissCorpMember�~
ID_C2S_GetCorpJoin�~
ID_S2C_GetCorpJoin�~%
 ID_S2C_MyCorpChangedByCorpLeader�~
ID_C2S_DismissCorp�
ID_S2C_DismissCorp�
ID_C2S_CorpStaff�
ID_S2C_CorpStaff�
ID_C2S_SetCorpChapterId�
ID_S2C_SetCorpChapterId�
ID_C2S_GetCorpWorship��
ID_S2C_GetCorpWorship��
ID_C2S_CorpContribute��
ID_S2C_CorpContribute��#
ID_C2S_GetCorpContributeAward��#
ID_S2C_GetCorpContributeAward��
ID_C2S_GetCorpSpecialShop�
ID_S2C_GetCorpSpecialShop�� 
ID_C2S_CorpSpecialShopping�� 
ID_S2C_CorpSpecialShopping��
ID_C2S_GetCorpChapter؁
ID_S2C_GetCorpChapterف
ID_C2S_GetCorpDungeonInfoځ
ID_S2C_GetCorpDungeonInfoہ
ID_C2S_ExecuteCorpDungeon܁
ID_S2C_ExecuteCorpDungeon݁
ID_S2C_FlushCorpDungeonށ 
ID_C2S_GetDungeonAwardList߁ 
ID_S2C_GetDungeonAwardList��
ID_C2S_GetDungeonAward�
ID_S2C_GetDungeonAward�
ID_C2S_GetDungeonCorpRank�
ID_S2C_GetDungeonCorpRank�%
ID_C2S_GetDungeonCorpMemberRank�%
ID_S2C_GetDungeonCorpMemberRank�%
ID_C2S_GetDungeonAwardCorpPoint�%
ID_S2C_GetDungeonAwardCorpPoint�
ID_S2C_FlushDungeonAward�
ID_C2S_ResetDungeonCount�
ID_S2C_ResetDungeonCount�
ID_C2S_GetCorpChapterRank�
ID_S2C_GetCorpChapterRank�#
ID_C2S_GetCorpCrossBattleInfo��#
ID_S2C_GetCorpCrossBattleInfo��!
ID_C2S_ApplyCorpCrossBattle��!
ID_S2C_ApplyCorpCrossBattle�� 
ID_C2S_QuitCorpCrossBattle�� 
ID_S2C_QuitCorpCrossBattle��#
ID_C2S_GetCorpCrossBattleList#
ID_S2C_GetCorpCrossBattleListÂ$
ID_C2S_GetCrossBattleEncourageĂ$
ID_S2C_GetCrossBattleEncourageł!
ID_C2S_CrossBattleEncourageƂ!
ID_S2C_CrossBattleEncourageǂ 
ID_C2S_GetCrossBattleFieldȂ 
ID_S2C_GetCrossBattleFieldɂ$
ID_C2S_GetCrossBattleEnemyCorpʂ$
ID_S2C_GetCrossBattleEnemyCorp˂&
 ID_C2S_CrossBattleChallengeEnemy΂&
 ID_S2C_CrossBattleChallengeEnemyς(
"ID_C2S_ResetCrossBattleChallengeCDЂ(
"ID_S2C_ResetCrossBattleChallengeCDт!
ID_C2S_SetCrossBattleFireOn҂!
ID_S2C_SetCrossBattleFireOnӂ"
ID_C2S_CrossBattleMemberRankԂ"
ID_S2C_CrossBattleMemberRankՂ
ID_S2C_BroadCastState؂#
ID_C2S_GetCorpCrossBattleTimeق#
ID_S2C_GetCorpCrossBattleTimeڂ%
ID_S2C_FlushCorpCrossBattleListۂ&
 ID_S2C_FlushCorpCrossBattleField܂
ID_S2C_FlushCorpEncourage݂"
ID_S2C_FlushCorpBattleResultނ
ID_S2C_FlushFireOn߂"
ID_S2C_FlushBattleMemberInfo��
ID_C2S_GetNewCorpChapter��
ID_S2C_GetNewCorpChapter��"
ID_C2S_GetNewCorpDungeonInfo��"
ID_S2C_GetNewCorpDungeonInfo��"
ID_C2S_ExecuteNewCorpDungeon��"
ID_S2C_ExecuteNewCorpDungeon�� 
ID_S2C_FlushNewCorpDungeon��#
ID_C2S_GetNewDungeonAwardList��#
ID_S2C_GetNewDungeonAwardList��
ID_C2S_GetNewDungeonAward��
ID_S2C_GetNewDungeonAward��(
"ID_C2S_GetNewDungeonCorpMemberRank��(
"ID_S2C_GetNewDungeonCorpMemberRank��!
ID_S2C_FlushNewDungeonAward��!
ID_C2S_ResetNewDungeonCount��!
ID_S2C_ResetNewDungeonCount��
ID_C2S_GetNewChapterAward��
ID_S2C_GetNewChapterAward��#
ID_C2S_GetNewDungeonAwardHint��#
ID_S2C_GetNewDungeonAwardHint��"
ID_C2S_GetNewCorpChapterRank��"
ID_S2C_GetNewCorpChapterRank��&
 ID_C2S_SetNewCorpRollbackChapter��&
 ID_S2C_SetNewCorpRollbackChapter��
ID_C2S_GetCorpTechInfo��
ID_S2C_GetCorpTechInfo��
ID_C2S_DevelopCorpTech��
ID_S2C_DevelopCorpTech��
ID_C2S_LearnCorpTech��
ID_S2C_LearnCorpTech��
ID_C2S_CorpUpLevel��
ID_S2C_CorpUpLevel��%
ID_S2C_DevelopCorpTechBroadcast��!
ID_S2C_CorpUpLevelBroadcast��
ID_C2S_Hard_GetChapterList�p
ID_S2C_Hard_GetChapterList�p
ID_C2S_Hard_GetChapterRank�p
ID_S2C_Hard_GetChapterRank�p
ID_S2C_Hard_AddStage�p
ID_C2S_Hard_ExecuteStage�p
ID_S2C_Hard_ExecuteStage�p!
ID_C2S_Hard_FastExecuteStage�p!
ID_S2C_Hard_FastExecuteStage�p$
ID_C2S_Hard_FinishChapterBoxRwd�p$
ID_S2C_Hard_FinishChapterBoxRwd�p&
!ID_C2S_Hard_ResetDungeonExecution�p&
!ID_S2C_Hard_ResetDungeonExecution�p"
ID_S2C_Hard_ExecuteMultiStage�p"
ID_C2S_Hard_ExecuteMultiStage�p"
ID_S2C_Hard_FirstEnterChapter�p"
ID_C2S_Hard_FirstEnterChapter�p
ID_S2C_Hard_GetChapterRoit�p
ID_C2S_Hard_GetChapterRoit�p"
ID_S2C_Hard_FinishChapterRoit�p"
ID_C2S_Hard_FinishChapterRoit�p
ID_C2S_WheelInfo�q
ID_S2C_WheelInfo�q
ID_C2S_PlayWheel�q
ID_S2C_PlayWheel�q
ID_C2S_WheelReward�q
ID_S2C_WheelReward�q
ID_C2S_WheelRankingList�q
ID_S2C_WheelRankingList�q
ID_C2S_VipDiscountInfo�r
ID_S2C_VipDiscountInfo�r
ID_C2S_BuyVipDiscount�r
ID_S2C_BuyVipDiscount�r
ID_C2S_GetCrossBattleInfo�r
ID_S2C_GetCrossBattleInfo�r
ID_C2S_GetCrossBattleTime�r
ID_S2C_GetCrossBattleTime�r"
ID_C2S_SelectCrossBattleGroup�r"
ID_S2C_SelectCrossBattleGroup�r
ID_C2S_EnterScoreBattle�r
ID_S2C_EnterScoreBattle�r
ID_C2S_GetCrossBattleEnemy�r
ID_S2C_GetCrossBattleEnemy�r%
 ID_C2S_ChallengeCrossBattleEnemy�r%
 ID_S2C_ChallengeCrossBattleEnemy�r
ID_C2S_GetWinsAwardInfo�r
ID_S2C_GetWinsAwardInfo�r
ID_C2S_FinishWinsAward�r
ID_S2C_FinishWinsAward�r
ID_C2S_GetCrossBattleRank�r
ID_S2C_GetCrossBattleRank�r
ID_C2S_CrossCountReset�s
ID_S2C_CrossCountReset�s"
ID_S2C_FlushCrossContestScore�s!
ID_S2C_FlushCrossContestRank�s
ID_C2S_GetCrossArenaInfo�s
ID_S2C_GetCrossArenaInfo�s#
ID_C2S_GetCrossArenaInvitation�s#
ID_S2C_GetCrossArenaInvitation�s!
ID_C2S_GetCrossArenaBetsInfo�s!
ID_S2C_GetCrossArenaBetsInfo�s!
ID_C2S_GetCrossArenaBetsList�s!
ID_S2C_GetCrossArenaBetsList�s
ID_C2S_CrossArenaPlayBets�s
ID_S2C_CrossArenaPlayBets�s 
ID_C2S_GetCrossArenaRankTop�s 
ID_S2C_GetCrossArenaRankTop�s!
ID_C2S_GetCrossArenaRankUser�s!
ID_S2C_GetCrossArenaRankUser�s#
ID_C2S_CrossArenaRankChallenge�s#
ID_S2C_CrossArenaRankChallenge�s 
ID_C2S_CrossArenaCountReset�s 
ID_S2C_CrossArenaCountReset�s"
ID_C2S_GetCrossArenaBetsAward�s"
ID_S2C_GetCrossArenaBetsAward�s%
 ID_C2S_CrossArenaServerAwardInfo�s%
 ID_S2C_CrossArenaServerAwardInfo�s'
"ID_C2S_FinishCrossArenaServerAward�s'
"ID_S2C_FinishCrossArenaServerAward�s%
 ID_C2S_FinishCrossArenaBetsAward�s%
 ID_S2C_FinishCrossArenaBetsAward�s
ID_C2S_CrossArenaAddBets�s
ID_S2C_CrossArenaAddBets�s
ID_C2S_GetCrossUserDetail�s
ID_S2C_GetCrossUserDetail�s
ID_C2S_RichInfo�s
ID_S2C_RichInfo�s
ID_C2S_RichMove�s
ID_S2C_RichMove�s
ID_C2S_RichBuy�s
ID_S2C_RichBuy�s
ID_C2S_RichReward�s
ID_S2C_RichReward�s
ID_C2S_RichRankingList�s
ID_S2C_RichRankingList�s
ID_C2S_GetTimeDungeonList�t
ID_S2C_GetTimeDungeonList�t 
ID_S2C_FlushTimeDungeonList�t
ID_C2S_GetTimeDungeonInfo�t
ID_S2C_GetTimeDungeonInfo�t
ID_C2S_AddTimeDungeonBuff�t
ID_S2C_AddTimeDungeonBuff�t
ID_C2S_AttackTimeDungeon�t
ID_S2C_AttackTimeDungeon�t
ID_C2S_GetCodeId�u
ID_S2C_GetCodeId�u
ID_C2S_GetCode�u
ID_S2C_GetCode�u
ID_C2S_SetCDLevel�u
ID_S2C_SetCDLevel�u
ID_C2S_EnterRebelBossUI�u
ID_S2C_EnterRebelBossUI�u&
!ID_C2S_SelectAttackRebelBossGroup�v&
!ID_S2C_SelectAttackRebelBossGroup�v
ID_C2S_ChallengeRebelBoss�v
ID_S2C_ChallengeRebelBoss�v
ID_C2S_RebelBossRank�v
ID_S2C_RebelBossRank�v
ID_C2S_RebelBossAwardInfo�v
ID_S2C_RebelBossAwardInfo�v
ID_C2S_RebelBossAward�v
ID_S2C_RebelBossAward�v
ID_C2S_RefreshRebelBoss�v
ID_S2C_RefreshRebelBoss�v
ID_C2S_PurchaseAttackCount�v
ID_S2C_PurchaseAttackCount�v
ID_C2S_GetRebelBossReport�v
ID_S2C_GetRebelBossReport�v"
ID_C2S_RebelBossCorpAwardInfo�v"
ID_S2C_RebelBossCorpAwardInfo�v
ID_C2S_FlushBossACountTime�v
ID_S2C_FlushBossACountTime�v
ID_C2S_GetBlackcardWarning�v
ID_S2C_GetBlackcardWarning�v
ID_C2S_GetSpreadId�w
ID_S2C_GetSpreadId�w
ID_C2S_RegisterId�w
ID_S2C_RegisterId�w 
ID_C2S_InvitorGetRewardInfo�w 
ID_S2C_InvitorGetRewardInfo�w 
ID_C2S_InvitorDrawLvlReward�w 
ID_S2C_InvitorDrawLvlReward�w"
ID_C2S_InvitorDrawScoreReward�w"
ID_S2C_InvitorDrawScoreReward�w
ID_C2S_InvitedDrawReward�w
ID_S2C_InvitedDrawReward�w 
ID_C2S_InvitedGetDrawReward�w 
ID_S2C_InvitedGetDrawReward�w!
ID_C2S_QueryRegisterRelation�w!
ID_S2C_QueryRegisterRelation�w
ID_C2S_GetInvitorName�w
ID_S2C_GetInvitorName�w
ID_C2S_ShopTimeInfo�x
ID_S2C_ShopTimeInfo�x
ID_C2S_ShopTimeRewardInfo�x
ID_S2C_ShopTimeRewardInfo�x
ID_C2S_ShopTimeGetReward�x
ID_S2C_ShopTimeGetReward�x
ID_S2C_ShopTimePurchase�x
ID_C2S_ShopTimeStartTime�x
ID_S2C_ShopTimeStartTime�x
ID_C2S_VipDailyInfo�y
ID_S2C_VipDailyInfo�y
ID_C2S_BuyVipDaily�y
ID_S2C_BuyVipDaily�y
ID_C2S_GetUserRice�y
ID_S2C_GetUserRice�y
ID_S2C_UpdateUserRice�y
ID_C2S_FlushRiceRivals�y
ID_S2C_FlushRiceRivals�y
ID_C2S_RobRice�y
ID_S2C_RobRice�y
ID_S2C_ChangeUserRice�y
ID_C2S_GetRiceEnemyInfo�y
ID_S2C_GetRiceEnemyInfo�y
ID_C2S_RevengeRiceEnemy�y
ID_S2C_RevengeRiceEnemy�y
ID_C2S_GetRiceAchievement�y
ID_S2C_GetRiceAchievement�y
ID_C2S_GetRiceRankList�y
ID_S2C_GetRiceRankList�y
ID_C2S_GetRiceRankAward�z
ID_S2C_GetRiceRankAward�z
ID_C2S_BuyRiceToken�z
ID_S2C_BuyRiceToken�z
ID_S2C_FlushRiceRank�z
ID_C2S_PushSingleInfo�z
ID_S2C_PushSingleInfo�z
ID_C2S_GmChangeName�z 
ID_C2S_GetMonthFundBaseInfo�z 
ID_S2C_GetMonthFundBaseInfo�z!
ID_C2S_GetMonthFundAwardInfo�z!
ID_S2C_GetMonthFundAwardInfo�z
ID_C2S_GetMonthFundAward�z
ID_S2C_GetMonthFundAward�z
ID_C2S_ThemeDropZY�{
ID_S2C_ThemeDropZY�{
ID_C2S_ThemeDropAstrology�{
ID_S2C_ThemeDropAstrology�{
ID_C2S_ThemeDropExtract�{
ID_S2C_ThemeDropExtract�{
ID_C2S_DungeonDailyInfo�{
ID_S2C_DungeonDailyInfo�{!
ID_C2S_DungeonDailyChallenge�{!
ID_S2C_DungeonDailyChallenge�{
ID_C2S_GetSpeXialScoreInfo�{
ID_S2C_GetSpeXialScoreInfo�{
ID_C2S_GetSpeXialScoreRank�{
ID_S2C_GetSpeXialScoreRank�{ 
ID_C2S_GetSpeXialScoreAward�{ 
ID_S2C_GetSpeXialScoreAward�{!
ID_C2S_GetAccountBindingInfo�{!
ID_S2C_GetAccountBindingInfo�{"
ID_C2S_GetAccountBindingAward�{"
ID_S2C_GetAccountBindingAward�{
ID_C2S_WushBossInfo�|
ID_S2C_WushBossInfo�|
ID_C2S_WushBossChallenge�|
ID_S2C_WushBossChallenge�|
ID_C2S_WushBossBuy�|
ID_S2C_WushBossBuy�|
ID_C2S_GetGroupBuyConfig�
ID_S2C_GetGroupBuyConfig� 
ID_C2S_GetGroupBuyMainInfo� 
ID_S2C_GetGroupBuyMainInfo�
ID_C2S_GetGroupBuyRanking�
ID_S2C_GetGroupBuyRanking�%
ID_C2S_GetGroupBuyTaskAwardInfo�%
ID_S2C_GetGroupBuyTaskAwardInfo�!
ID_C2S_GetGroupBuyTaskAward��!
ID_S2C_GetGroupBuyTaskAward�
ID_C2S_GetGroupBuyEndInfo�
ID_S2C_GetGroupBuyEndInfo�!
ID_C2S_GetGroupBuyRankAward�!
ID_S2C_GetGroupBuyRankAward��"
ID_C2S_GroupBuyPurchaseGoods��"
ID_S2C_GroupBuyPurchaseGoods�� 
ID_C2S_GetGroupBuyTimeInfo�� 
ID_S2C_GetGroupBuyTimeInfo��
ID_C2S_RookieInfo̅
ID_S2C_RookieInfoͅ
ID_C2S_GetRookieReward΅
ID_S2C_GetRookieRewardυ
ID_C2S_SetPictureFrame��
ID_S2C_SetPictureFrame��
ID_C2S_GetBattleFieldInfo��
ID_S2C_GetBattleFieldInfo��
ID_C2S_BattleFieldDetail��
ID_S2C_BattleFieldDetail��!
ID_C2S_ChallengeBattleField��!
ID_S2C_ChallengeBattleField��!
ID_C2S_BattleFieldAwardInfo��!
ID_S2C_BattleFieldAwardInfo�� 
ID_C2S_GetBattleFieldAward�� 
ID_S2C_GetBattleFieldAward�� 
ID_C2S_BattleFieldShopInfo�� 
ID_S2C_BattleFieldShopInfo��#
ID_C2S_BattleFieldShopRefresh��#
ID_S2C_BattleFieldShopRefresh��
ID_C2S_GetBattleFieldRank��
ID_S2C_GetBattleFieldRank��
ID_C2S_TrigramInfo��
ID_S2C_TrigramInfo��
ID_C2S_TrigramPlay��
ID_S2C_TrigramPlay��
ID_C2S_TrigramPlayAll��
ID_S2C_TrigramPlayAll��
ID_C2S_TrigramRefresh��
ID_S2C_TrigramRefresh��
ID_C2S_TrigramReward��
ID_S2C_TrigramReward��
ID_C2S_GetTrigramRank��
ID_S2C_GetTrigramRank��&
 ID_C2S_GetSpecialHolidayActivity��&
 ID_S2C_GetSpecialHolidayActivity��)
#ID_S2C_UpdateSpecialHolidayActivity��,
&ID_C2S_GetSpecialHolidayActivityReward��,
&ID_S2C_GetSpecialHolidayActivityReward��#
ID_C2S_GetSpecialHolidaySales��#
ID_S2C_GetSpecialHolidaySales��"
ID_C2S_BuySpecialHolidaySale��"
ID_S2C_BuySpecialHolidaySale��
ID_C2S_VipWeekShopInfo܈
ID_S2C_VipWeekShopInfo݈
ID_C2S_VipWeekShopBuyވ
ID_S2C_VipWeekShopBuy߈+
%ID_C2S_GetExpansiveDungeonChapterList��+
%ID_S2C_GetExpansiveDungeonChapterList��(
"ID_C2S_ExcuteExpansiveDungeonStage(
"ID_S2C_ExcuteExpansiveDungeonStageÉ-
'ID_C2S_GetExpansiveDungeonChapterRewardĉ-
'ID_S2C_GetExpansiveDungeonChapterRewardŉ.
(ID_C2S_FirstEnterExpansiveDungeonChapterƉ.
(ID_S2C_FirstEnterExpansiveDungeonChapterǉ(
"ID_S2C_AddExpansiveDungeonNewStageȉ-
'ID_C2S_PurchaseExpansiveDungeonShopItemɉ-
'ID_S2C_PurchaseExpansiveDungeonShopItemʉ
ID_S2C_GetPetЌ
ID_C2S_PetUpLvlь
ID_S2C_PetUpLvlҌ
ID_C2S_PetUpStarӌ
ID_S2C_PetUpStarԌ
ID_C2S_PetUpAdditionՌ
ID_S2C_PetUpAddition֌
ID_C2S_ChangeFightPet׌
ID_S2C_ChangeFightPet،
ID_C2S_RecyclePetٌ
ID_S2C_RecyclePetڌ
ID_C2S_PetFightValueی
ID_S2C_PetFightValue܌
ID_C2S_GetPetProtect݌
ID_S2C_GetPetProtectތ
ID_C2S_SetPetProtectߌ
ID_S2C_SetPetProtect�� 
ID_C2S_GetCrossPvpSchedule�� 
ID_S2C_GetCrossPvpSchedule�� 
ID_C2S_GetCrossPvpBaseInfo�� 
ID_S2C_GetCrossPvpBaseInfo��$
ID_C2S_GetCrossPvpScheduleInfo��$
ID_S2C_GetCrossPvpScheduleInfo��
ID_C2S_ApplyCrossPvp��
ID_S2C_ApplyCrossPvp��#
ID_C2S_ApplyAtcAndDefCrossPvp#
ID_S2C_ApplyAtcAndDefCrossPvpÔ
ID_C2S_GetCrossPvpRoleĔ
ID_S2C_GetCrossPvpRoleŔ
ID_C2S_GetCrossPvpArenaǔ
ID_S2C_GetCrossPvpArenaȔ
ID_C2S_GetCrossPvpRankɔ
ID_S2C_GetCrossPvpRankʔ
ID_C2S_CrossPvpBattle˔
ID_S2C_CrossPvpBattle̔
ID_S2C_FlushCrossPvpArena͔"
ID_S2C_FlushCrossPvpSpecificΔ
ID_S2C_FlushCrossPvpScoreϔ
ID_C2S_GetCrossPvpDetailД
ID_S2C_GetCrossPvpDetailє
ID_C2S_CrossPvpGetAwardҔ
ID_S2C_CrossPvpGetAwardӔ
ID_C2S_CrossWaitInitԔ
ID_S2C_CrossWaitInitՔ
ID_C2S_CrossWaitRank֔
ID_S2C_CrossWaitRankה
ID_C2S_CrossWaitFlowerؔ
ID_S2C_CrossWaitFlowerٔ 
ID_C2S_CrossWaitFlowerRankڔ 
ID_S2C_CrossWaitFlowerRank۔!
ID_C2S_CrossWaitFlowerAwardܔ!
ID_S2C_CrossWaitFlowerAwardݔ$
ID_C2S_CrossWaitInitFlowerInfoޔ$
ID_S2C_CrossWaitInitFlowerInfoߔ
ID_C2S_GetCrossPvpOb��
ID_S2C_GetCrossPvpOb� 
ID_C2S_GetBulletScreenInfo�� 
ID_S2C_GetBulletScreenInfo��!
ID_C2S_SendBulletScreenInfo��!
ID_S2C_SendBulletScreenInfo��
ID_S2C_FlushBulletScreen��
ID_C2S_TeamPVPStatus��
ID_S2C_TeamPVPStatus��
ID_C2S_TeamPVPCreateTeam��
ID_S2C_TeamPVPCreateTeam��
ID_C2S_TeamPVPJoinTeam��
ID_S2C_TeamPVPJoinTeam��
ID_C2S_TeamPVPLeave��
ID_S2C_TeamPVPLeave��"
ID_C2S_TeamPVPChangePosition��"
ID_S2C_TeamPVPChangePosition��"
ID_C2S_TeamPVPKickTeamMember��"
ID_S2C_TeamPVPKickTeamMember��&
 ID_C2S_TeamPVPSetTeamOnlyInvited��&
 ID_S2C_TeamPVPSetTeamOnlyInvited��
ID_C2S_TeamPVPInvite��
ID_S2C_TeamPVPInvite��
ID_S2C_TeamPVPBeInvited��#
ID_C2S_TeamPVPInvitedJoinTeam��#
ID_S2C_TeamPVPInvitedJoinTeam��"
ID_S2C_TeamPVPInviteCanceled��
ID_C2S_TeamPVPInviteNPC��
ID_S2C_TeamPVPInviteNPC��
ID_C2S_TeamPVPAgreeBattle��
ID_S2C_TeamPVPAgreeBattle��"
ID_C2S_TeamPVPMatchOtherTeam��"
ID_S2C_TeamPVPMatchOtherTeam��
ID_C2S_TeamPVPStopMatch��
ID_S2C_TeamPVPStopMatch�� 
ID_S2C_TeamPVPBattleResult��'
!ID_C2S_TeamPVPHistoryBattleReport��'
!ID_S2C_TeamPVPHistoryBattleReport��*
$ID_S2C_TeamPVPHistoryBattleReportEnd��$
ID_C2S_TeamPVPBattleTeamChange��$
ID_S2C_TeamPVPBattleTeamChange��#
ID_S2C_TeamPVPCrossServerLost��
ID_C2S_TeamPVPGetRank��
ID_S2C_TeamPVPGetRank��
ID_C2S_TeamPVPGetUserInfo��
ID_S2C_TeamPVPGetUserInfo��
ID_C2S_TeamPVPBuyAwardCnt��
ID_S2C_TeamPVPBuyAwardCnt�� 
ID_C2S_TeamPVPAcceptInvite�� 
ID_S2C_TeamPVPAcceptInvite��
ID_C2S_TeamPVPPopChat��
ID_S2C_TeamPVPPopChat��
ID_C2S_GetShopTag�
ID_S2C_GetShopTag�
ID_C2S_AddShopTag�
ID_S2C_AddShopTag�
ID_C2S_DelShopTag�
ID_S2C_DelShopTag�
ID_C2S_GetOlderPlayerInfoХ
ID_S2C_GetOlderPlayerInfoѥ#
ID_C2S_GetOlderPlayerVipAwardҥ#
ID_S2C_GetOlderPlayerVipAwardӥ%
ID_C2S_GetOlderPlayerLevelAwardԥ%
ID_S2C_GetOlderPlayerLevelAwardե!
ID_C2S_GetOlderPlayerVipExp֥!
ID_S2C_GetOlderPlayerVipExpץ
ID_C2S_RCardInfo��
ID_S2C_RCardInfo��
ID_C2S_PlayRCard��
ID_S2C_PlayRCard��
ID_C2S_ResetRCard��
ID_S2C_ResetRCard��
ID_C2S_SetClothSwitch��
ID_S2C_SetClothSwitch��
ID_C2S_GetDays7CompInfoĦ
ID_S2C_GetDays7CompInfoŦ
ID_C2S_GetDays7CompAwardƦ
ID_S2C_GetDays7CompAwardǦ
ID_C2S_GetKsoul��
ID_S2C_GetKsoul��
ID_C2S_RecycleKsoul��
ID_S2C_RecycleKsoul��
ID_C2S_ActiveKsoulGroup��
ID_S2C_ActiveKsoulGroup��
ID_C2S_ActiveKsoulTarget��
ID_S2C_ActiveKsoulTarget��
ID_C2S_SummonKsoul��
ID_S2C_SummonKsoul�� 
ID_C2S_SummonKsoulExchange�� 
ID_S2C_SummonKsoulExchange��
ID_C2S_GetCommonRank��
ID_S2C_GetCommonRank��
ID_C2S_KsoulShopInfoʧ
ID_S2C_KsoulShopInfo˧
ID_C2S_KsoulShopBuy̧
ID_S2C_KsoulShopBuyͧ
ID_C2S_KsoulShopRefreshΧ
ID_S2C_KsoulShopRefreshϧ
ID_C2S_KsoulDungeonInfoЧ
ID_S2C_KsoulDungeonInfoѧ 
ID_C2S_KsoulDungeonRefreshҧ 
ID_S2C_KsoulDungeonRefreshӧ"
ID_C2S_KsoulDungeonChallengeԧ"
ID_S2C_KsoulDungeonChallengeէ
ID_C2S_KsoulSetFightBase֧
ID_S2C_KsoulSetFightBaseק!
ID_C2S_ShareFriendAwardInfoާ!
ID_S2C_ShareFriendAwardInfoߧ 
ID_C2S_ShareFriendGetAward� 
ID_S2C_ShareFriendGetAward�
ID_C2S_FortuneInfo�
ID_S2C_FortuneInfo�
ID_C2S_FortuneBuySilver�
ID_S2C_FortuneBuySilver�
ID_C2S_FortuneGetBox�
ID_S2C_FortuneGetBox�*&
BATTLE_INDENTITY
OWN	
ENEMY*0
BATTLE_ROUND_TYPE

BRT_NORMAL
BRT_PET*
BATTLE_TYPE
U2U
U2M*s
SHOPPING_TYPE
VIP	
SCORE
MYSTICAL

AWAKEN

OUTLET
GROUPBUY
BATTLEFIELD	
KSOUL*'
ATTACK_REBEL

NORMAL
SPECIAL*,
REBEL_RANK_TYPE
EXPLOIT
MAX_HARM*1
ACTIVITY_STATE

CLOSED 
OPEN	
AWARD*8
CORP_POSITION

MEMBER 

LEADER
VICE_LEADER*S
CROSS_BATTLE_STATE	
ERROR 
ZERO	
APPLY
WAIT

BATTLE
END*\
CROSS_USERPK_STATE

SERROR 	
SZERO

SSCORE

SWAIT1
SLADDER

SWAIT2*9
REBEL_BOSS_RANK_TYPE

RANK_HONOR
RANK_MAX_HARM*A
REBEL_BOSS_AWARD_TYPE
HARM

BOSS_LEVEL

CORP_HONOR