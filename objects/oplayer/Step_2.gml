#region general

switch( meta_state ) {
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
			meta_state = e_meta_state.round_end;
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


switch(meta_state) {
	case e_meta_state.level_select:
		if ( !instance_exists(obutton_levels) ) {
			var d_ = 1/10, i = 0; repeat(9) {
				ICD( GW*(d_+(d_*i)),GH*0.55,0,obutton_levels).image_index = i;
				i++;
			}
		}
	break;
	case e_meta_state.round_end:
		if ( final_timer++ > 300 ) {
			meta_state = e_meta_state.level_select;
			final_timer = 0;
			global.display_room_name = "";
		}
		if instance_exists( overlet_object ) { IDD( overlet_object	); }
		if instance_exists( par_hitbox	   ) { IDD( par_hitbox		); }
		if instance_exists( ohook		   ) { IDD( ohook			); }
	break;
	case e_meta_state.round_start:
		hp = hp_max;
		INVIS = 30; 
		intro_timer += 0.75;
		if ( intro_timer > 105 ) {
			if ( player_local ) {
				with ( music_player ) {
					start_playing_music();
				}
			}
			intro_timer = 20;
			spawn_timer = 0;
			meta_state  = e_meta_state.main;
			state		= e_player.normal;
			INVIS		= 60;
		}
		
	break;
	case e_meta_state.respawn:
		hp = hp_max;
		INVIS = 30; 
		if ( spawn_timer++ > 30 ) {
			spawn_timer = 0;
			meta_state	= e_meta_state.main;
			state		= e_player.normal;
			INVIS		= 60;
		}
		damage_taken = 0;
		pre_hp = hp;
		draw_alpha = 1;
		
	break;
	#region main
	case e_meta_state.main:
		player_main_behaviour();
	break;
	#endregion
	
	#region respawn
	case e_meta_state.dying:
		if ( spawn_timer == 0 ) {
			//audio_play_sound_pitch(snd_explotion_0, 0.7, RR( 0.8, 0.9 ), 0 );
			audio_play_sound_pitch(snd_explotion_1, 0.7, RR( 0.5, 0.6 ), 0 );
			//audio_play_sound_pitch(snd_explotion_1, 0.7, RR( 0.7, 0.8 ), 0 );
			
			audio_play_sound_pitch( choose(snd_fallout_0,snd_fallout_1), 0.9, RR( 0.95, 1.05 ), 0 );
			
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

if ( meta_state != e_meta_state.main ) {
	var lddd_ = id;
	if ( instance_exists( ohook ) ) {
		with ( ohook ) {
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

	