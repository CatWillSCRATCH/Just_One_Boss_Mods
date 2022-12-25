pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--just one boss
--by bridgs

--[[
hello there! happy to see you
crack open this cart. my name
is bridgs, and i made this game
in early 2018.

in order to meet compression
size restrictions, i had to
remove all of the tabs and
comments of this cart. it was
the simplest and least-
destructive way of meeting
size limitations.

if you'd like to hack on this
cart, i'd highly recommend
checking out the github repo,
which has the original cart,
tabs and all:

https://github.com/bridgs/just-one-boss

thanks for playing!

christmas mod made by catwillscratch

if you would like to crack this modded cart, visit:

https://github.com/catwillscratch/just_one_boss_mods/christmas_edition
]]

-->8

cartdata("bridgs_justoneboss")

function noop() end

local starting_phase,skip_phase_change_animations,skip_title_screen,start_on_hard_mode=0,false,false,false

local conjure_flowers_counter,next_reflection_color,scene_frame,freeze_frames,screen_shake_frames,timer_seconds,score_data_index,time_data_index,rainbow_color,boss_phase,score,score_mult,promises,entities,title_screen,player,player_health,player_reflection,player_figment,boss,boss_health,boss_reflection,curtains,is_paused,hard_mode=1,1,0,0,0,0,0,1,8,0,0,0,{}

