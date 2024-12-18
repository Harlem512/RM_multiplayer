#region general

switch( meta_state ) {
	#region char select
	case e_meta_state.char_select:
		if instance_exists(oclo) with oclo { IDD(); }
		//if ( !audio_is_playing(snd_ambient_character_select) ) {
		//	audio_play_sound(snd_ambient_character_select,0,0);
		//}
		if instance_exists(obutton_steam) with (obutton_steam)  { IDD();	 }
		//if instance_exists() with ()  { IDD( orandom );			 }
		if instance_exists(omenu_bg_render) with (omenu_bg_render)  { IDD( omenu_bg_render );	 }
		if instance_exists(obutton) with (obutton)  { IDD();	 }
		
		var lmx_ = MX-camera_x;
		var lmy_ = MY-camera_y;
		//if (!instance_exists(opreference_tracker) ) {
		//	exit;
		//}
		if ( !instance_exists( obutton_character ) ) {
			var xx = 0;//GW*0.0;
			var yy = 0;//GH*0.0;
			
			ICD( xx+100, yy + 241, 0, obutton_grapplemode );
			ICD( xx+118, yy + 241, 0, obutton_grapplemode_off );

			ICD( xx+78, yy  + 258, 0, obutton_tapjump );
			ICD( xx+104, yy + 258, 0, obutton_tapjump_off );
			
			ICD( xx+78, yy  + 274, 0, obutton_ready );
			// ICD( xx+104, yy + 274, 0, obutton_ready_off );

			ICD( xx+20+00, yy+203, 0, oplayer_select_fern   );
			ICD( xx+20+40, yy+203, 0, oplayer_select_maya   );
			ICD( xx+20+80, yy+203, 0, oplayer_select_ameli  );
			ICD(xx+20+120, yy+203, 0, oplayer_select_freia  );
			
			ICD( 8, 324+1, 0, obutton_rollback_text );
			
			ICD(100,324+4,0,obutton_rollback);
			
			var ii = 0; repeat(10) {
				ICD( 140+ ( ii * 16 ), 324+4, 0, obutton_rollback ).amount_index = ii;
				ii++;
			}
			
			
			//ICD( 394, 322, 0, obutton_flicker_test );
			//ICD( 516, 322, 0, obutton_flicker_on   );
			//ICD( 544, 322, 0, obutton_flicker_off );
			
			ICD( 528, 16, 0, obutton_music_on  );
			ICD( 560, 16, 0, obutton_music_off );
			
			
			// ICD( xx-96, yy + 128, 0, obutton_ready		);
			
			// ICD( xx+128-112, yy + 128-12-12, 0, obutton_grapplemode );
			// ICD( xx+128-112, yy + 128+12-12, 0, obutton_grapplemode_off );
			
			// ICD( xx+128-112, yy + 128+32,   0, obutton_tapjump	   );
			// ICD( xx+128-112, yy + 128+32+24,0, obutton_tapjump_off );
		}
		
		level_select_timer++;
		
		
		with ( obutton_character ) {
			if ( instance_position( lmx_, lmy_, id ) && other.K1P ) {
				opreference_tracker.char_index[ other.player_id ] = index;
				opreference_tracker.char_index_progress[ other.player_id ] = 256;
				switch(index) {
					case e_char_index.fern:
						audio_play_sound_pitch( snd_fern_win, 1, 1, 0 );
					break;
					case e_char_index.maya:
						audio_play_sound_pitch( snd_maya_win, 1, 1, 0 );
					break;
					case e_char_index.ameli:
						audio_play_sound_pitch( snd_ameli_win, 1, 1, 0 );
					break;
				}
				
			}
			
		}
		if ( opreference_tracker.char_index_progress[ other.player_id ] > 0.1 ) {
			opreference_tracker.char_index_progress[ other.player_id ] = lerp( opreference_tracker.char_index_progress[ other.player_id ], 0, 0.15 );
		}
		
		with ( otoggle_button ) {
			if ( instance_position( lmx_, lmy_, id ) && other.K1P ) {
				execute_function( other.player_id );
					  
			}
			
			
			//show_debug_message( global.grapple_mode[  other.player_id ] );
				//show_debug_message( global.tap_jump[	  other.player_id ] );
			image_index = return_function( other.player_id );
			
		}
		if ( opreference_tracker.char_index_progress[ player_id ] != -1 ) {
			with (obutton_ready) {
				if ( instance_position( lmx_, lmy_, id ) && other.K1P  ) {
					if ( !opreference_tracker.ready_state[ other.player_id ] ) {
						//audio_play_sound_pitch( snd_menu_ready, RR(0.8,0.9), RR( 0.97, 1.06 ), 0  );
						opreference_tracker.ready_state[ other.player_id ] = true;
						//
					}
				}
			}
			
		}
		
		if ( global.training_mode ) {
			if ( opreference_tracker.ready_state[ player_id ] ){
				with (oplayer) meta_state = e_meta_state.level_select;
			}
		} else {
			var switch_state = true;
			with ( oplayer ) {
				if ( !opreference_tracker.ready_state[ player_id ] ) switch_state = false;
			}
			if ( switch_state ) {
				with ( oplayer ) {
					meta_state = e_meta_state.level_select;
				}
			}
		}
		
		
	break;
	#endregion
	default:
		if ( first_looser == undefined && lives_left <= 0 ) {
			var ld_ = id;
			with ( oplayer ) { first_looser = ld_; }
		}
		var st_ = 0;
		with ( oplayer ) {
			if ( lives_left > 0 ) {
				st_++;
			}
		}
		
		if ( st_ <= 1 ) {
			var wid_ = id;
			with ( oplayer ) {
				if ( lives_left > 0 ) winner = wid_;
			}
			var fwin = winner;
			with ( oplayer ) {
				winner = fwin;
			}
			
			meta_state = e_meta_state.round_end;
			audio_play_sound_pitch( snd_round_over, 1, 1, 0 );
			
			if ( player_local ) {
				with ( music_player ) {
					stop_playing_music();
				}
			}
		}
		
	break;
	case e_meta_state.level_select:
	case e_meta_state.round_end:
		
	break;
}

