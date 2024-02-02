if ( alt_init ) {
	spd *= 0.8;
	duration *= 1.2;
	alt_init = false;
}
#region hitfreeze
if ( do_hitfreeze ) {
	if ( hitfreeze > 0 ) {
		hitfreeze -= 1;
		var htfr_ = max( 0, hitfreeze * 0.5 );
		draw_x_offset = RR( -htfr_, htfr_ );
		draw_y_offset = RR( -htfr_, htfr_ );
		exit;
	}
}

#endregion

repeat(step_number) {
	//universal
	if ( !duration-- ) {
		destroy_function();
		IDD();
		step_number = 0;
	}
	
	if ( trail_fx != -1 ) {
		if ( trail_timer++ >= trail_interval ) {
			trail_timer = 0;
			//create_fx(x,y,trail_fx,1,dir,1);
		}
	}
	
	if ( custom_user != -1 ) event_perform( ev_other, ev_user0 );
	
	
	//movement
	if ( do_movement_general ) {
		
		switch( move_type ) {
			case e_movetype.hvsp:
				x += hsp;
				y += vsp;
				vsp += grav;
				draw_angle += angle_spin;
				event_perform( ev_other, ev_user1 );
			break;
			case e_movetype.vector:
				spd *= frc;
				x += LDX(spd,dir);
				y += LDY(spd,dir);
				angle_spin += dir_angle_spin;
				draw_angle = dir + angle_spin;
				event_perform( ev_other, ev_user1 );
			break;
			case e_movetype.melee:
				if ( invis_set ) {
					//hit_fx = -1;
					trail_fx = -1;
					self_push = true;
					piercing = true;
					destroy_index = -1;
				}
				if ( instance_exists( parent ) ) {
					x = parent.x+ xdis*parent.draw_xscale;
					y = parent.y+ ydis;
					knockback_dir = parent.draw_xscale == 1 ? 180 : 0;
				} else {
					destroy_function();
					IDD();
					step_number = 0;
					exit;
				}
			break;
		}
	}
	if ( multihit && multihit_cooldown ) multihit_cooldown--;
	
	var t = undefined;
	var t_ = id;
	with ( oplayer ) {
		if ( PLC(x,y,t_) && id != t_.parent && !INVIS ) {
			t = id;
		}
	}
	
	#region Hit enemy
	if ( t && parent != undefined && t != parent && !t.INVIS ) {
		
		var pt_ = clamp( 1.1-dmg/90,   0.75, 1 )+0.1;
		var vol_= clamp( 0.3+dmg/80, 0.4, 0.9 );
		
		if ( t.state != e_player.hit ) {
			effect_create_depth(  -40, ef_ring, t.x, t.y-22, 0, merge_colour(c_red,c_ltgray,0.6) );
			t.hit_freeze = floor(max(8,dmg/7 ) );
			
			t.screen_flash_col	= c_gray;
			t.flash_alpha		= 0.07;
			
			parent.screen_flash_col	= c_gray;
			parent.flash_alpha		= 0.07;
			var snd_ = dmg >= 55 ? snd_hit_extra : choose( snd_hit_2, snd_hit_3 );
		
			//snd_ = choose(  );
			if ( dmg < 55 ) {
				audio_play_sound_pitch( snd_,		RR(0.75,0.8)*1.1*vol_, RR(0.95,1.05)*pt_, 0 );
			} else {
				audio_play_sound_pitch( snd_hit_extra, RR(0.9,0.96), RR(0.95,1.05), 0, 0.1 );
			}
			snd_ = choose( snd_take_damage, snd_take_damage_alt, snd_take_damage_3 );
			audio_play_sound_pitch( snd_, RR(0.75,0.8)*vol_, RR(0.95,1.05), 0 );
		} else {
			var snd_ = dmg >= 55 ? snd_hit_extra : choose( snd_hit_0, snd_hit_1, snd_hit_4 );
			t.hit_freeze = floor( max(4,dmg/8) );
			damage_mult *= 0.8;
			if dmg >= 55 {
				audio_play_sound_pitch( snd_, RR(0.75,0.8)*vol_, RR(0.95,1.05)*pt_, 0, 0.1 );
			} else {
				audio_play_sound_pitch( snd_, RR(0.75,0.8)*vol_, RR(0.95,1.05)*pt_, 0 );
			}
			
			audio_play_sound_pitch( snd_hit_alt, RR(0.75,0.8)*vol_, RR(0.95,1.05), 0 );
		}
		if ( t.hit_substate == 1 ) {
			if instance_exists(t.own_grapple) t.own_grapple.state = 2;
			t.hit_substate = 2;
			
		}
		t.can_dash = true;
		
		t.state = e_player.hit;
		t.hp -= dmg*damage_mult;
		t.hit_timer = floor(dmg*7.5*stun_mult);
		t.hit_freeze = max(4,dmg/3);
		t.bounce_cooldown = 30;
		
		if ( t.hit_substate == 0 ) {
			t.can_hook_delay = false;
			t.hook_air_cancel = false;
		}
		
		parent.can_hook_delay = false;
		parent.hook_air_cancel = false;
		
		
		with ( ohook ) {
			if ( parent == t || hook_object == t ) {
				state = 2;
				if (instance_exists(wire) ) {
					IDD(wire);
				}
			}
		}
		knockback *= 1.1;
		t.hsp *= 0.05;
		t.vsp *= 0.05;
		
		if ( abs(LDX(1,dir) ) < 0.5 ) {
			t.hsp += LDX( knockback*0.6, point_direction( 0, 0, -sign( parent.x - x )*10, 0 ) );
		} else {
			t.hsp += LDX( knockback*1.4, dir );
		}
		
		t.vsp += LDY( knockback*1.6, dir );
		
		t.vsp = lerp( t.vsp, min(-knockback*1.4,t.vsp), 0.5-LDY(0.5,dir) );
		t.vsp += bonus_vsp;
		
		with ( t ) {
			while gen_col(x,y+vsp+1) && !gen_col(x,y-1) {
				y--;
			}
		}
		
		t.SHAKE += shake_add * 0.5;
		parent.SHAKE += shake_add;
		destroy_function();
		IDD();
	}
	
	#endregion
	
	
}

if ( local_sound != undefined ) {
	location_sound_step( local_sound,  local_sound_volume, x, y,  local_sound_start_falloff, local_sound_end_falloff, local_sound_falloff_rate  );
}
image_angle = draw_angle;