-->8
local entity_classes={
{
function(self)
self:draw_sprite(7,1,100,9,15,12)
end,
function(self)
if self.frames_alive%15==0 then
spawn_entity(3,self,nil,{vx=rnd_dir()*(1+rnd(2)),vy=-1-rnd(2)}):poof()
sfx(25,2)
end
end
},
{
function(self)
color_wash(self.parent.dark_color)
pal(8,self.parent.light_color)
pal(1,self.parent.light_color)
self:draw_sprite(7,10,100,9,15,12)
end,
function(self)
self.x+=2*cos(self.frames_alive/50)
end,
vy=1
},
{
function(self)
self:draw_sprite(7,7,91,45,14,12,self.vx>0)
end,
function(self)
self.vy+=0.1
end
},
{
function(self)
self:draw_curtain(1,1)
self:draw_curtain(125,-1)
end,
function(self)
self.amount_closed=62*ease_out_in(self.default_counter/100)
if self.anim!="open" then
self.amount_closed=62-self.amount_closed
end
end,
is_curtains=true,
draw_curtain=function(self,x,dir)
rectfill(x-10*dir,0,x+dir*self.amount_closed,127,0)
local x2
for x2=10,63,14 do
local x3=x+0.5+dir*x2*(1+self.amount_closed/62)/2
line(x3,11,x3,60+40*cos(x2/90-0.02),2)
end
end,
set_anim=function(self,anim)
self.anim,self.default_counter=anim,100
end
},
{
noop,
function(self)
self:check_for_activation()
end,
x=63,
check_for_activation=function(self)
if decrement_counter_prop(self,"frames_until_active") then
self.is_active=true
end
if self.is_active and btnp(1) then
sfx(24,3)
self.is_active=slide(self):on_activated()
end
end,
draw_prompt=function(self,text)
if self.frames_alive%30<22 and self.is_active then
print_centered("press    to "..text,63,99,13)
spr(190,63-2*#text,98)
return true
end
end,
--[[ there is no freaking way
that function worked first try!!!
i literally wrote it and then
i called it and then it worked
perfectly]]
draw_xmas_ed=function(self)
print_centered("c r s m s e i i n",self.x,83,8)
print_centered(" h i t a   d t 0 ",self.x,83,11)
end
},
{
function(self)
self:draw_sprite(23,-29,0,71,47,16)
self:draw_sprite(23,-47,0,88,47,40)
--[[ i'm seriously not lying rn!
i followed my gut and it worked!
this is my first time actually
writing code in pico-8 without a
tutorial!
]]
self:draw_xmas_ed(self,83)
if self:draw_prompt("start") and dget(0)>0 then
pal(13,8)
print_centered("or    for hard mode",63,108)
spr(190,36,107,1,1,true)
end
end,
function(self)
if self.is_active then
hard_mode=false
end
self:check_for_activation()
if self.is_active and btnp(0) and dget(0)>0 then
hard_mode,score_data_index,time_data_index,self.is_active=true,2,3
slide(self,-1):on_activated()
end
end,
frames_until_active=5,
on_activated=function()
music(0)
sfx(9,3)
score,timer_seconds,entities=ternary(starting_phase>0,40,0),0,{title_screen,curtains}
start_game(starting_phase)
end
},
{
function(self,x)
print_centered("thank you for playing!",x+0.5,26,rainbow_color)
print_centered("created (with love) by bridgs",x+0.5,66,6)
print("https://brid.gs",x-24.5,75,12)
print("bridgs_dev",x-24.5,84)
spr(155,x-35.5,82)
print_centered("c r s m s m d b   a w l s r t h",x+1,122,8)
print_centered(" h i t a   o   y c t i l c a c ",x+1,122,11)
self:draw_sprite(11,-41,ternary_hard_mode(69,47),79,22,16)
self:draw_prompt("continue")
end,
x=192,
frames_until_active=130,
on_activated=function(self)
show_title_screen()
end
},
{
function(self,x,y,f)
self:draw_sprite(39,-15,48,95,79,25)
if f>=25 then
print_centered(ternary_hard_mode("you really did it!!","you did it!"),x+0.5,51,15)
end
if f>=135 then
self.draw_score(x,71,"score:",score.."00",format_timer(timer_seconds))
end
if f>=170 then
self.draw_score(x,79,"best:",dget(score_data_index).."00",format_timer(dget(time_data_index)))
end
if self:draw_prompt("continue") then
if dget(score_data_index)==score then
print("!",x+9.5,79,9)
end
if dget(time_data_index)==timer_seconds then
print("!",x+45.5,79,9)
end
end
end,
frames_until_active=215,
on_activated=function(self)
slide(spawn_entity(7))
end,
draw_score=function(x,y,label_text,score_text,time_text)
print(label_text,x-42.5,y,7)
print(score_text,x+9.5-4*#score_text,y)
print(time_text,x+45.5-4*#time_text,y)
spr(173,x+18.5,y)
end
},
{
function(self)
if self:draw_prompt("retry") then
pal(13,5)
print_centered("or    to return to menu",63,108)
spr(190,28,107,1,1,true)
end
end,
function(self)
self:check_for_activation()
if self.is_active and btnp(0) then
self.is_active=music(37)
slide(self,-1)
slide(player_health,-1)
slide(player_figment,-1)
show_title_screen(-1)
end
end,
frames_until_active=220,
on_activated=function(self)
slide(player_health)
slide(player_figment)
score,entities=ternary(boss_phase<=1,40,0),{title_screen,curtains,self,player_health,player_figment}
self.frames_to_death,player_health.frames_to_death,player_figment.frames_to_death=100,100,100
if boss_phase<=1 then
timer_seconds=0
end
sfx(9,3)
start_game(boss_phase)
end
},
{
function(self)
self:draw_sprite(5,6,89,ternary(self.frames_alive<190,13,5),11,8)
end
},
{
function(self)
if self.invincibility_frames%4<2 or self.stun_frames>0 then
local facing=self.facing
local sx,sy,sh,dx,dy,flipped,c=0,0,8,3+4*facing,6,facing==0,ternary(self.teeter_frames%4<2,14,15)
if facing==2 then
sy,sh,dx=8,11,5
elseif facing==3 then
sy,sh,dx,dy=19,11,5,9
end
if self.step_frames>0 then
sx=44-11*self.step_frames
end
if self.teeter_frames>0 or self.default_counter>0 then
sx=66
if self.default_counter<=0 then
palt(c,true)
pal(29-c,self.secondary_color)
sx=44
end
if facing>1 then
dy+=13-5*facing
else
dx+=4-facing*8
end
if self.teeter_frames<3 and self.default_counter<3 then
sx=55
end
end
if self.stun_frames>0 then
sx,sy,sh,dx,dy,flipped=78,11,10,5,8,self.stun_frames%6>2
end
pal(8,self.primary_color)
pal(2,self.secondary_color)
pal(1,self.tertiary_color)
self:draw_sprite(dx,dy,sx,sy,11,sh,flipped)
end
end,
function(self)
decrement_counter_prop(self,"stun_frames")
decrement_counter_prop(self,"teeter_frames")
if self.stun_frames<0 then
self.render_layer=5
end
self:check_inputs()
if self.next_step_dir and not self.step_dir then
self:step(self.next_step_dir)
end
self.prev_col,self.prev_row=self:col(),self:row()
if self.stun_frames<=0 then
self.vx,self.vy=0,0
self:apply_step()
self:apply_velocity()
local col,row,occupant=self:col(),self:row(),get_tile_occupant(self)
if self.prev_col!=col or self.prev_row!=row then
if col!=mid(1,col,8) or row!=mid(1,row,5) then
sfx(19,3)
self:undo_step()
self.teeter_frames=11
end
if occupant or (player_reflection and (self.prev_col<5)!=(col<5)) then
if player_reflection then
player_reflection:copy_player()
if get_tile_occupant(player_reflection) then
get_tile_occupant(player_reflection):get_bumped()
end
end
self:bump()
if occupant then
occupant:get_bumped()
end
if player_reflection then
player_reflection:copy_player()
end
end
end
end
return true
end,
hurtbox_channel=1,
facing=0,
step_frames=0,
teeter_frames=0,
stun_frames=0,
primary_color=8,
secondary_color=2,
tertiary_color=0,
x=45,
y=20,
check_inputs=function(self)
for_each_dir(function(dir)
if btnp(dir) then
self:queue_step(dir)
end
end)
end,
bump=function(self)
sfx(20,2)
self:undo_step()
self.default_counter=11
freeze_and_shake_screen(0,5)
end,
undo_step=function(self)
self.x,self.y,self.step_frames,self.step_dir,self.next_step_dir=10*self.prev_col-5,8*self.prev_row-4,0
end,
queue_step=function(self,dir)
if not self:step(dir) then
self.next_step_dir=dir
end
end,
step=function(self,dir)
if not self.step_dir and self.teeter_frames<=0 and self.default_counter<=0 and self.stun_frames<=0 then
if boss_health.health<=0 and boss_phase<=0 and not boss then
sfx(29,1)
end
self.facing,self.step_dir,self.step_frames,self.next_step_dir=dir,dir,4
return true
end
end,
apply_step=function(self)
local dir,dist=self.step_dir,self.step_frames
if dir then
if dir>1 then
self.vy+=(2*dir-5)*ternary(dist>2,dist-1,dist)
else
self.vx+=2*dir*dist-dist
end
if decrement_counter_prop(self,"step_frames") then
self.step_dir=nil
if self.next_step_dir then
self:step(self.next_step_dir)
self:apply_step()
end
end
end
end,
on_hurt=function(self)
spawn_entity(28,self)
self:get_hurt()
end,
get_hurt=function(self)
if self.invincibility_frames<=0 then
sfx(17,0)
self.render_layer=11
freeze_and_shake_screen(6,10)
player_health.anim,player_health.default_counter,self.invincibility_frames,self.stun_frames,score_mult="lose",20,60,19,0
if decrement_counter_prop(player_health,"hearts") then
promises,is_paused,player_health.render_layer,player_figment={},true,16,spawn_entity(10,player.x+23,player.y+65)
music(-1)
spawn_entity(9)
player_figment:promise_sequence(
35,
{"move",63,72,60})
curtains:set_anim()
player_health:promise_sequence(
35,
function()
music(35)
end,
30,
{"move",62.5,45,60,linear,{-60,10,-40,10}})
player:die()
end
end
end
},
{
function(self)
if self.visible then
local i
for i=1,4 do
local sprite=0
if self.anim=="gain" and i==self.hearts then
sprite=mid(1,5-flr(self.default_counter/2),3)
elseif self.anim=="lose" and i==self.hearts+1 then
if self.default_counter>=15 or (self.default_counter+1)%4<2 then
sprite=6
end
elseif i<=self.hearts then
sprite=4
end
self:draw_sprite(24-8*i,3,9*sprite,30,9,7)
end
end
end,
function(self,counter_reached_zero)
if counter_reached_zero then
self.anim=nil
end
end,
x=63,
y=122,
hearts=4
},
{
function(self)
if self.visible then
rect(33,2,93,8,ternary(self.rainbow_frames>0,rainbow_color,ternary_hard_mode(8,5)))
rectfill(33,2,mid(33,32+self.health,92),8)
end
end,
function(self)
decrement_counter_prop(self,"rainbow_frames")
if self.default_counter>0 then
self.health-=1
end
end,
health=0,
rainbow_frames=0
},
{
function(self,x,y,f,f2)
if f2==10 then
sfx(8,3)
end
if f2<=10 then
f2+=3
rect(x-f2-1,y-f2,x+f2+1,y+f2,ternary(f<4,5,6))
end
end,
on_death=function(self)
freeze_and_shake_screen(0,1)
spawn_entity(15,self)
spawn_particle_burst(self,0,4,16,4)
end
},
{
function(self)
pal(7,rainbow_color)
self:draw_sprite(4,3,55,38,9,7)
end,
function(self)
if get_tile_occupant(self) then
self:die()
spawn_magic_tile(10)
end
end,
hurtbox_channel=2,
on_hurt=function(self)
freeze_and_shake_screen(2,2)
self.hurtbox_channel,self.frames_to_death,score_mult=0,6,min(score_mult+1,8)
sfx(9,3)
score+=score_mult
spawn_entity(29,self.x,self.y-7,{points=score_mult})
local health_change=ternary(boss_phase==0,12,6)
local particles=spawn_particle_burst(self,0,ternary(boss_phase>=5,15,25),16,10)
local i
for i=1,health_change do
local j=rnd_int(i,#particles)
local p=particles[j]
particles[i],particles[j],p.frames_to_death=p,particles[i],300
p:promise_sequence(
7+2*i,
{"move",8+min(boss_health.health+i,60),-58,8,ease_out},
1,
"die",
function()
sfx(10,3)
if boss_health.health<60 then
boss_health.health,boss_health.visible,boss_health.rainbow_frames=mid(0,boss_health.health+1,60),true,15
local health=boss_health.health
if boss_phase==0 then
if health==25 then
boss=spawn_entity(22)
elseif health==37 then
boss.visible=true
elseif health==60 then
boss:intro()
end
elseif health>=60 then
if boss_phase>=5 then
boss_health.health=0
elseif boss_phase==4 then
music(-1)
promises,boss_phase,boss_reflection={},5
local i
for i=1,10 do
spawn_magic_tile(20+13*i)
end
boss:promise_sequence(
"cancel_everything",
"appear",
{"reel",40},
"cancel_everything",
{"move",40,-20,15,ease_in},
20,
function()
player_reflection:poof()
player_reflection=player_reflection:die()

spawn_entity(1,40,-20):poof()
end,
"die",
120,
{curtains,"set_anim"},
90,
function()
music(47)
is_paused=true
end,
75,
function()
score+=max(0,380-timer_seconds)
dset(score_data_index,max(score,dget(score_data_index)))
if timer_seconds<=dget(time_data_index) or dget(time_data_index)==0 then
dset(time_data_index,timer_seconds)
end
spawn_entity(8):promise_sequence(
135,
function()
sfx(24,3)
end,
35,
function()
sfx(24,3)
end,
45,
function()
if score>=dget(score_data_index) or timer_seconds<=dget(time_data_index) then
sfx(9,3)
end
end)
end)
else
boss:promise_sequence(
"cancel_everything",
"appear",
{"reel",10},
10,
"set_expression",
20,
"phase_change",
spawn_magic_tile,
function()
boss_phase+=1
end,
"decide_next_action")
end
end
end
end)
end
if health_change+boss_health.health<60 and boss_phase<5 then
spawn_magic_tile(ternary(boss_phase<1,100,120)-min(self.frames_alive,20))
end
end
},
{
nil,
function(self)
local prev_col,prev_row=self:col(),self:row()
self:copy_player()
if (prev_col!=self:col() or prev_row!=self:row()) and get_tile_occupant(self) then
get_tile_occupant(self):get_bumped()
if get_tile_occupant(player) then
get_tile_occupant(player):get_bumped()
end
player:bump()
self:copy_player()
end
return true
end,
primary_color=11,
secondary_color=3,
tertiary_color=0,
init=function(self)
self:copy_player()
self:poof()
end,
on_hurt=function(self,entity)
player:get_hurt(entity)
self:copy_player()
spawn_entity(28,self)
end,
copy_player=function(self)
self.x,self.facing=80-player.x,({1,0,2,3})[player.facing+1]
copy_props(player,self,{"y","step_frames","stun_frames","teeter_frames","default_counter","invincibility_frames","frames_alive"})
end
},
{
function(self)
local sprite=flr(self.frames_alive/4)%4
if self.vx<0 then
sprite=(6-sprite)%4
end
if self.is_red then
pal(8,11)
pal(2,3)
end
self:draw_sprite(5,7,10*sprite+77,21,10,10)
end
},
{
function(self)
if self.parent.is_reflection and hard_mode then
pal(3,2)
pal(11,8)
end
self:draw_sprite(4,4,ternary(self.default_counter>0,119,ternary(self.frames_to_death>0,110,101)),71,9,8)
end,
function(self,counter_reached_zero)
if counter_reached_zero then
self.hitbox_channel=0
end
end,
bloom=function(self)
self.frames_to_death,self.default_counter,self.hitbox_channel=15,4,1
local i
for i=1,2 do
spawn_entity(21,self.x,self.y-2,{
vx=i-1.5,
vy=-1-rnd(),
friction=0.9,
gravity=0.06,
frames_to_death=10+rnd(7),
color=ternary(self.parent.is_reflection and hard_mode,self.parent.light_color,3)
})
end
end
},
{
function(self,x,y,f)
circfill(self.target_x,self.target_y-1,min(flr(f/7),4),2)
self:draw_sprite(4,5,9*ternary(f>=26,ternary(self.health<3,5,4),ternary(f>10,2,0)+flr(f/3)%2),37,9,9)
end,
health=3,
get_bumped=function(self)
if decrement_counter_prop(self,"health") then
self:die()
end
end,
on_death=function(self)
spawn_particle_burst(self,0,6,6,4)
sfx(21,1)
end
},
{
function(self)
self:draw_sprite(5,3,ternary(self.dir>1,47,58),71,11,7,self.dir==0,self.dir==2)
end,
function(self)
if self.frames_alive>1 then
self.hitbox_channel=0
end
end
},
{
function(self,x,y)
line(x,y,self.prev_x,self.prev_y,ternary(self.color==16,rainbow_color,self.color))
end,
function(self)
self.vy+=self.gravity
self.vx*=self.friction
self.vy*=self.friction
self.prev_x,self.prev_y=self.x,self.y
end,
friction=1,
gravity=0,
init=function(self)
self:update()
self:apply_velocity()
end
},
{
function(self,x,y,f)
if self.really_visible then
local expression=self.expression
self:apply_colors()
if self.visible then
self:draw_sprite(6,12,115,0,13,30)
end
if self.visible or boss_health.rainbow_frames>0 then
if boss_health.rainbow_frames>0 then
color_wash(rainbow_color)
if expression>0 and expression!=5 and boss_phase>0 then
pal(13,5)
end
expression=8
end
if expression>0 then
self:draw_sprite(5,7,11*expression-11,57,11,14,false,expression==5 and f%4<2)
end
end
pal()
self:apply_colors()
if self.visible then
if self.is_wearing_top_hat then
self:draw_sprite(6,15,102,0,13,9)
end
if self.default_counter%2>0 then
line(x,y+7,x,60,14)
end
end
end
end,
function(self)
local x,y=self.x,self.y
calc_idle_mult(self,self.frames_alive,2)
if boss_health.rainbow_frames>12 then
self.draw_offset_x+=scene_frame%2*2-1
end
end,
x=40,
y=-28,
really_visible=true,
home_x=40,
home_y=-28,
expression=4,
dark_color=14,
light_color=15,
idle_mult=0,
init=function(self)
local props,y={mirror=self,is_reflection=self.is_reflection,dark_color=self.dark_color,light_color=self.light_color,is_boss_generated=self.is_boss_generated},self.y+5
self.left_hand=spawn_entity(24,self.x-18,y,props)
self.coins,props.is_right_hand,props.dir={},true,1
self.right_hand=spawn_entity(24,self.x+18,y,props)
end,
on_death=function(self)
self.left_hand:die()
self.right_hand:die()
end,
apply_colors=function(self)
pal(2,ternary(self.is_cracked,6,7))
if self.is_reflection then
color_wash(self.dark_color)
local c
for c in all({8,7,6,2}) do
pal(c,self.light_color)
end
end
end,
intro=function(self)
music(ternary(boss_phase>=1 or skip_phase_change_animations,25,8))
self:promise_sequence(
"phase_change",
function()
spawn_magic_tile(130)
scene_frame,player_health.visible=0,true
boss_phase+=1
end,
"decide_next_action")
end,
decide_next_action=function(self)
return self:promise_sequence(
function()
if boss_phase==1 then
if hard_mode then
return self:promise_sequence(
"return_to_ready_position",
"throw_cards",
"return_to_ready_position",
"shoot_lasers",
10,
"return_to_ready_position",
"despawn_coins",
"throw_coins")
else
return self:promise_sequence(
"return_to_ready_position",
15,
{self.left_hand,"throw_cards"},
{self,"return_to_ready_position"},
10,
{self.right_hand,"throw_cards"},
{self,"return_to_ready_position"},
25,
"shoot_lasers")
end
elseif boss_phase==2 or boss_phase==3 then
return self:promise_sequence(
function()
if hard_mode then
spawn_reflection(nil,
{"conjure_flowers",40},
"die")
end
end,
15,
{"conjure_flowers",10},
30,
"return_to_ready_position",
"throw_cards",
function()
if hard_mode then
local reflection=spawn_entity(23)
reflection:move(20,0,15,ease_in,nil,true)
reflection:promise_sequence(
"throw_cards",
13,
"die")
sfx(30,2)
end
end,
"return_to_ready_position",
ternary_hard_mode(70,0),
{"shoot_lasers",not hard_mode},
"return_to_ready_position",
"despawn_coins",
function()
if hard_mode then
spawn_reflection(ternary(player and player.x<40,20,-20),
10,
"throw_hat",
30,
"die")
end
end,
"throw_coins",
"return_to_ready_position")
elseif boss_phase==4 then
if hard_mode then
local n,m=0,0
return self:promise_sequence(
"return_to_ready_position",
10,
{self.left_hand,"disappear"},
{self.right_hand,"disappear"})
:and_then_repeat(5,
function()
spawn_reflection(40-20*n,
8*n,
{"throw_hat",nil,1},
32-8*n,
"reform")
n=(n+1)%5
end)
:and_then_sequence(
{self,"disappear"},
145,
"appear",
30)
:and_then_repeat(4,
10,
"disappear",
{"set_expression",5},
function()
m=m%4+1
local col=rnd_int(0,7)
local i
for i=1,3 do
col=(col+2)%8
spawn_reflection(10*col-35,
7,
{"shoot_laser",m==4},
"reform")
end
if m==4 then
return self:promise_sequence(
40,
function()
spawn_reflection(-50,
{"set_expression",1},
"appear",
25,
"throw_cards",
60,
"reform")
end,
177)
else
return 66
end
end,
{"set_expression",1},
"appear")
else
return self:promise_sequence(
function()
boss_reflection:promise_sequence(
75,
"conjure_flowers",
"return_to_ready_position")
end,
"conjure_flowers",
"return_to_ready_position",
20,
"conjure_flowers",
"return_to_ready_position",
function()
boss_reflection:promise_sequence(
84,
"throw_cards",
20,
"return_to_ready_position")
end,
"throw_cards",
"return_to_ready_position",
100,
function()
boss_reflection:promise_sequence(
30,
"shoot_lasers",
"return_to_ready_position")
end,
"shoot_lasers",
"return_to_ready_position",
50,
function()
boss_reflection:promise_sequence(
"despawn_coins",
17,
{"throw_coins",player_reflection,3},
"return_to_ready_position")
end,
"despawn_coins",
{"throw_coins",nil,3},
"return_to_ready_position",
100)
end
end
end,
function()
self:decide_next_action()
end)
end,
appear=function(self)
self.really_visible=true
self.left_hand:appear()
self.right_hand:appear()
end,
disappear=function(self)
self.really_visible=false
self.left_hand:disappear()
self.right_hand:disappear()
end,
phase_change=function(self)
next_reflection_color=1
local lh,rh=self.left_hand,self.right_hand
if skip_phase_change_animations then
if boss_phase==0 then
self.is_wearing_top_hat=true
elseif boss_phase==2 then
player_reflection=spawn_entity(16)
elseif boss_phase==3 and not hard_mode then
boss_reflection=spawn_entity(23)
self.home_x+=20
end
return self:return_to_ready_position()
elseif boss_phase==0 then
return self:promise_sequence(
66,
{lh,"appear"},
20)
:and_then_repeat(2,
{"set_pose",5},
3,
{"set_pose",4},
3)
:and_then_sequence(
20,
{rh,"appear"},
10,
{"move",-16,8,10,ease_out,{10,0,10,5},true},
{"set_pose",2},
{self,"set_expression"},
33,
{"set_expression",6},
28,
"set_expression",
34,
{"set_expression",1},
5,
function()
lh:promise_sequence(
9,
{"set_pose",5},
4,
{"set_pose",4})
lh:promise_sequence(
{"move",self.x+5*lh.dir,self.y-3,10,ease_out,{0,-10,10*lh.dir,-2}},
2,
{"move",lh.x,lh.y,10,ease_in,{10*lh.dir,-2,0,-10}})
end,
10,
function()
self.is_wearing_top_hat=true
end,
{"poof",0,-10},
35)
elseif boss_phase==1 then
if hard_mode then
return self:promise_sequence(
{"return_to_ready_position",2},
30,
"set_all_idle",
10,
"pound",
"pound",
"pound",
function()
local i
for i=1,5 do
spawn_entity(23):promise_sequence(
{"move",0,0,40,linear,{40*cos(i/5),40*sin(i/5),40*cos((i+1)/5),40*sin((i+1)/5)},true},
2,
"die")
end
sfx(31,1)
end,
75)
else
return self:promise_sequence(
{"return_to_ready_position",2},
30,
"set_all_idle",
10,
"pound",
"pound",
"pound",
{"set_expression",1},
function()
sfx(16,3)
lh.is_holding_bouquet=true
end,
{rh,"set_pose"},
{"move",20,-10,15,ease_in,{-20,-10,-5,0},true},
35,
{lh,"move",2,-9,20,ease_in,nil,true},
{self,"set_expression",3},
30,
{"set_expression",1},
15,
function()
lh:promise_sequence(
10,
"set_pose",
function()
sfx(28,3)
lh.is_holding_bouquet=false
end,
{"move",-22,6,20,ease_in,nil,true})
end,
{rh,"move",0,7,20,ease_out_in,{-35,-20,-25,0},true},
15)
end
elseif boss_phase==2 then
return self:promise_sequence(
{"return_to_ready_position",2},
"cast_reflection",
"return_to_ready_position",
60)
elseif boss_phase==3 and not hard_mode then
return self:promise_sequence(
{"return_to_ready_position",2},
{"cast_reflection",true},
function()
boss_reflection:return_to_ready_position()
end,
"return_to_ready_position",
60)
end
end,
for_each=function(self,fn,skip_self)
fn(self.left_hand)
fn(self.right_hand)
if not skip_self then
fn(self)
end
end,
cancel_everything=function(self)
self:for_each(function(entity)
entity.is_holding_wand=entity:cancel_promises()
entity:cancel_move()
end)
self.default_counter=0
foreach(entities,function(entity)
if entity.is_boss_generated then
entity:cancel_promises()
entity.finished=true
end
end)
end,
pound=function(self)
self.left_hand:pound()
return self.right_hand:pound()
end,
reel=function(self,times)
self:for_each(function(entity)
entity:appear()
entity:set_pose()
end,spawn_entity(26,10*rnd_int(3,6)-5,4))
self.is_cracked=boss_phase>=3
return self:promise_sequence(
{"set_expression",8},
"set_all_idle")
:and_then_repeat(times,
{"for_each",function(entity)
freeze_and_shake_screen(0,2)
entity.x,entity.y=mid(10,entity.x,70),mid(-40,entity.y,-20)
entity:poof(rnd_int(-10,10),rnd_int(-10,10),12)
entity:move(rnd_int(-7,7),rnd_int(-7,7),6,ease_out,nil,true)
end},
5)
end,
throw_hat=function(self)
return self:promise_sequence(
"set_all_idle",
{self.left_hand,"disappear"},
{self.right_hand,"appear"},
{"move",self.x+5,self.y-6,15,linear},
{"set_pose",1},
30,
"set_pose",
function()
sfx(26,2)
self.is_wearing_top_hat=false
spawn_entity(2,self.x,-32,{parent=self})
end,
{"move",14,5,3,ease_in,nil,true},
{self,30})
end,
conjure_flowers=function(self,extra_delay)
if hard_mode or not self.is_reflection then
conjure_flowers_counter=1+(conjure_flowers_counter+rnd_int(0,2))%8
end
local flowers={}
self.left_hand:move_to_temple()
return self:promise_sequence(
"set_all_idle",
{self.right_hand,"move_to_temple"},
{self,"set_expression",2},
function()
local promise,locations,n,i=self:promise(),{},0
function do_a_math(m)
return ternary((n+({1,2,3,5,7,9,10,11})[conjure_flowers_counter])%m>0,1,0)
end
for i=0,39 do
if i==n then
n+=mid(1,do_a_math(2)+do_a_math(3)+do_a_math(5),3)
if not self.is_reflection then
add(locations,{x=i%8*10+5,y=8*flr(i/8)+4})
end
elseif self.is_reflection then
add(locations,{x=i%8*10+5,y=8*flr(i/8)+4})
end
end
for i=1,#locations do
local j=rnd_int(i,#locations)
locations[i],locations[j],promise=locations[j],locations[i],promise:and_then_sequence(
1,
function()
sfx(15,1)
add(flowers,spawn_entity(18,locations[i],nil,{parent=self}))
end)
end
end,
(extra_delay or 0)+ternary_hard_mode(50,65),
function()
sfx(16,1)
local flower
for flower in all(flowers) do
flower:bloom()
end
end,
{self.left_hand,"set_pose",5},
{self.right_hand,"set_pose",5},
{self,"set_expression",3},
31)
end,
cast_reflection=function(self,upgraded_version)
local lh,rh,i=self.left_hand,self.right_hand
return self:promise_sequence(
"set_all_idle",
{lh,"move",23,14,20,ease_in,nil,true},
{"set_pose",1})
:and_then_repeat(2,
{rh,"move",0,0,40,linear,{18,6,-18,6},true})
:and_then_sequence(
function()
if upgraded_version then
rh:promise_sequence(
{"set_pose",1},
function()
rh.is_holding_wand=true
end,
{"poof",-10},
30,
"flourish_wand")
end
end,
{self,"set_expression",1},
function()
lh.is_holding_wand=true
end,
{lh,"poof",10},
30,
{lh,"flourish_wand"},
{self,"set_expression",3},
5,
function()
if upgraded_version then
boss_reflection=spawn_entity(23)
self.home_x+=20
else
player_reflection=spawn_entity(16)
end
end,
55)
end,
throw_cards=function(self,hand)
self.left_hand:throw_cards()
return self.right_hand:throw_cards()
end,
throw_coins=function(self,target,num_coins)
target=target or player
return self:promise_sequence(
"set_all_idle",
{self.right_hand,"move_to_temple"})
:and_then_repeat(num_coins or 4,
{self,"set_expression",7},
{self.right_hand,"set_pose",1},
ternary_hard_mode(7,15),
function()
local target_x,target_y=10*target:col()-5,8*target:row()-4
sfx(21,1)
local coin=spawn_entity(19,self.x+13,self.y-6,{target_x=target_x,target_y=target_y})
add(self.coins,coin)
coin:promise_sequence(
{"move",target_x+2,target_y,25,ease_out,{20,-30,10,-60}},
2,
function()
sfx(22,1)
coin.occupies_tile,coin.hitbox_channel=true,5
freeze_and_shake_screen(2,2)
if hard_mode then
for_each_dir(function(dir,dx,dy)
spawn_entity(20,mid(5,target_x+10*dx,75),mid(4,target_y+8*dy,36),{dir=dir})
end)
end
end,
{"move",-2,0,8,linear,{0,-4,0,-4},true},
function()
coin.hitbox_channel,coin.hurtbox_channel=1,4
end)
end,
{"set_pose",4},
{self,"set_expression",3},
20)
end,
shoot_lasers=function(self,sweep)
self.left_hand:disappear()
self.right_hand:disappear()
local col,num_reflections=rnd_int(0,7),2
return self:promise_sequence(
"set_expression",
"set_all_idle"):and_then_repeat(3,
function()
col=(col+rnd_int(2,ternary_hard_mode(3,6)))%8
return self:promise_sequence(
{"move",10*col+5,-20,ternary_hard_mode(10,15),ease_in,{0,-10,0,-10}},
1,
function()
if sweep then
local dir=2
if col>5 or (rnd()<0.5 and col>1) then
dir=-2
end
col+=dir
self:move(10*dir,0,40,linear,nil,true)
end
end,
"shoot_laser",
function()
if hard_mode and boss_phase>1 and num_reflections>0 then
spawn_entity(23):promise():and_then_repeat(num_reflections,
10,
"shoot_laser")
:and_then(
"die")
num_reflections-=1
end
end)
end)
end,
shoot_laser=function(self,long_duration)
return self:promise_sequence(
ternary_hard_mode(2,12),
function()
sfx(ternary(long_duration,7,14),1)
self.default_counter=ternary(long_duration,173,31)
end,
12,
{"set_expression",0},
function()
freeze_and_shake_screen(0,4)
local laser=spawn_entity(25,self,nil,{parent=self})
if long_duration then
laser.frames_to_death=150
end
end,
ternary(long_duration,166,16),
"set_expression",
5)
end,
return_to_ready_position=function(self,expression)--,expression,held_hand)
local lh,rh,home_x,home_y=self.left_hand,self.right_hand,self.home_x,self.home_y
lh.is_holding_wand,rh.is_holding_wand=false
return self:promise_sequence(
{lh,"set_pose"},
{rh,"set_pose"},
{self,"set_all_idle",true},
{"set_expression",expression or 1},
function()
self:move(home_x,home_y,15,ease_in)
lh:move(home_x-18,home_y+5,15,ease_in,{-10,-10,-20,0})
lh:appear()
rh:move(home_x+18,home_y+5,15,ease_in,{10,-10,20,0})
rh:appear()
end,
ternary_hard_mode(15,25))
end,
despawn_coins=function(self)
local coin
for coin in all(self.coins) do
coin:die()
end
self.coins={}
return 10
end,
set_all_idle=function(self,idle)
self:for_each(function(entity)
entity.is_idle=idle
end)
end,
set_expression=function(self,expression)
self.expression=expression or 5
end
},
{
visible=true,
expression=1,
is_wearing_top_hat=true,
home_x=20,
is_reflection=true,
init=function(self)
local color_index=3
if hard_mode then
color_index,next_reflection_color=next_reflection_color,next_reflection_color%5+1
end
self.dark_color,self.light_color=({2,1,3,9,8})[color_index],({13,12,11,10,14})[color_index]
boss.init(self)
local props={"pose","x","y","visible"}
copy_props(boss,self,{"x","y","expression"})
copy_props(boss.left_hand,self.left_hand,props)
copy_props(boss.right_hand,self.right_hand,props)
end,
reform=function(self)
self:move(boss.x,boss.y,10,ease_out)
self.left_hand:move(boss.left_hand.x,boss.left_hand.y,10,ease_out)
self.right_hand:move(boss.right_hand.x,boss.right_hand.y,10,ease_out)
return self:promise_sequence(10,"die")
end
},
{
function(self)
if self.visible then
if self.is_holding_bouquet then
self:draw_sprite(1,12,110,71,9,16)
end
if self.is_reflection then
color_wash(self.dark_color)
pal(7,self.light_color)
pal(6,self.light_color)
end
local is_right_hand=self.is_right_hand
self:draw_sprite(ternary(is_right_hand,7,4),8,12*self.pose-12,46,12,11,is_right_hand)
if self.is_holding_wand then
if self.pose==1 then
self:draw_sprite(ternary(is_right_hand,10,-4),8,91,57,7,13,is_right_hand)
else
self:draw_sprite(ternary(is_right_hand,3,2),16,98,57,7,13,is_right_hand)
end
end
end
end,
function(self)
local m=self.mirror
self.render_layer=ternary(self.is_reflection,6,ternary(self.is_right_hand,9,8))
calc_idle_mult(self,boss.frames_alive+ternary(self.is_right_hand,9,4),4)
self:apply_velocity()
return true
end,
pose=3,
dir=-1,
idle_mult=0,
throw_cards=function(self)
local is_first=self.is_right_hand!=self.is_reflection
local dir,promise=self.dir,self:promise_sequence(
ternary(is_first,0,ternary_hard_mode(13,19)),
function()
self.is_idle=false
end)
local r
for r=ternary(is_first,0,1),4,2 do
promise=promise:and_then_sequence(
"set_pose",
{"move",40+52*dir,8*(r%5)+4,18,ease_out_in,{10*dir,-10,10*dir,10}},
{"set_pose",2},
ternary_hard_mode(0,12),
{"set_pose",1},
function()
sfx(13,2)
spawn_entity(17,self.x-7*dir,self.y,{
vx=-1.5*dir,
is_red=rnd()<0.5
})
end,
10)
end
return promise
end,
flourish_wand=function(self)
return self:promise_sequence(
{"move",40+20*self.dir,-30,12,ease_out,{-20,20,0,20}},
{"set_pose",6},
function()
sfx(23,1)
spawn_particle_burst(self,20,20,3,10)
freeze_and_shake_screen(0,20)
end)
end,
appear=function(self)
if not self.visible then
self.visible=true
return self:poof()
end
end,
disappear=function(self)
if self.visible then
self.visible=false
self:poof()
end
end,
pound=function(self)
local m,d=self.mirror,20*self.dir
return self:promise_sequence(
{"set_pose",2},
{"move",m.x+4*self.dir,m.y+20,15,ease_out,{d,0,d,0}},
function()
sfx(12,2)
freeze_and_shake_screen(0,2)
end,
1)
end,
move_to_temple=function(self)
return self:promise_sequence(
{"set_pose",1},
{"move",self.mirror.x+13*self.dir,self.mirror.y,20})
end,
set_pose=function(self,pose)
self.pose=pose or 3
end
},
{
function(self,x,y)
pal(14,self.parent.dark_color)
pal(15,self.parent.light_color)
sspr(117,30,11,1,x-4.5,y+4.5,11,100)
end,
function(self)
self.x=self.parent.x
end,
is_hitting=function(self,entity)
return self:col()==entity:col()
end
},
{
function(self,x,y,f,f2)
if f2>30 or f2%4>1 then
self:draw_sprite(4,5,36,30,9,7)
end
end,
hurtbox_channel=2,
on_hurt=function(self)
sfx(18,0)
if player_health.hearts<4 then
player_health.hearts+=1
player_health.anim,player_health.default_counter="gain",10
end
spawn_particle_burst(self,0,6,8,4)
self:die()
end
},
{
function(self)
self:draw_sprite(8,8,64+16*flr(self.frames_alive/3),31,16,14)
end
},
{
function(self)
self:draw_sprite(11,16,105,45,23,26)
end
},
{
function(self)
print_centered(self.points.."00",self.x+1,self.y,rainbow_color)
end,
vy=-0.5
}
}

-->8
function _init()
music(37)
starting_phase,title_screen,curtains=max(starting_phase,ternary(dget(0)>0,1,0)),spawn_entity(6),spawn_entity(4)
entities={title_screen,curtains}
if skip_title_screen then
title_screen.x,curtains.anim,title_screen.is_active=-200,"open"
title_screen:on_activated()
end
end

function _update()
if freeze_frames>0 then
freeze_frames=decrement_counter(freeze_frames)
if player then
player:check_inputs()
end
else
if scene_frame%30==0 and not is_paused and boss_phase>0 then
timer_seconds=min(5999,timer_seconds+1)
end
screen_shake_frames,scene_frame=decrement_counter(screen_shake_frames),increment_counter(scene_frame)
rainbow_color=flr(scene_frame/4)%6+8
if rainbow_color==13 then
rainbow_color=14
end
local num_promises=#promises
local i
for i=1,num_promises do
if promises[i] and decrement_counter_prop(promises[i],"frames_to_finish") then
promises[i]:finish()
end
end
filter_out_finished(promises)
local num_entities=#entities
for i=1,min(#entities,num_entities) do
local entity=entities[i]
if entity and (not is_paused or entity.is_pause_immune) then
if not entity:update(decrement_counter_prop(entity,"default_counter")) then
entity:apply_velocity()
end
decrement_counter_prop(entity,"invincibility_frames")
entity.frames_alive=increment_counter(entity.frames_alive)
if decrement_counter_prop(entity,"frames_to_death") then
entity:die()
end
end
end
if not is_paused then
local i,j
for i=1,min(#entities,num_entities) do
for j=1,min(#entities,num_entities) do
local entity,entity2=entities[i],entities[j]
if i!=j and band(entity.hitbox_channel,entity2.hurtbox_channel)>0 and entity:is_hitting(entity2) and entity2.invincibility_frames<=0 then
entity2:on_hurt(entity)
end
end
end
end
filter_out_finished(entities)
local i
for i=1,#entities do
local j=i
while j>1 and is_rendered_on_top_of(entities[j-1],entities[j]) do
entities[j],entities[j-1]=entities[j-1],entities[j]
j-=1
end
end
end
end

function _draw()
local shake_x,i,score_text=0,0,score.."00"
cls()
if freeze_frames<=0 and screen_shake_frames>0 then
shake_x=ternary(boss_phase==5,1,ceil(screen_shake_frames/3))*(scene_frame%2*2-1)
end
camera(shake_x-1,-1)
map(0,0,0,0,16,16)
camera(shake_x-23,-65)
foreach(entities,function(entity)
if entity.render_layer>=13 then
camera(shake_x)
end
if entity.is_curtains then
if score_mult>0 then
draw_sprite(6,2,69,71,11,7)
print(score_mult,8,3,0)
end
if timer_seconds>0 then
print(format_timer(timer_seconds),7,120,1)
end
if score>0 then
print(score_text,121-4*#score_text,3,1)
end
end
entity:draw2()
end)
end

-->8
function spawn_entity(class_id,x,y,args,skip_init)
if type(x)=="table" then
x,y=x.x,x.y
end
local k,v,entity
local the_class,sid=entity_classes[class_id],6*class_id-6
local extends=fget(sid+3)
if extends>0 then
entity=spawn_entity(extends,x,y,args,true)
else
entity={
default_counter=0,
frames_alive=0,
hurtbox_channel=0,
invincibility_frames=0,
x=x or 0,
y=y or 0,
vx=0,
vy=0,
init=noop,
update=noop,
draw=noop,
draw2=function(self)
self:draw(self.x,self.y,self.frames_alive,self.frames_to_death)
pal()
end,
draw_offset_x=0,
draw_offset_y=0,
draw_sprite=function(self,dx,dy,...)
draw_sprite(self.x+self.draw_offset_x-dx,self.y+self.draw_offset_y-dy,...)
end,
die=function(self)
if not self.finished then
self:on_death()
self.finished=true
end
end,
on_death=noop,
col=function(self)
return 1+flr(self.x/10)
end,
row=function(self)
return 1+flr(self.y/8)
end,
is_hitting=function(self,entity)
return self:row()==entity:row() and self:col()==entity:col()
end,
on_hurt=function(self)
self:die()
end,
promise=function(self,...)
return make_promise(self):start():and_then(...)
end,
promise_sequence=function(self,...)
return make_promise(self):start():and_then_sequence(...)
end,
cancel_promises=function(self)
foreach(promises,function(promise)
if promise.ctx==self then
promise:cancel()
end
end)
end,
poof=function(self,dx,dy,poof_sound)
sfx(poof_sound or 11,2)
spawn_entity(27,self.x+(dx or 0),self.y+(dy or 0))
return 12
end,
apply_velocity=function(self)
local move=self.movement
if move then
move.frames+=1
local t=move.easing(move.frames/move.duration)
local i
self.vx,self.vy=-self.x,-self.y
for i=0,3 do
local m=ternary(i%3>0,3,1)*t^i*(1-t)^(3-i)
self.vx+=m*move.bezier[2*i+1]
self.vy+=m*move.bezier[2*i+2]
end
if move.frames>=move.duration then
self.x,self.y,self.vx,self.vy,self.movement=move.final_x,move.final_y,0,0
end
end
self.x+=self.vx
self.y+=self.vy
end,
move=function(self,x,y,dur,easing,anchors,is_relative)
local start_x,start_y,end_x,end_y=self.x,self.y,x,y
if is_relative then
end_x+=start_x
end_y+=start_y
end
local dx,dy=end_x-start_x,end_y-start_y
anchors=anchors or {dx/4,dy/4,-dx/4,-dy/4}
self.movement={
frames=0,
duration=dur,
final_x=end_x,
final_y=end_y,
easing=easing or linear,
bezier={start_x,start_y,
start_x+anchors[1],start_y+anchors[2],
end_x+anchors[3],end_y+anchors[4],
end_x,end_y}
}
return dur-1
end,
cancel_move=function(self)
self.vx,self,vy,self.movement=0,0
end
}
end
entity.render_layer,entity.frames_to_death,entity.is_boss_generated,entity.is_pause_immune,entity.hitbox_channel=fget(sid),fget(sid+1),fget(sid+2,0),fget(sid+2,1),fget(sid+4)
for k,v in pairs(the_class) do
entity[k]=v
end
entity.draw,entity.update=the_class[1] or entity.draw,the_class[2] or entity.update
for k,v in pairs(args or {}) do
entity[k]=v
end
if not skip_init then
entity:init()
add(entities,entity)
end
return entity
end

-->8

function spawn_particle_burst(source,dy,num_particles,color,speed)
local particles={}
local i
for i=1,num_particles do
local angle,particle_speed=(i+rnd(0.7))/num_particles,speed*(0.5+rnd(0.7))
add(particles,spawn_entity(21,source.x,source.y-dy,{
vx=particle_speed*cos(angle),
vy=particle_speed*sin(angle)-speed/2,
color=color,
gravity=0.1,
friction=0.75,
frames_to_death=rnd_int(13,19)
}))
end
return particles
end

function spawn_magic_tile(frames_to_death)
if boss_health.health>=60 then
boss_health.default_counter=61
end
spawn_entity(14,10*rnd_int(1,8)-5,8*rnd_int(1,5)-4,{
frames_to_death=frames_to_death or 100
})
end

function slide(entity,dir)
dir=dir or 1
entity:move(-dir*129,0,100,linear,{dir*70,0,0,0},true)
return entity
end

function calc_idle_mult(entity,f,n)
entity.idle_mult=mid(0,entity.idle_mult+ternary(entity.is_idle,0.05,-0.05),1)
entity.draw_offset_x,entity.draw_offset_y=entity.idle_mult*3*sin(f/64),entity.idle_mult*n*sin(f/32)
end

function copy_props(source,target,props)
local p
for p in all(props) do
target[p]=source[p]
end
end

function make_promise(ctx,fn,...)
local args={...}
return {
ctx=ctx,
and_thens={},
frames_to_finish=0,
start=function(self)
if not self.started and not self.canceled then
self.started=true
local f=fn
if type(fn)=="function" then
f=fn(unpack(args))
elseif type(fn)=="string" then
f=self.ctx[fn](self.ctx,unpack(args))
end
if type(f)=="table" then
f:and_then(self,"finish")
elseif f and f>0 then
self.frames_to_finish=f
add(promises,self)
else
self:finish()
end
end
return self
end,
finish=function(self)
if not self.finished then
self.finished=true
foreach(self.and_thens,function(promise)
promise:start()
end)
end
end,
cancel=function(self)
if not self.canceled then
self.canceled,self.finished=true,true
if self.parent_promise then
self.parent_promise:cancel()
end
foreach(self.and_thens,function(promise)
promise:cancel()
end)
end
end,
and_then=function(self,ctx,...)
local promise
if type(ctx)=="table" then
promise=make_promise(ctx,...)
else
promise=make_promise(self.ctx,ctx,...)
end
promise.parent_promise=self
if self.canceled then
promise:cancel()
elseif self.finished then
promise:start()
else
add(self.and_thens,promise)
end
return promise
end,
and_then_sequence=function(self,args,...)
local promises={...}
local promise
if type(args)=="table" then
promise=self:and_then(unpack(args))
else
promise=self:and_then(args)
end
if #promises>0 then
return promise:and_then_sequence(unpack(promises))
end
return promise
end,
and_then_repeat=function(self,times,...)
local promise=self
local i
for i=1,times do
promise=promise:and_then_sequence(...)
end
return promise
end
}
end

function start_game(phase)
curtains:promise_sequence(
ternary(skip_title_screen,0,35),
{"set_anim","open"},
function()
local n=30
if skip_title_screen then
curtains.default_counter,n,title_screen.frames_until_active,hard_mode=0,0,0,start_on_hard_mode
end
score_mult,boss_phase,is_paused=0,max(0,phase-1)
player,player_health,boss_health,player_reflection,player_figment,boss,boss_reflection=spawn_entity(11),spawn_entity(12),spawn_entity(13)
if phase>0 then
boss=spawn_entity(22)
boss.visible,boss_health.visible=true,true
boss:promise_sequence(n,"intro")
boss.is_wearing_top_hat=phase>1
if phase>3 then
player_reflection=spawn_entity(16)
end
else
spawn_magic_tile(150+n)
end
end)
end

function show_title_screen(dir)
title_screen.x=ternary(dir==-1,-66,192)
slide(title_screen,dir)
starting_phase,title_screen.frames_until_active,score_data_index,time_data_index=1,115,0,1
end

function spawn_reflection(dx,...)
local reflection,params=spawn_entity(23),{dx or 20*rnd_dir(),0,15,ease_in,nil,true}
reflection.left_hand:move(unpack(params))
reflection.right_hand:move(unpack(params))
reflection:promise_sequence({"move",unpack(params)},1,...)
sfx(30,2)
end

function format_timer(seconds)
return flr(seconds/60)..ternary(seconds%60<10,":0",":")..seconds%60
end

function for_each_dir(fn)
fn(0,-1,0)
fn(1,1,0)
fn(2,0,-1)
fn(3,0,1)
end

function print_centered(text,x,...)
print(text,x-2*#text,...)
end

function is_rendered_on_top_of(a,b)
return ternary(a.render_layer==b.render_layer,a.y>b.y,a.render_layer>b.render_layer)
end

function draw_sprite(x,y,sx,sy,sw,sh,...)
sspr(sx,sy,sw,sh,x+0.5,y+0.5,sw,sh,...)
end

function color_wash(c)
local i
for i=1,15 do
pal(i,c)
end
end

function get_tile_occupant(entity)
local entity2
for entity2 in all(entities) do
if entity2.occupies_tile and entity2:col()==entity:col() and entity2:row()==entity:row() then
return entity2
end
end
end

function linear(percent)
return percent
end

function ease_in(percent)
return 1-ease_out(1-percent)
end

function ease_out(percent)
return percent^2
end

function ease_out_in(percent)
return ternary(percent<0.5,ease_out(2*percent),1+ease_in(2*percent-1))/2
end

function freeze_and_shake_screen(f,s)
freeze_frames,screen_shake_frames=max(f,freeze_frames),max(s,screen_shake_frames)
end

function ternary(condition,if_true,if_false)
return condition and if_true or if_false
end

function ternary_hard_mode(...)
return ternary(hard_mode,...)
end

function unpack(list,from,to)
from,to=from or 1,to or #list
if from<=to then
return list[from],unpack(list,from+1,to)
end
end

function rnd_int(min_val,max_val)
return flr(min_val+rnd(1+max_val-min_val))
end

function rnd_dir()
return 2*rnd_int(0,1)-1
end

function increment_counter(n)
return n+ternary(n>32000,-12000,1)
end

function decrement_counter(n)
return max(0,n-1)
end

function decrement_counter_prop(obj,k)
if obj[k]>0 then
obj[k]=decrement_counter(obj[k])
return obj[k]<=0
end
end

function filter_out_finished(list)
local item
for item in all(list) do
if item.finished then
del(list,item)
end
end
end

__gfx__
00000888880088000000000000008888000000888880000f0088000000000000000000008880022200000000010000002222220008888800000000000f000000
00008888888888888888000000088888800008888888000e28888800000000000000000088800222000000000000000022222207688888800000000090f00000
00008888181888811118180000888118100008888181000088888800008118888000000881800222000000000000000022222207700888880000000090f00000
00008288181822211118180082288118100002888181000288181880888111118800022881800222000000000000000022222200008888888000009094f09000
00008888888888888888880008888888800008888888002288181880882288888800000888800222000000000000000022222200888888888800094499944900
00002288888228222200000000228822800002288828000228888802288888822000000288800222000000000000000000002208888888888800009977799000
00002222222222200000000002222222000022222222000022888202222222000000000222200222000000000000000000002277888888888770097777777900
00000200020020000000000000000020000000000020000002000fe00000200000000020002002221111111110000000000022777777777777709777777777f0
000888880000000080000000088888000000888880000008888800000000000000000000000002222222222220000000000022076666666667009777777777f0
00888888800000088800000008888800000888888800f088888880f000000000000000000000022222222222200088888000007777777777700977777777777f
0088888880000008880000008888888000088888880002888888820020000000200200000002022222222222200888888800077762222267770977777777777f
00288888200000088800000088888880000288888200e082222280e0288888882008288888280200008000000088118118807762222222226779777777777779
00888888800000888880000028888820000888888800002222222000288888882008888888880200008080000288888888820776222222267709777777777779
00822222800000288820000028222820000822222800002222222000822222228002222222220200088888000000888880000077776267777009777777777779
00222222200000288820000022222220000222222200000222220000222222222000022222000220888888800008888888000088777777788009777777777779
00020002000000822280000022222220000000020000000020000000022222220000020002000202888811802028118118200008888888880000977777777790
00000000000002222222000000022200000000000000000000000000000000000000000000000208881811820002888882000000888888800000977777777790
00000000000002222222000000002000000000000000000000000000000000000000000000000200088888880008888888000000022222000000047777777400
000000000000002000200000000020000000000000000000000000000000000000000000000002028888880000028888820000000088800000009f49777949f0
00000000000000888880000000000000000000000000000000000000000000000000000000000200222222200002222222000000007760000000944999994490
00000000000008888888000000080000000000000000000000000000000000000000000000000200020002000000200020000000000700000000099494949900
00000000000008818188000000880800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094900000
00088888000000818180000008888800000088888000000000000000000888000000000000000000777777700670000000002226600760000000000099900000
00888888800000818120000088181880000888888800000888880000008181800000000000000000666666606770000000028888760762882000000009000000
00881818800000818120000088181820000881818800f088888880f0008181800000000000000000022222006880006700288888770762888200000009000000
00281818200000218120000082181820000881818200028888888200228181820020088888002000088888002882826700888220000762888820000009000000
00888888800000228880000022888880000828888800e088888880e0288181822002888888820000022888002882826700888880000762828820000099f00000
00288888200000022200000028888880000288888800008818188000888181882008811811880077888882002888826700222220000762828820000099f00000
00222222200000022200000022222220000222222200008818188000888181888008888888880067888820000288826706666666000760008860000049900000
00020002000000002000000002000000000020000000000888880000002222220000000000000006622200000028826707777777000000007760000004000000
000555000000555000080877070070877080000877000ccc222ccc008755700222222222222220000000000000000067000000000000000076000efefefefefe
005000500005000500008778800008778800008778800cc2ccc2cc08700788020000000000000000000000000000000000007770000000000000070000000000
050000050050000050078787780078787780078787780cccccc2cc78780077820000000000000000000077700000000000007770000000000000000007000000
050000050057878750077878770077878770077878770ccccc2ccc77800787720000000000000000000777700000000000070000770000000000000000000007
050000050057787850087787870087787870087787870cccc2cccc87780078720000000000000000000777007700000000000000770007770070000000000000
005000500005877500008877800008877800008877800ccccccccc08800778020000077077700000000000007700777000770000000007770000000000000000
000555000000555000070778080080778070000778000cccc2cccc00775580020000077777770000007700000000777700770000000070000000000000000000
00000000000000000000000000000076000000007000000000000022222222220000777777770000007770000077077700000000007700000000000000070000
000000000000000000000000000000607000000767000000c7cc0025775557750000777777770000007770077770000000007000777700000000000000000000
0000000000007000000700000006070706707067d76070cc767cc027117171170007777777777000000000777777000000000000777700000000000007000007
0076000000006670007607000007607670606776767767c67d76c727155555170007777777777000000000777777000000000070077700777000000000000000
00007600000766000000760700060767067076676766767767677625751115750007777770777000007700077777077077700000000000770000000000000000
00000000000007000000007607076070706066d767d6676676766725755555750000777700000000777770000000077077700000000007000000000000000000
00000000000000000000000076000706000060d676d066cd767dc625171117150000777000000000777770077000077000707077000000000000000000000000
000000000000000000000000000000670000000666000ccc676ccc25575557550000000000000000077000077000000000000000000000000000000000000000
00000000000000000000000000000000000000006000000cc6cc0022222222222222222222222222222222222220f00f00f00000000000000000000000000a00
00000000000000000000000000000000000000770000000000000070000007700000000022222222222222222220f0f0ff00000000000000000000000000a000
000000000000000000000000000077000000007770000000000007700000077007700000222222222222222222200f00f0000000000000000000000a0000a000
00000000000000000000000000007700000000077000000000000770000007770770000011111111222222222220044f40000000000000000000000a000a0000
0000000000000000000000000770077000000007770000000000077000000077066000005555555122222222222044444444440000000000000000a000aa0000
0000776777770000777000000777067000000000770770000000077000000076777000005111115522222222222444444444444240000a00000000aa0aa00000
00d77777777700d77777700000677067007700776677700000777770770000077770000011151115222222222224440444444442400000a000000aaaaaa00000
00d77dd7600000d77dd7700077066766777707777677000000777677770000076670000011555115222222222225544444444444000000aaa000000aaa0000aa
00d77777777700d77777700077776666776007767677000000767677700000077770000011151115222222222220544f444444440000000a00000000aaaaaa00
00d77dd7777700d77dd770000066666666000067677700000066677600000007776d00005111115522222222222422ff4f44444400000000000000000aaa0000
00d67777700000d67777600000006666dd000006666d0000006676600000000066dd000055555551222222222224404400f24444400000000000000000a00000
000066660000000066660000000000ddd000000066d00000000dddd000000000ddd00000222222222222222222200000000f2244400000000000000000a00000
000066600000000666000000006660000000077700000000766000000008bb000000006660000000066600002227778000008870000000000000000000000000
006666666000066666660000777772700007777776000067667770000b88bb880000666666600007777727002228787800088777000000000000000000000000
07777772770077766627700ddd772ddd007777766770067677676700bb88bb88b0077777dd7700ddd772ddd02228807770078087000000a00000000000000000
0ddd772ddd0077777727700777772777007776677660077676767600bb88bb88b00dd77277d70077777277702220780870077088000000a00000000000000000
7777772777777dd772dd7777d77772d7777667766666676766766778bb88bb88bb7777727777777d77772d77222000000008700000000aaa0000000000000000
77d77772d777776d7d67777d7d772d7d766776666677767677677668bb88bb88bb7d77772d7767ddd772ddd72220000000088000000aaaaaa00000000a000000
7d7d772d7d7777777727777777722777777666667777677676766778bb88bb88bbd7d772d7d7677d77227d7722200888000780000aa0000aaa000000aaa00000
77d77227d777d7d772d7d777ddddddd7766666777776767767777678bb88bb88bb7d77227d777777727727772220007800077000000000aaaaaa000000a00000
7777277277777d77227d7777ddddddd7766677777667776776767768bb88bb88bb77727727777777ddddd7772220007770087000000000aa0aa00000000a0000
77d72777d777777277277777ddddddd7767777766777676767677668bb88bb88bb7772dd7777777ddddddd77222000087008800000000aa000a0000000000000
07ddddddd70077ddddd770077ddddd7700777667777006766676670011bb11bb1007dddd7777007d72777d70222000088807800000000a000a00000000000000
06772777760077d277d770066727776600766777777007677676760011bb11bb10067277777600677277776022200000780770000000a0000a00000000000000
006677766000077277770000666666600007777777000076776670000666666600006677766000066666660022200000770000000000a0000000000000000000
00006660000000066600000000666000000007770000000076700000000666000000006660000000066600002222222222222222200a00000000000000000000
00000000880066660000660006666666660000000900000000000000000000800300001111111110222222222222222222222000000000000a90000000bb0000
000000007800606000066660666000006660000aaaaa0000008383800008000300800111111111112222222200000000222220000000000039a3000003333000
0000000077006060000606606600000006600000989000008000000080003008003001111110101122222222cc00ccc022222003333300010bb0000000bb0000
00000000870060600000006066600006066000006360000003838383000080030080011111110111222222220cc0cccc22222033bbb33003c331300033333300
0000000088006060000000600606000066000009b68b000300000000030030080030011111101011222222220cccccc02222203bbbbb3000b19b80000bbbb000
0000000078006060000000600060600000000003113100008383838380080003008001111111111122222222c0ccccc022222033bbb330333333330333333330
0000000077006060000000600006060000000066b66b600000000000000000800300001111111110222222220cccccc0222220033333001bb8bb1000bbbbbb00
000000008700606000000060000060600000001361361002222222222222222222222222222222222222222200cccc00222220000000003c1218330333223330
0000000088006060000000600000060600000bb19b18bb0000000f00000000000500000000000880880000000000000022222222222222000220000222222222
7700000078006060000000600660006060000636636636000f0f00f0f00000000100000000008888ee8000000000015111111151006760000440000200000000
8700000077006060000000606666000606001b61b61b61b00f00f0ff000000000100000000008888ee8000000000011155555111060706000444000200cccc00
88000000870060600000006066060000666031c31931831000f0f0f000000000010000000000088888000000000001151111551506077600042000020ccc00c0
780000008800606000000060600000000660000022200000000f0f0000000000010000000000008880000000000001151511151506000600444000020cc000c0
7770000778006060000000606600000006600000444000000044444000000000010000000000000800000000000001155151151500666000024000020cc0c0c0
0888778870000ddd00000d00ddd00000ddd00000444000000444444400000000010000000000000000000000000001151511151500000000044000020c00ccc0
00877887000000ddddddd0000ddddddddd000004444400000444045500000000010000000000000f0f0000000000011511115515000000004444000200cccc00
22222222222222222222222222222222222222222222222004444455000000000870044044440000f0f0f0000000011155555111000000002222222200000000
0000000000666660000666660006600666666666660000000444444000000000700804244444440f000f00000002222200000111111111110000d00000000000
0000000066660006600066060060660060600000660000000444444400000008000070444444442f0ff000000002222200000110111011110000dd0000010000
00000000606000006000660660000600606000066000000004444224550000000000804444444444f4000000000222220000010101010101ddddddd000111000
0000000060600000600060606000060060600000660000000424424445000000000700444444444444400000000222220000001000100010dddddddd00010000
0000000606000000060060606600060060600000000000000422224440000000008000444244444044400000000222220000000001010000ddddddd000000000
00000006060000000600600606000600606000000000000004424444400000000700002442244244455000000002222200000010001001000000dd0000000000
00000006060000000600600606600600606000600000000004454444400000008000000244454424458787878622222200000000000000000000d00000000000
00000006060000000600600060600600606666600000000200000000000000000000000000000000009990099999990000000000000000000000000000000000
00000006060000000600600060660600606000600000000200000000000000000000000000099900099909009090099000000099000000000000000000000002
00000006060000000600600006060600606000000000000200000000000000000000090000909900099000909090009900000990900999000000000000000002
00000006060000000600600006066600606000000000000200000000000009999000099000000900909000909090009900009090900990999000000000000002
00000006060000000600600000606600606000006600000200000000000099900900099900000900909000009090099900009090900900099990000000000002
00000000606000006000600000606600606000066000000200000000000099000090090990000900909000009099999000090900900090099009900000000002
00000000606000006000600000060600606000006600000200000000000909000099009099000900909000009099000000090900900900999009990000000002
00000000dddd000dd000d000000d0d00d0d000000600000200999990000909000099009909900090909099909090900000909000900000909000990099900002
0000000000ddddd0000ddd00000ddd0ddddddddddd00000209990009000909000009009090990090909000909090990000909000900000909009900990099002
00000000000000000000000000000000000000000000000209900009900909000009909009099090909000909090990009099999900009099009009900000902
00000000000000000000000000000000000000000000000299900000900909000009909000909990909000909090099009090009900009090000009900000992
66666660000000000300000006666666660006666666660299900000990909000009900900090990044404404040099090990009900009090000099900000992
06060006600000003030000066600000666066600000666290900000990909000009900900009440004444004444044040900009900090990000090900090992
06060006600000003000000066000000066066000000066290900000990909000000900900000040000000000000044044400009900090900000090900099992
06060000660000007370000066600006066066600006066290900000000909900000900400000000000000000000000004440009900090900000009090009902
06060000660000006660000006060000660006060000660290900000000090900000900040000000000000000000000000000004400909900000009090000002
06060000660000088888000000606000000000606000000290900000000090900000400400000000000000000000000000000044400409000000000909000002
06060006600000888888800000060600000000060600000290900000000009090004000000000000000000000000000000000000004444000099000909000002
06066666000008388838880000006060000000006060000290900000000009404004000000000000000000000000000000000000000444000999900090900002
06060000600083338888833000000606000000000606000209090000009900044440000000000000000000000000000000000000000000009999900090900002
06060000660033333888333006600060600006600060600209090000009900000000000000000000000000000000000000000000000000004990900009090002
06060000066033833383338066660006060066660006060209090000000400000000000000000000000000000000000000000000000000004400000009090002
06060000066038883333388066060000666066060000666200999000000400000000000000000000000000000000000000000000000000000440000009990002
06060000066088888333888060000000066060000000066200099900004000000000000000000000000000000000000000000000000000000044400044900002
06060000066008388838880066000000066066000000066200000944440000000000000000000000000000000000000000000000000000000000044440000002
0d0d0000dd00008888888000ddd00000ddd0ddd00000ddd251111111115111110000000011111151111111511111111151111111115111111111511111111151
dddddddd00000008888800000ddddddddd000ddddddddd0211555555511155550000000055555111555551115555555111555555511155555551115555555111
00000000000000000000000000000000000000000000000215511111551551110000000011115511111155155111115515511111551551111155155111115511
00000000000000000000000000000000000000000000000215111511151511150000000015111511151115151115111515111511151511151115151115111511
00000000000000000000000000000000000000000000000215115151151511550000000051511511555115151151511515115551151511515115151155511511
00000000000000000000000000000000000000000000000215111511151511150000000015111511151115151115111515111511151511151115151115111511
00000000000000000000000000000000000000000000000215511111551551110000000011115511111155155111115515511111551551111155155111115511
00000000000000000000000000000000000000000000000211555555511155550000011155555111555551115555555111555555511155555551115555555111
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000200000000000000000002000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000000000000000000000000000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000000000000000000000000000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000000000000000000000000000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000000000000000000000000000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000020000000000000000000000000000000000000000000000020000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000000000000000000000000000000000000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000088006666000066000666666666000000090000000000000000000200000000000002000000000000
0000000000020000000000000200000000000000000000007800606000066660666000006660000aaaaa00000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000077006060000606606600000006600000989000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000087006060000000606660000606600000636000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000088006060000000600606000066000009b68b00000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000078006060000000600060600000000003113100000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000077006060000000600006060000000066b66b60000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000087006060000000600000606000000013613610000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000088006060000000600000060600000bb19b18bb000000000000000200000000000002000000000000
00000000000200000000000002000000000000007700000078006060000000600660006060000636636636000000000000000200000000000002000000000000
00000000000200000000000002000000000000008700000077006060000000606666000606001b61b61b61b00000000000000200000000000002000000000000
000000000002000000000000020000000000000088000000870060600000006066060000666031c3193183100000000000000200000000000002000000000000
00000000000200000000000002000000000000007800000088006060000000606000000006600000222000000000000000000200000000000002000000000000
00000000000200000000000002000000000000007770000778006060000000606600000006600000444000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000888778870000ddd00000d00ddd00000ddd00000444000000000000000000200000000000002000000000000
000000000002000000000000020000000000000000877887000000ddddddd0000ddddddddd000004444400000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000000000000000000000000000000000000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000000000000000000000000000000000000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000000666660000666660006600666666666660000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000066660006600066060060660060600000660000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000060600000600066066000060060600006600000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000060600000600060606000060060600000660000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060606600060060600000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060060600060060600000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060060660060060600060000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060006060060060666660000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060006066060060600060000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060000606060060600000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060000606660060600000000000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000606000000060060000060660060600000660000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000060600000600060000060660060600006600000000000000000000200000000000002000000000000
00000000000200000000000002000000000000000000000060600000600060000006060060600000660000000000000000000200000000000002000000000000
000000000002000000000000000000000000000000000000dddd000dd000d000000d0d00d0d00000060000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000ddddd0000ddd00000ddd0ddddddddddd0000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000006666666000000000030000000666666666000666666666000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000660000000303000006660000066606660000066600000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000660000000300000006600000006606600000006600000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000066000000737000006660000606606660000606600000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000066000000666000000606000066000606000066000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000066000008888800000060600000000060600000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000660000088888880000006060000000006060000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606666600000838883888000000606000000000606000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000060008333888883300000060600000000060600000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000066003333388833300660006060000660006060000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000006603383338333806666000606006666000606000000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000006603888333338806606000066606606000066600000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000006608888833388806000000006606000000006600000000000000000000000000002000000000000
00000000000200000000000000000000000000000606000006600838883888006600000006606600000006600000000000000000000000000002000000000000
00000000000200000000000000000000000000000d0d0000dd00008888888000ddd00000ddd0ddd00000ddd00000000000000000000000000002000000000000
0000000000020000000000000000000000000000dddddddd00000008888800000ddddddddd000ddddddddd000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
000000000002000000000000000000880b0b08880bbb00880bbb08880bbb0088000008880bb008880bbb08880bbb088000000000000000000002000000000000
000000000002000000000000000008000b0b080800b0080000b008880b0b0800000008000b0b008000b000800b0b080800000000000000000002000000000000
000000000002000000000000000008000bbb088000b0088800b008080bbb0888000008800b0b008000b000800b0b080800000000000000000002000000000000
000000000002000000000000000008000b0b080800b0000800b008080b0b0008000008000b0b008000b000800b0b080800000000000000000002000000000000
000000000002000000000000000000880b0b08080bbb088000b008080b0b0880000008880bbb088800b008880bbb080800000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0500000000000978010001000564000000000e00020000001200020000001200020500001200020500001200020500001200020500001100020000000500000002000d00020000000d0000000000050a000000000300010000000500000b02000b64010001000400010000000500010000000407000001000b80000000000700
000000000500011600000500000000000a1001000100059600000000090c000000000c03000000000a200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000b000000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bf00000b0000000000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000f80a0a0a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000abfbfcfdfefafbfcfdfeff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ab69f6f7feac69f6f7fef900bf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000babfbfcfdfefafbfcfdfeff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ab69f6f7feac69f6f7fef9000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000abfbfcfdfefafbfcfdfeff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bcbdbdbdbdbdbdbdbdbdbd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01120000071300712107111071200b1300b1210b1110b1200c1300c1210c1110c1200d1300d1210d1110d1200e1300e1210e1110e1200d1300d1210d1110d1200c1300c1210c1110c1200b1300b1210b1110b120
011200001f5301f5211f5110000000000000001f5301f5311f5211f5211f51100000000000000000000000001f5301f5211f5110000000000000001f5301f5311f5211f5211f5113000000000000000000000000
0112000000000000000000026520245302452124521225202453024531245211d5301d5311d5211d5211d5111f5301f5211f5110050000500005001f5301f5311f5211f5211f5113050000500005000000000000
011200001d2301f2211f2211f2211f2221f2221f2221f2211f2110000000000000001a2301a2211a2211a2111d2301f2211f2211f2211f2221f2221f2211f2211f21100000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b000000200095400c1510d1510f151282612825128261282512826128251282412825128231282412822128231282112822128211282112821128211282112821128211282112821128211000000000000000
010500002173021751217611f7701e1701c1721a17218172151720965009620217022170200700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
010c0000215702d5502d5512d5412d5322d5222d5001f502215000950021502005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000000
011000002155500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01050000106400e6400c6300763000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500001c6601a650186501364007620006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105000010560105611c5701c57109500095000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010b000000200095400c1510d1510f151282612825128261282512826128251231310020000200002000020000200002000000000000000000000000000000000000000000000000000000000000000000000000
010800001775500700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
01080000287612d7712d7612d7512d741007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000000000000000000000
0107000034630286411c64110631046411c450284511c441284411c43128421000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400001006010051140601405123060230512807028071280712807128071280612805128041280312802100000000000000000000000000000000000000000000000000000000000000000000000000000000
010700000703013031070211303107021130310702100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700001304013031070400704107031070310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00002d5502d5312d5210050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000000000000
010e00001556015531000001556015531155210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600003462034631346213427132274342143221434224322243422432224342243222434214322140020000200002000020000200002000020000200002000020000200002000020000200002000020000200
010a00002855028531285210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01060000106401c13122141281512815128151271412613124131201211d121161111111100100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
010a00001f02120021250312b0412e0512f0512e0512d0512b0412803125031210211d02100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800002d7512d751287412873100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001301000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001c7301f7511f7521f73100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001f7601f7711f7721f7721f7721f7621f7421f7511f7311f72100700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000000000000
0108002024610186110c6110060018615006001860518615186101861100611006001861500600186051861524610186110c611006001861500600186051861518610186110c6110060018615006001860518615
0108000024610186110c6110060018615006001860518615186101861100611006001861500600186051861524610186110c61100600186150060018605186151861524625306353c63530640246210c61100000
0108000024610186110c611006001861500600186051861518610186110c6110060018615006001860518615000000060000000000003062024621186110c6113c63030631246210c6113062024621186110c611
011000000413004131041210411107130071210713007121091300913109121091110a1300a1310a1210a1110b1300b1210b1300b121091300912109130091210713007131071210711103130031310312103111
011000000413004131041210411100000000000000000000000000000000000000000000000000000000000004130041310412104111041110000004130041310412104111041110000000000000000000000000
011000000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000000000000000000000000000000000000000000000000000000000000000000
011000002f5302f5212f5212f511285302853128521285002e5302e5212e5212d5302d5212d5212b5302b5212f5302f5212f5212f511285302852128521285002e5302d5202b5302d5302d5212d5212b5302b521
011000002f5302f5212f5212f511285302853128521285002e5302e5212e5212d5302d5252d5352b5302b52128530285212852128511285002850026500265002653027530275212853028521285212851128500
011000001c2301c2211c22118221152311523115221152111b2301b2211b2211a2301a2221a22218230182211c2301c2111c2301c211152201521115220152111b230182201b230182111a2211c2211f23123231
011000002f5302f5212853028521285212851100000000002e5372f5272e5202f5302f5212f5212f5112f5112f5302f52128530285212b530285302b5302e5302d5302d5212b5302853028531285212852128511
01100000265302652128530005000050000500005000050028530285212b53000500005000050000500005002d5302b52028530285212d5302b52028530285212b5302b5212b5402b5312d5402d5312e5402e531
011000000050000000000000050010230102211023010221005000050000500005001f2301f2211f2301f221000000000000000000000000000000000000000000000000001f2301f22121230212212222122221
01100000091300913109121091110c1300c1210c1300c1210e1300e1310e1210e1110f1300f1310f1210f111101301012110130101210f1300f1210f1300f1210e1300e1310e1210e1110c1300c1310c1210c111
0108000018620186210c611246051862500600006003062500503005031860524615306153c6253c62530620246212461100600186150060000600306253c5000050300503306253c5000050300503005033c500
0108000018620186210c611006001862500600006001861500615006150c625186251862524625306253062524620246211861100503306203061100503186253452034511345113451134625005030060030625
011800001c2401c2321c2221c2111c2401c2321c2221c2111c2401c2311c2211a2411524015231152211624017240172321723215221132401323113231132211321112211102401023210232102320e2320e222
01180000186350000000000000001863500000000001863524630186210c6210000000000000000000000000000001864518635186251864518635000000000024630186210c6210000000000000000000000000
011000000b1300b1310b1210b1110e1300e1210e1300e1211013010131101211011111130111311112111111101301012110130101210f1300f1210f1300f1210e1300e1310e1210e1110c1300c1310c1210c111
011000001e2301e22117230172111a2301c2301c2221c2211e2301e22117230172111a2301b2321b2221b221285302852121530215211f5302153021521215211f5301c5201b5301a5301a5311a5311a5211a521
011000002e5302e5212f5302f5312f5312f5212f5212f52123500235002350023500225002250021500235002e5302d5202b5302e5302e5212e5112b5302b5312853028521285212852128511225001b5001c500
011000002823028231282312822128211000002b2202b231282312823228222282110020000200262200020026230222302123021221232302322126230262212823028231282312822128222282122821100000
011000002823028231282312822128211000002b2202b23128231282322822228211002000020026220002002623021231222300000022230212211f2301f2201a2301c2301f230212201f221212202222023220
01100000161701615116141161211516015151151411513113160131511312116170161511614116121151601515115141151311316013151131210e1500e1501015010150000001315013150131501315000000
01140000041600414104121071500916009141091210e1300b1600b1410b1110a150091600914109121071500a1600a1410a1210915007160071410712109150091600914109121091110b1600b1410b1210b111
01100000041600415104141071600916009151091410e16010150101500e160101501315013150131501315000000000000000000000000000000000000000000000000000000000000000000000000000000000
01140000041600415104141071600916009151091410e1600b1600b1510b1410a160091600915109141101601316013151101600e1601316013151101600e1601016010150101401014010130101201012000000
011000000e2220c221102311023110211000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0108000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b5402b5412b5312b5312d5402d5412d5312d5312e5402e5412e5312e531
01120000186350000018635186300c62100621186350000018635186300c62100621006350c6350c63518635186352463524630186210c621000000000000000000000000000000000000000000000000000b120
011200000e1300e1210b1200912009121091110c1300c121091200612006121061110012002120041200213004130061300713007131071310713107121071210712107111071110711100100001000010000100
010900000461500000046150000004615000001061500000106150000010615000001c615000001c615000001c625000001c625046351c635106351c6351c635286351c635286351c63528645286453464534645
011200001a2301a2111a2301a2211a2111a2301823018211182301822118211182302623026221262112923029230292212b2302b2312b2312b2212b2212b2212b2212b2112b2112b21100000000000000000000
__music__
01 20426044
00 21656144
00 20426044
00 22426244
01 23632044
00 23632044
00 23632044
02 24642044
00 69422044
00 29422044
00 2a2b2044
01 26232044
00 27232044
00 282c2044
00 27232044
00 32312044
00 23632044
00 2d426d44
02 2e426e44
00 35232044
00 35232044
00 41424344
00 41424344
00 41424344
00 41424344
02 3b632044
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
01 2f423044
04 3a424344
01 41004344
00 40004344
00 01004344
00 02004344
00 43004344
02 03004344
00 7f7d7d44
00 41424344
00 41424344
00 41424344
00 3e424344
02 3f3d3c44