#endregion

#region meta states
switch(meta_state) {
	#region level select
	case e_meta_state.level_select:
		if ( !instance_exists( obutton_levels ) ) {
			var d_ = 1/7, i = 0; repeat(11) {
				ICD( GW*(d_+(d_ *(i mod 6))),GH*0.41 + (i div 6) * 64,0,obutton_levels).image_index = i;
				i++;
			}
		}
		level_select_timer++;
		if (level_select_timer > 2 ) {
			if instance_exists(otoggle_button) {
				with ( otoggle_button ) IDD();
			}
			if ( instance_exists( obutton_character ) ) {
				with ( obutton_character ) IDD();
			}
			
			if ( instance_exists( obutton_flicker_on ) ) {
				with ( obutton_flicker_on ) IDD();
			}
			if ( instance_exists( obutton_flicker_off ) ) {
				with ( obutton_flicker_off ) IDD();
			}
			global.training_mode_change_stage = false;
		}
		
		
	break;
	
	#endregion
	
	#region round end
	case e_meta_state.round_end:
		final_effect_speed *= 0.96;
		final_effect_speed = max(0.03,final_effect_speed);
		//if ( final_timer >= 150 && !victory_voice_played ) {
		//	switch( winner.char_index ) {
		//			case e_char_index.fern:
		//				audio_play_sound_pitch( snd_fern_win, 1, 1, false );
		//			break;
		//			case e_char_index.maya:
		//				audio_play_sound_pitch( snd_maya_win, 1, 1, false );
		//			break;
		//			case e_char_index.ameli:
		//				audio_play_sound_pitch(		snd_ameli_win, 1, 1, false );
		//				//audio_play_sound();
		//			break;
		//		}
		//	victory_voice_played = true;
		//}
		final_timer += 0.95;
		if ( final_timer > 340 ) {
			meta_state = e_meta_state.char_select;
			final_timer = 0;
			global.display_room_name = "";
		}
		if( instance_exists( overlet_object ) ) { IDD( overlet_object	); }
		if( instance_exists( par_hitbox	    ) ) { IDD( par_hitbox		); }
		if( instance_exists( ohook		    ) ) { IDD( ohook			); }
	break;
	
	#endregion
	
	#region round start
	case e_meta_state.round_start:
		//if ( audio_is_playing(snd_ambient_character_select) ) {
		//	audio_stop_sound(snd_ambient_character_select);
		//}
		
		opreference_tracker.ready_state[ player_id ] = false;
		global.training_mode_change_stage = false;
		
	
		
		#region char apply
		if ( !char_init ) {
			char_index = opreference_tracker.char_index[ player_id ];
				if ( global.test_enabled && TEST_FORCE_CHAR != -1 ) {
					char_index = TEST_FORCE_CHAR;
				}
			char_init = true;
			switch(char_index) {
				default:
				case e_char_index.fern:
					//portrait_expression_base = sface_fern_normal;
					//portrait_expression_hurt = sface_fern_hit;
					player_palette = spalette_player_1;
				break;
				case e_char_index.maya:
					base_walk_spd += 0.04;//base_walk_spd	= 0.385;
					hp_max = 125;
					hp = 125;
					grav *= 1.11;//0.17*1.2;
					base_jump_pwr += 1.2;// 4.68;
					//portrait_expression_base = sface_maya_normal;
					//portrait_expression_hurt = sface_maya_hit;
					player_palette = spalette_maya;
				break;
				case e_char_index.ameli:
					base_walk_spd *= 0.92;
					hp_max	= 100;
					hp		= 100;
					orbs = [ MAKES( oameli_orb ), MAKES( oameli_orb ), MAKES( oameli_orb ) ];
					orbs[0].parent = id;
					orbs[1].parent = id;
					orbs[2].parent = id;
					grav *= 0.96;
					base_jump_pwr += 0.5;
					orbs[1].idle_timer = 120;
					orbs[2].idle_timer = 240;
					player_palette = spalette_ameli;
					
				break;
			}
			
			main_shader = shd_palette;
			main_shader_col_num_pointer   = shader_get_uniform(shd_palette,       "col_num"     );
			main_shader_pal_num_pointer   = shader_get_uniform(shd_palette,       "pal_num"     );
			main_shader_pal_index_pointer = shader_get_uniform(shd_palette,       "pal_index"   );
			main_shader_palette_pointer	  = shader_get_sampler_index(shd_palette, "palette"     );
			main_shader_uvs_pointer		  = shader_get_uniform(shd_palette,       "palette_uvs" );

			shader_set(shd_palette);
				var palette_sprite = player_palette;
				palette_texture = sprite_get_texture(palette_sprite,0);
				var uvs = sprite_get_uvs(palette_sprite,0);
				shader_set_uniform_f(	    main_shader_col_num_pointer,   sprite_get_height(palette_sprite)  );
				shader_set_uniform_f(	    main_shader_pal_num_pointer,   sprite_get_width(palette_sprite) );
				shader_set_uniform_f(	    main_shader_pal_index_pointer, 1 );
				shader_set_uniform_f_array( main_shader_uvs_pointer,	   [uvs[0],uvs[1],uvs[2]-uvs[0],uvs[3]-uvs[1]]  );
	
				texture_set_stage( main_shader_palette_pointer, palette_texture );
			shader_reset();
		
		
			function start_palette() {
				shader_set(shd_palette);
				texture_set_stage( main_shader_palette_pointer, palette_texture );
			}

			#endregion
		}
		
		#endregion
		//if ( intro_timer < 10 ) {
			
		//} else {
		
			
		// if ( char_index != e_char_index.ameli && KLEFT && KRIGHT && KDOWN && K7 ) {
		// 		//show_debug_message("a")
		// 		char_index = e_char_index.ameli;
		// 		//base_walk_spd += 0.08;//base_walk_spd	= 0.385;
		// 		hp_max = 100;
		// 		hp = 100;
		// 		base_walk_spd *= 0.9;
				
		// 		orbs = [ MAKES( oameli_orb ), MAKES( oameli_orb ), MAKES( oameli_orb ) ];
		// 			orbs[0].parent = id;
		// 			orbs[1].parent = id;
		// 			orbs[2].parent = id;
					
		// 			orbs[1].idle_timer = 120;
		// 			orbs[2].idle_timer = 240;
					
		// 		//grav *= 1.1;//0.17*1.2;
		// 		//base_jump_pwr += 1.25;
		// }
		
		
		
		if ( global.training_mode ) {
			intro_timer = 130;
		}
		hp = hp_max;
		INVIS = 30; 
		intro_timer += 0.75;
		if ( intro_timer == 0.75 ) {
			audio_play_sound_pitch( snd_ready, 1, 1, 0 );
		}
		if ( intro_timer > 105 ) {
			if ( player_local ) {
				var d__ = player_id;
				with ( music_player ) {
					start_playing_music(d__);
				}
			}
			audio_play_sound_pitch( snd_round_start, 1, 1, 0 );
			intro_timer = 20;
			spawn_timer = 0;
			meta_state  = e_meta_state.main;
			state		= e_player.normal;
			INVIS		= 60;
		}
		if ( intro_timer == 75 ) {
			audio_play_sound_pitch(snd_respawn, RR(0.9,1),  RR(0.9,1), 0 );
		}
		//char_index = e_char_index.maya;
	break;
	case e_meta_state.respawn:
		hp = hp_max;
		INVIS = 30; 
		if ( spawn_timer == 5 ) {
			audio_play_sound_pitch(snd_respawn, RR(0.9,1), RR(0.9,1), 0 );
		}
		if ( spawn_timer++ > 30 ) {
			spawn_timer = 0;
			meta_state	= e_meta_state.main;
			state		= e_player.normal;
			INVIS		= 60;
		}
		damage_taken = 0;
		pre_hp = hp;
		draw_alpha = 1;
		hit_substate = 0;
		flying_charge = 60;

	break;
	#region main
	case e_meta_state.main:
		grapple_mode = opreference_tracker.grapple_mode[player_id];
		player_main_behaviour();
		if ( can_dodge_cooldown ) can_dodge_cooldown--;
		
	break;
	#endregion
	
	#region respawn
	case e_meta_state.dying:
		if ( spawn_timer == 0 ) {
			hit_freeze = 0;
			hit_timer = 0;
			//audio_play_sound_pitch(snd_explotion_0, 0.7, RR( 0.8, 0.9 ), 0 );
			audio_play_sound_pitch(snd_explotion_1, 0.4, RR( 0.5, 0.6 ), 0 );
			//audio_play_sound_pitch(snd_explotion_1, 0.7, RR( 0.7, 0.8 ), 0 );
			if ( random_fixed(1) > 0.5 ) {
				audio_play_sound_pitch( snd_fallout_0, 0.9, RR( 0.95, 1.05 ), 0, 0.15 );
			} else {
				audio_play_sound_pitch( snd_fallout_1, 0.9, RR( 0.95, 1.05 ), 0, 0.15 );
			}
			
			var num = RR( 16, 24 );
			var ldir_; 
			var llen_; 
			repeat( num ) {
				var sz= 8 + random(32);
				ldir_	= random(360);
				llen_	= random_range(8,sz);
				var t = ICD( x+LDX( llen_, ldir_ ), bbox_top+LDY( llen_, ldir_ )-4, RR(-50,50), osmoke_fx );
				t.spd *= RR(1,5);
				t.image_blend   = merge_color( c_orange, c_white, RR( 0.8, 1 ) );
				t.sprite_index  = choose( sflower_extra_0, sflower_extra_2, sflower_extra_3, sflower_extra_5, sflower_extra_6 );
				t.do_size		= false;
				t.duration		= 100 + ( random( 560 ) * RR( 0.5, 1.1 ) );
				t.size_mult		= RR( 0.1, 1 );
				t.duration *= RR(0.3,0.65);
							
			}
						
			
			
			if ( instance_exists(orespawn_box) ) {
				x = orespawn_box.x;
				y = orespawn_box.y;
			} else {
				x = room_width  / 2;
				y = room_height / 2;
			}
			var i = 0; repeat( weapon_number ) {
				if (RELOAD[i] > 0 ) RELOAD[i] = 0;
				i++;
			}
			gun_charge = 0;
			gun_charging = false;
			grenade_cooldown = 0;
			aim_dir = 0;
			draw_xscale =1;
			var_dir = 0;
			shoot_delay = 0;
			
		}
		INVIS = 60;
		
		if ( spawn_timer++ > 90 ) {
			hsp = 0;
			vsp = 0;
			spawn_timer = 0;
			meta_state = e_meta_state.respawn;
			
			INVIS = 60; 
			self_draw = true;
		}
		
	break;
	#endregion
	
}

