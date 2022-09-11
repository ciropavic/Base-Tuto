return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			}
		}
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['cola'] = {
		label = 'eCola',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with cola'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		consume = 0,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			disable = { move = true, car = true, combat = true },
			usetime = 5000,
			cancel = true
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		consume = 0,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
		}
	},

	['alive_chicken'] = {
		label = 'poulet vivant',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['beer'] = {
		label = 'bière',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['blowpipe'] = {
		label = 'chalumeaux',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['bolcacahuetes'] = {
		label = 'bol de cacahuètes',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bolchips'] = {
		label = 'bol de chips',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['phone'] = {
		label = 'Smartphone',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bolnoixcajou'] = {
		label = 'bol de noix de cajou',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bolpistache'] = {
		label = 'bol de pistaches',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['bread'] = {
		label = 'pain',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['cannabis'] = {
		label = 'feuille de cannabis',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['carokit'] = {
		label = 'kit carosserie',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['carotool'] = {
		label = 'outils carosserie',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['clothe'] = {
		label = 'vêtement',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['copper'] = {
		label = 'cuivre',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['cutted_wood'] = {
		label = 'bois coupé',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['diamond'] = {
		label = 'diamant',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['drpepper'] = {
		label = 'dr. pepper',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['ecola'] = {
		label = 'ecola',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['energy'] = {
		label = 'energy drink',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['essence'] = {
		label = 'essence',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['fabric'] = {
		label = 'tissu',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['faimtest'] = {
		label = 'bare energetique',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['fixkit'] = {
		label = 'kit réparation',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['fixtool'] = {
		label = 'outils réparation',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['gazbottle'] = {
		label = 'bouteille de gaz',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['gitanes'] = {
		label = 'gitanes',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['gold'] = {
		label = 'or',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['golem'] = {
		label = 'golem',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['grand_cru'] = {
		label = 'grand cru',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['grapperaisin'] = {
		label = 'grappe de raisin',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['ice'] = {
		label = 'glaçon',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['icetea'] = {
		label = 'ice tea',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['iron'] = {
		label = 'fer',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['jager'] = {
		label = 'jägermeister',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['jagerbomb'] = {
		label = 'jägerbomb',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['jagercerbere'] = {
		label = 'jäger cerbère',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['jewels'] = {
		label = 'bijoux',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['jus_raisin'] = {
		label = 'jus de raisin',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['jusfruit'] = {
		label = 'jus de fruits',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['limonade'] = {
		label = 'limonade',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['malbora'] = {
		label = 'marlboro',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['marijuana'] = {
		label = 'marijuana',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['martini'] = {
		label = 'martini blanc',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['medikit'] = {
		label = 'medikit',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['menthe'] = {
		label = 'feuille de menthe',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['meth'] = {
		label = 'sky blue',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['meth_pooch'] = {
		label = 'pochon de sky blue',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['metreshooter'] = {
		label = 'mètre de shooter',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['mixapero'] = {
		label = 'mix apéritif',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['mojito'] = {
		label = 'mojito',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['packaged_chicken'] = {
		label = 'poulet en barquette',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['packaged_plank'] = {
		label = 'paquet de planches',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['petrol'] = {
		label = 'pétrole',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['petrol_raffin'] = {
		label = 'pétrole raffiné',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['raisin'] = {
		label = 'raisin',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['rhum'] = {
		label = 'rhum',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['rhumcoca'] = {
		label = 'rhum-coca',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['rhumfruit'] = {
		label = 'rhum-jus de fruits',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['saucisson'] = {
		label = 'saucisson',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['slaughtered_chicken'] = {
		label = 'poulet abattu',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['soda'] = {
		label = 'soda',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['soiftest'] = {
		label = 'boisson energetique',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['splif'] = {
		label = 'joint',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['stone'] = {
		label = 'pierre',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['tabacblond'] = {
		label = 'tabac blond',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['tabacblondsec'] = {
		label = 'tabac blond séché',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['tabacbrun'] = {
		label = 'tabac brun',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['tabacbrunsec'] = {
		label = 'tabac brun séché',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['teqpaf'] = {
		label = 'teq\'paf',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['tequila'] = {
		label = 'tequila',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['vine'] = {
		label = 'vin',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['vodka'] = {
		label = 'vodka',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['vodkaenergy'] = {
		label = 'vodka-energy',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['vodkafruit'] = {
		label = 'vodka-jus de fruits',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['washed_stone'] = {
		label = 'pierre lavée',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['whisky'] = {
		label = 'whisky',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['whiskycoca'] = {
		label = 'whisky-coca',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['wood'] = {
		label = 'bois',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['wool'] = {
		label = 'laine',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['parkingcard'] = {
		label = 'carte de stationement',
		weight = 0,
		stack = true,
		close = true,
		description = nil
	},
}