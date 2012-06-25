//Complete overhaul to GG2's HUD. Inspired by RevanXP's TF2 HUD.
//View/edit with a fixed width font. Some punctuation is vertically aligned.
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

    menu_addedit_select("WarHUD dropshadow style", "global.warhud_style", "
        gg2_write_ini(section, key1, argument0);
    ");
    menu_add_option(0, "Off");
    menu_add_option(1, "Team colored");
    menu_add_option(2, "Black");
');

//HUD stuff now

object_event_add(HealthHud,ev_create,0,"
    sprite_index = sprite_add_sprite(global.warhud_namespace + 'CharacterHUD.gmspr');
    health_sprite = sprite_add_sprite(global.warhud_namespace + 'Healthbar.gmspr');
    offwhite  = make_color_rgb(217,217,183); // Old (too light) color values ripped from stock HUD:
    c_redteam = make_color_rgb( 64, 16,  0); // (165, 70, 64);
    c_bluteam = make_color_rgb( 16, 32, 64); // ( 73, 93,104); (They might be useful to someone.)
");

object_event_clear(HealthHud,ev_draw,0);
object_event_add(HealthHud,ev_draw,0,"
    if(global.myself.object == -1)
    {
        instance_destroy();
        exit; 
    }

    text_xpos = 45+24;
    text_ypos = 547+18;
    sprite_xpos = 11;
    sprite_ypos = 525;
    icon_xpos = 11;
    icon_ypos = 545;
    hp = global.myself.object.hp;
    maxHp = global.myself.object.maxHp;
    event_user(0);
    
    //health icon outline and backing
    draw_sprite_ext(sprite_index , 0, view_xview[0]+sprite_xpos, view_yview[0]+sprite_ypos, 2, 2, 0, c_white, 1);
    draw_sprite_ext(health_sprite, 0, view_xview[0]+sprite_xpos, view_yview[0]+sprite_ypos, 2, 2, 0, c_black, 1);
    
    //draw dynamic colored health icon
    //TODO: Optimize to one sprite draw
    hppixels = hp/maxHp*17;
    draw_sprite_part_ext(health_sprite,0,0,(17-hppixels)+10,sprite_width,hppixels+1,view_xview[0]+icon_xpos, view_yview[0]+icon_ypos+(17-hppixels)*2,2,2,c_red,1);
    draw_sprite_part_ext(health_sprite,0,0,(17-hppixels)+10,sprite_width,hppixels+1,view_xview[0]+icon_xpos, view_yview[0]+icon_ypos+(17-hppixels)*2,2,2,c_green,hp/maxHp);
    
    //start picking HP # text colors
    if(global.myself.team == TEAM_RED)
        c_shadow = c_redteam;
    if(global.myself.team == TEAM_BLUE)
        c_shadow = c_bluteam;
    if(global.warhud_style == 2)
        c_shadow = $202020; //offblack
        
    //colors for HP # text, red = can die in one hit; orange = taking too much heat
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
        draw_text_transformed_color(view_xview[0]+text_xpos+size, view_yview[0]+text_ypos+size, hpText, size, size, 0, c_shadow, c_shadow, c_shadow, c_shadow, 1);
    draw_text_transformed_color(view_xview[0]+text_xpos, view_yview[0]+text_ypos, hpText, size, size, 0, hpColor, hpColor, hpColor, hpColor, 1);
");