#endregion

if ( meta_state != e_meta_state.main ) {
	var lddd_ = id;
	if ( !is_undefined( own_grapple ) && instance_exists( own_grapple ) ) {
		with ( own_grapple ) {
			if ( parent == lddd_ ) {
				state = 2;
			}	
		}
	}
}

if ( SHAKE > 0.05 ) {
	SHAKE *= 0.85;
	screen_shake_x = random_range_fixed(-SHAKE,SHAKE)*2.0;
	screen_shake_y = random_range_fixed(-SHAKE,SHAKE)*2.0;
} else {
	screen_shake_x = 0;
	screen_shake_y = 0;
	SHAKE = 0;
}
if ( show_hp_timer > 0 ) {
	show_hp_timer += 1.2;
	if ( show_hp_timer >= 100 ) {
		show_hp_timer = 0;
	}
}

var wep_list  = [ 0, 5, 1, 4, 3, 2 ];
var i = 0; repeat(6) {
	
	if RELOAD[wep_list[i]] > 5 {
		gun_flash_data[i] = 8.5;
	} else if ( RELOAD[wep_list[i]] <= 0 && gun_flash_data[i] > 0 ) {
		gun_flash_data[i] -= 0.33;
	}
	i++;
}

if ( maya_animation_swing_timer > 0 ) {
	maya_animation_swing_timer--;
}
if ( maya_sword_blink_alpha > 0 ) {
	maya_sword_blink_alpha -= 1;
}

