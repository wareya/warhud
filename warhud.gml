//Complete overhaul to GG2's HUD. Inspired by RevanXP's TF2 HUD.
global.warhud_namespace = "Plugins/warhud/";


//Set up first

ini_open("gg2.ini");
global.warhud_style = ini_read_real(global.warhud_namespace,"WarHUD_style",1);
ini_close();

//make a new menu for plugin options
if !variable_global_exists("pluginOptions") {
    global.pluginOptions = object_add();
    object_set_parent(global.pluginOptions,OptionsController);  
    object_set_depth(global.pluginOptions,-130000); 
    object_event_add(global.pluginOptions,ev_create,0,'   
    menu_create(40, 140, 300, 200, 30);

    if room != Options {
        menu_setdimmed();
    }

    menu_addback("Back", "
        instance_destroy();
        if(room == Options)
            instance_create(0,0,MainMenuController);
        else
            instance_create(0,0,InGameMenuController);
    ");
    ');
    
    object_event_add(InGameMenuController,ev_create,0,'
        menu_addlink("Plugin Options", "
            instance_destroy();
            instance_create(0,0,global.pluginOptions);
        ");
    ');
} 

//add menu option/s
object_event_add(global.pluginOptions,ev_create,0,'
    //very dumb workaround
    section = global.warhud_namespace;
    key1 = "WarHUD_style";
    //even dumber workaround
    quote = chr(39);

    menu_addedit_boolean("Dropshadow in WarHUD", "global.warhud_style", "
        gg2_write_ini(section, key1, argument0);
");

');

//HUD stuff now

object_event_add(HealthHud,ev_create,0,"
    sprite_index = sprite_add_sprite(global.warhud_namespace + 'CharacterHUD.gmspr');
    health_sprite = sprite_add_sprite(global.warhud_namespace + 'Healthbar.gmspr');
    offwhite = make_color_rgb(217,217,183);
");

object_event_clear(HealthHud,ev_draw,0);
object_event_add(HealthHud,ev_draw,0,"
    if(global.myself.object == -1)
    {
        instance_destroy();
        exit; 
    }

    xpos = 45+24;
    ypos = 547+18;
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
    size = 3;
    
    if(global.warhud_style)
        draw_text_transformed_color(view_xview[0]+xpos+size, view_yview[0]+ypos+size, hpText, size, size, 0, c_black, c_black, c_black, c_black, 1);
    draw_text_transformed_color(view_xview[0]+xpos, view_yview[0]+ypos, hpText, size, size, 0, hpColor, hpColor, hpColor, hpColor, 1);
");
