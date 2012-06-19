//Complete overhaul to GG2's HUD. Inspired by RevanXP's TF2 HUD.

global.warhud_namespace = "Plugins/warhud/";

object_event_add(HealthHud,ev_create,0,"
    sprite_index = sprite_add_sprite(global.warhud_namespace + 'CharacterHUD.gmspr');
    health_sprite = sprite_add_sprite(global.warhud_namespace + 'Healthbar.gmspr');
    offwhite = make_color_rgb(217,217,183);
");

object_event_clear(HealthHud,ev_draw,0);
object_event_add(HealthHud,ev_draw,0,"
    if(global.myself.object == -1) {
        instance_destroy();
        exit; 
    }

    xpos = 45;
    ypos = 547;
    hp = global.myself.object.hp;
    maxHp = global.myself.object.maxHp;
    event_user(0);

    draw_sprite_ext(sprite_index, 0, view_xview[0]+11, view_yview[0]+525, 2, 2, 0, c_white, 1);
    
    draw_sprite_ext(health_sprite, 0, view_xview[0]+11, view_yview[0]+525, 2, 2, 0, c_black, 1);
    hppixels = hp/maxHp*17;
    draw_sprite_part_ext(health_sprite,0,0,(17-hppixels)+10,sprite_width,hppixels+1,view_xview[0]+11, view_yview[0]+545+(17-hppixels)*2,2,2,c_red,1);
    draw_sprite_part_ext(health_sprite,0,0,(17-hppixels)+10,sprite_width,hppixels+1,view_xview[0]+11, view_yview[0]+545+(17-hppixels)*2,2,2,c_green,hp/maxHp);


    if(hp <= 55)
        hpColor = c_red;
    else if(hp <= (maxHp/2))
        hpColor = c_orange;
    else 
        hpColor = offwhite;

    draw_set_valign(fa_center);
    draw_set_halign(fa_left);
    hpText = string(ceil(max(hp,0)));
    draw_text_transformed_color(view_xview[0]+xpos+24, view_yview[0]+ypos+18, hpText, 3, 3, 0, hpColor, hpColor, hpColor, hpColor, 1);
");