var hh = KRIGHT-KLEFT;	
if ( hh == 0 ) {
	maya_body_tilt = lerp(maya_body_tilt,hh, 0.15 );
} else {
	maya_body_tilt = lerp(maya_body_tilt,hh, 0.15 );
}

if ( global.training_mode ) {
	if ( global.training_nocooldown ) {
		with (oplayer) {
			var i = 0; repeat(6) {
				RELOAD[i] = 0;
				i++;
			}
			grenade_cooldown = 0;
		}
	}
	if ( global.training_infinite_hp ) {
		with (oplayer) {
			if ( state == e_player.hit ) {
				hp = max(hp,1);
			} else {
				hp = hp_max;	
			}
		}
	}
	if (  global.training_mode_change_stage ) {
		with (oplayer) {
			if ( player_local ) {
				with ( omusic ) {
					stop_playing_music();
				}
			}
			meta_state = e_meta_state.level_select;
		}
		
	}

	
}



#region char specfic 
switch(char_index) {
	case e_char_index.ameli:
		if ( meta_state == e_meta_state.dead || meta_state == e_meta_state.dying ) {
			orbs[0].state = e_ameli_orb_state.idle;
			orbs[1].state = e_ameli_orb_state.idle;
			orbs[2].state = e_ameli_orb_state.idle;
			orbs[0].attack_state = e_ameli_orb_attack_state.idle;
			orbs[1].attack_state = e_ameli_orb_attack_state.idle;
			orbs[2].attack_state = e_ameli_orb_attack_state.idle;
		}
		flying_charge = min( flying_charge, 60 );
		ameli_book_x	= lerp(	ameli_book_x, x+( draw_xscale*23 )+hsp*3, 0.2 );
		ameli_book_y	= lerp(	ameli_book_y, y-27+vsp*3+sin(ameli_book_sin/27)*3, 0.2 );
		ameli_book_sin++;
		if ( !ameli_trail_cooldown-- &&  knife_state == 0 && grenade_cooldown <= 0 && state != e_player.hit ) {
			var amult_ = 3;
			var duration_ = 6;
			var bk_ = ameli_ranged_mode ? sameli_book_range : sameli_book;
			with ( create_fx( 
					ameli_book_x, 
					ameli_book_y,
					bk_, 0,
					0,
					depth+1 ) ) {
						image_index = 0;
						image_xscale = -other.draw_xscale;
						type = e_fx.fade;
						alpha_mult = amult_;
						duration   = duration_;
			}
			ameli_trail_cooldown = 3;
		}
				
	break;
}


#endregion

#region weapon select
var wep_select_input_hold  = false;
var wep_select_input_press = false;
wep_select_input_hold  = K4;
wep_select_input_press = K4P;


var check_m = char_index != e_char_index.maya || knife_state == 0;

if ( input_skip < 2 && check_m) {
	#macro KCP keyboard_check_pressed
	#macro sniper_cost  5
	
	#region quick switch
	if ( KQ0||KQ1||KQ2||KQ3||KQ4||KQ5||SC_DOWN||SC_UP ) {
		var pre_wep = current_weapon;
		var quick_num_ = undefined;
			
		if ( KQ0 ) { quick_num_ = 0; }
		if ( KQ1 ) { quick_num_ = 5; }
		if ( KQ2 ) { quick_num_ = 1; }
		if ( KQ3 ) { quick_num_ = 4; }
		if ( KQ4 ) { quick_num_ = 3; }
		if ( KQ5 ) { quick_num_ = 2; }
		
		if ( SC_DOWN || SC_UP ) {
			show_debug_message("a")
			var wp_list_in  = [ 0, 2, 5, 4, 3, 1 ];
			
			var wp_list_out = [ 0, 5, 1, 4, 3, 2 ];
			var val_ = loopclamp(  wp_list_in[current_weapon]+SC_DOWN-SC_UP,0,5);
			
			quick_num_ = wp_list_out[ val_ ];
			
		}
		
		if ( quick_num_ != undefined ) {
			wep_dir = clamp( quick_num_, 0, 5 );
			
			previous_weapon = current_weapon;
			current_weapon = wep_dir;
					
			#region switch general
			if ( current_weapon != pre_wep ) {
				shoot_press_buffer = 0;
				audio_play_sound_pitch(snd_reload_0,.5,.6+random_fixed(0.1),0);
				switching_weapon = true;
				gun_charging = false;
				gun_charge = 0;
				RELOAD[current_weapon] = max(5,RELOAD[current_weapon]+2);
			}
					
			#endregion
					
		}
		
	}
	#endregion		
}
#endregion

//if ( player_local ) {
//if ( !update_cooldown-- && update_cooldown > -30 ) {
////	if ( opreference_tracker.player_anti_flicker[player_id] ) {
//		application_surface_draw_enable( true );
////	} else {
////		application_surface_draw_enable( false );
////	}//application_surface_draw_enable()
//	update_cooldown = -60;
//}
		//application_surface_draw_enable( true );
//}
