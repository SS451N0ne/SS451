//Station goal stuff goes here
/datum/station_goal/bluespace_tap
	name = "Bluespace сборщик"
	var/goal = 45000

/datum/station_goal/bluespace_tap/get_report()
	return {"<b>Bluespace Сборщик</b><br>
	Другая исследовательская станция разработала устройство, называемое Bluespace Сборщик.
	Он проникает через пространство в другие измерения, чтобы перемещаться по ним в поисках интересных объектов.<br>
	Из-за непредвиденных обстоятельств крупномасштабные испытания прототипа не смогли быть завершены на оригинальной исследовательской станции. Вместо этого это будет выполняться на вашей станции.
	Приобретите плату, постройте устройство на проволочном узле и подайте ему достаточно энергии для генерации [goal] очков добычи к концу смены.
	<br><br>
	Имейте в виду, что устройство является экспериментальным и может действовать несколько непредвиденным образом при достаточном питании.
	<br>
	Научный Директорат Nanotrasen"}

/datum/station_goal/bluespace_tap/on_report()
	var/datum/supply_packs/misc/station_goal/bluespace_tap/P = SSshuttle.supply_packs["[/datum/supply_packs/misc/station_goal/bluespace_tap]"]
	P.special_enabled = TRUE

/datum/station_goal/bluespace_tap/check_completion()
	if(..())
		return TRUE
	var/highscore = 0
	for(var/obj/machinery/power/bluespace_tap/T in GLOB.machines)
		highscore = max(highscore, T.total_points)
	to_chat(world, "<b>Рекорд Bluespace Сборщика</b>: [highscore >= goal ? "<span class='greenannounce'>": "<span class='boldannounce'>"][highscore]</span>")
	if(highscore >= goal)
		return TRUE
	return FALSE

//needed for the vending part of it
/datum/data/bluespace_tap_product
	var/product_name = "generic"
	var/product_path = null
	var/product_cost = 100	//cost in mining points to generate


/datum/data/bluespace_tap_product/New(name, path, cost)
	product_name = name
	product_path = path
	product_cost = cost

/obj/item/circuitboard/machine/bluespace_tap
	name = "Bluespace Сборщик (плата)"
	build_path = /obj/machinery/power/bluespace_tap
	origin_tech = "engineering=2;combat=2;bluespace=3"
	req_components = list(
							/obj/item/stock_parts/capacitor/quadratic = 5,//Probably okay, right?
							/obj/item/stack/ore/bluespace_crystal = 5)

/obj/effect/spawner/lootdrop/bluespace_tap
	name = "bluespace harvester reward spawner"
	lootcount = 1

/obj/effect/spawner/lootdrop/bluespace_tap/hat
	name = "exotic hat"
	loot = list(
			/obj/item/clothing/head/collectable/chef,	//same weighing on all of them
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/tophat,
			/obj/item/clothing/head/collectable/captain,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/kitty,
			/obj/item/clothing/head/crown/fancy,
			/obj/item/clothing/head/collectable/rabbitears,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/collectable/HoS,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat
	)


/obj/effect/spawner/lootdrop/bluespace_tap/cultural
	name = "cultural artifacts"
	loot = list(
		/obj/vehicle/space/speedbike/red = 10,
		/obj/item/grenade/clusterbuster/honk = 10,
		/obj/item/toy/katana = 10,
		/obj/item/stack/tile/brass/fifty = 20,
		/obj/item/stack/sheet/mineral/abductor/fifty = 20,
		/obj/item/sord = 20,
		/obj/item/toy/syndicateballoon = 15,
		/obj/item/lighter/zippo/gonzofist = 5,
		/obj/item/lighter/zippo/engraved = 5,
		/obj/item/lighter/zippo/nt_rep = 5,
		/obj/item/gun/projectile/automatic/c20r/toy = 1,
		/obj/item/gun/projectile/automatic/l6_saw/toy = 1,
		/obj/item/gun/projectile/automatic/toy/pistol = 2,
		/obj/item/gun/projectile/automatic/toy/pistol/enforcer = 1,
		/obj/item/gun/projectile/shotgun/toy = 1,
		/obj/item/gun/projectile/shotgun/toy/crossbow = 1,
		/obj/item/gun/projectile/shotgun/toy/tommygun = 1,
		/obj/item/gun/projectile/automatic/sniper_rifle/toy = 1,
		/obj/item/twohanded/dualsaber/toy = 5,
		/obj/machinery/snow_machine = 10,
		/obj/item/clothing/head/kitty = 5,
		/obj/item/coin/antagtoken = 5,
		/obj/item/toy/prizeball/figure = 15,
		/obj/item/toy/prizeball/therapy = 10,
		/obj/item/bedsheet/patriot = 2,
		/obj/item/bedsheet/rainbow = 2,
		/obj/item/bedsheet/captain = 2,
		/obj/item/bedsheet/centcom = 1, //mythic rare rarity
		/obj/item/bedsheet/syndie = 2,
		/obj/item/bedsheet/cult = 2,
		/obj/item/bedsheet/wiz = 2,
		/obj/item/stack/sheet/mineral/tranquillite/fifty = 3,
		/obj/item/clothing/gloves/combat = 5
	)

/obj/effect/spawner/lootdrop/bluespace_tap/organic
	name = "organic objects"
	loot = list(
		/obj/item/seeds/random/labelled = 50,
		/obj/item/guardiancreator/biological = 5,
		/obj/item/organ/internal/vocal_cords/adamantine = 15,
		/obj/item/storage/pill_bottle/random_meds/labelled = 25,
		/obj/item/reagent_containers/glass/bottle/reagent/omnizine = 15,
		/obj/item/dnainjector/telemut = 5,
		/obj/item/dnainjector/midgit = 5,
		/obj/item/dnainjector/morph = 5,
		/obj/item/dnainjector/regenerate = 5,
		/mob/living/simple_animal/pet/dog/corgi/ = 5,
		/mob/living/simple_animal/pet/cat = 5,
		/mob/living/simple_animal/pet/dog/fox/ = 5,
		/mob/living/simple_animal/pet/penguin = 5,
		/mob/living/simple_animal/pig = 5,
		/obj/item/slimepotion/sentience = 5,
		/obj/item/clothing/mask/cigarette/cigar/havana = 3,
		/obj/item/stack/sheet/mineral/bananium/fifty = 2,	//bananas are organic, clearly.
		/obj/item/storage/box/monkeycubes = 5,
		/obj/item/stack/tile/carpet/twenty = 10,
		/obj/item/stack/tile/carpet/black/twenty = 10,
		/obj/item/soap/deluxe = 5
	)

/obj/effect/spawner/lootdrop/bluespace_tap/food
	name = "fancy food"
	lootcount = 3
	loot = list(
		/obj/item/reagent_containers/food/snacks/wingfangchu,
		/obj/item/reagent_containers/food/snacks/hotdog,
		/obj/item/reagent_containers/food/snacks/sliceable/turkey,
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/appletart,
		/obj/item/reagent_containers/food/snacks/sliceable/cheesecake,
		/obj/item/reagent_containers/food/snacks/sliceable/bananacake,
		/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake,
		/obj/item/reagent_containers/food/snacks/soup/meatballsoup,
		/obj/item/reagent_containers/food/snacks/soup/mysterysoup,
		/obj/item/reagent_containers/food/snacks/soup/stew,
		/obj/item/reagent_containers/food/snacks/soup/hotchili,
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/fishburger,
		/obj/item/reagent_containers/food/snacks/cubancarp,
		/obj/item/reagent_containers/food/snacks/fishandchips,
		/obj/item/reagent_containers/food/snacks/meatpie,
		/obj/item/pizzabox/hawaiian, //it ONLY gives hawaiian. MUHAHAHA
		/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread //maybe add some dangerous/special food here, ie robobuger?
	)

#define kW *1000
#define MW kW *1000
#define GW MW *1000

/**
  * # Bluespace Harvester
  *
  * A station goal that consumes enormous amounts of power to generate (mostly fluff) rewards
  *
  * A machine that takes power each tick, generates points based on it
  * and lets you spend those points on rewards. A certain amount of points
  * has to be generated for the station goal to count as completed.
  */
/obj/machinery/power/bluespace_tap
	name = "Bluespace harvester"
	icon = 'icons/obj/machines/bluespace_tap.dmi'
	icon_state = "bluespace_tap"	//sprites by Ionward
	max_integrity = 300
	pixel_x = -32	//shamelessly stolen from dna vault
	pixel_y = -64
	/// For faking having a big machine, dummy 'machines' that are hidden inside the large sprite and make certain tiles dense. See new and destroy.
	var/list/obj/structure/fillers = list()
	use_power = NO_POWER_USE	// power usage is handelled manually
	density = TRUE
	interact_offline = TRUE
	luminosity = 1

	/// Correspond to power required for a mining level, first entry for level 1, etc.
	var/list/power_needs = list(1 kW, 5 kW, 50 kW, 100 kW, 500 kW,
								1 MW, 2 MW, 5 MW, 10 MW, 25 MW,
								50 MW, 75 MW, 125 MW, 200 MW, 500 MW,
								1 GW, 5 GW, 15 GW, 45 GW, 500 GW)

	/// list of possible products
	var/static/product_list = list(
	new /datum/data/bluespace_tap_product("Unknown Exotic Hat", /obj/effect/spawner/lootdrop/bluespace_tap/hat, 5000),
	new /datum/data/bluespace_tap_product("Unknown Snack", /obj/effect/spawner/lootdrop/bluespace_tap/food, 6000),
	new /datum/data/bluespace_tap_product("Unknown Cultural Artifact", /obj/effect/spawner/lootdrop/bluespace_tap/cultural, 15000),
	new /datum/data/bluespace_tap_product("Unknown Biological Artifact", /obj/effect/spawner/lootdrop/bluespace_tap/organic, 20000)
	)

	/// The level the machine is currently mining at. 0 means off
	var/input_level = 0
	/// The machine you WANT the machine to mine at. It will try to match this.
	var/desired_level = 0
	/// Available mining points
	var/points = 0
	/// The total points earned by this machine so far, for tracking station goal and highscore
	var/total_points = 0
	/// How much power the machine needs per processing tick at the current level.
	var/actual_power_usage = 0


	// Tweak these and active_power_usage to balance power generation

	/// Max power input level, I don't expect this to be ever reached
	var/max_level = 20
	/// Amount of points to give per mining level
	var/base_points = 4
	/// How high the machine can be run before it starts having a chance for dimension breaches.
	var/safe_levels = 10


/obj/machinery/power/bluespace_tap/New()
	..()
	//more code stolen from dna vault, inculding comment below. Taking bets on that datum being made ever.
	//TODO: Replace this,bsa and gravgen with some big machinery datum
	var/list/occupied = list()
	for(var/direct in list(EAST, WEST, SOUTHEAST, SOUTHWEST))
		occupied += get_step(src, direct)
	occupied += locate(x + 1, y - 2, z)
	occupied += locate(x - 1, y - 2, z)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/bluespace_tap(null)
	for(var/i = 1 to 5)	//five of each
		component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
		component_parts += new /obj/item/stack/ore/bluespace_crystal(null)
	if(!powernet)
		connect_to_network()

/obj/machinery/power/bluespace_tap/Destroy()
	QDEL_LIST(fillers)
	return ..()

/**
  * Increases the desired mining level
  *
  * Increases the desired mining level, that
  * the machine tries to reach if there
  * is enough power for it. Note that it does
  * NOT increase the actual mining level directly.
  */
/obj/machinery/power/bluespace_tap/proc/increase_level()
	if(desired_level < max_level)
		desired_level++
/**
  * Decreases the desired mining level
  *
  * Decreases the desired mining level, that
  * the machine tries to reach if there
  * is enough power for it. Note that it does
  * NOT decrease the actual mining level directly.
  */
/obj/machinery/power/bluespace_tap/proc/decrease_level()
	if(desired_level > 0)
		desired_level--

/**
  * Sets the desired mining level
  *
  * Sets the desired mining level, that
  * the machine tries to reach if there
  * is enough power for it. Note that it does
  * NOT change the actual mining level directly.
  * Arguments:
  * * t_level - The level we try to set it at, between 0 and max_level
 */
/obj/machinery/power/bluespace_tap/proc/set_level(t_level)
	if(t_level < 0)
		return
	if(t_level > max_level)
		return
	desired_level = t_level

/**
  * Gets the amount of power at a set input level
  *
  * Gets the amount of power (in W) a set input level needs.
  * Note that this is not necessarily the current power use.
  * * i_level - The hypothetical input level for which we want to know the power use.
  */
/obj/machinery/power/bluespace_tap/proc/get_power_use(i_level)
	if(!i_level)
		return 0
	return power_needs[i_level]

/obj/machinery/power/bluespace_tap/process()
	actual_power_usage = get_power_use(input_level)
	if(surplus() < actual_power_usage)	//not enough power, so turn down a level
		input_level--
		return	// and no mining gets done
	if(actual_power_usage)
		add_load(actual_power_usage)
		var/points_to_add = (input_level + emagged) * base_points
		points += points_to_add	//point generation, emagging gets you 'free' points at the cost of higher anomaly chance
		total_points += points_to_add
	// actual input level changes slowly
	if(input_level < desired_level && (surplus() >= get_power_use(input_level + 1)))
		input_level++
	else if(input_level > desired_level)
		input_level--
	if(prob(input_level - safe_levels + (emagged * 5)))	//at dangerous levels, start doing freaky shit. prob with values less than 0 treat it as 0
		GLOB.event_announcement.Announce("Unexpected power spike during Bluespace Harvester Operation. Extra-dimensional intruder alert. Expected location: [get_area(src)]. [emagged ? "DANGER: Emergency shutdown failed! Please proceed with manual shutdown." : "Emergency shutdown initiated."]", "Bluespace Harvester Malfunction")
		if(!emagged)
			input_level = 0	//emergency shutdown unless we're sabotaged
			desired_level = 0
		for(var/i in 1 to rand(1, 3))
			var/turf/location = locate(x + rand(-5, 5), y + rand(-5, 5), z)
			new /obj/structure/spawner/nether/bluespace_tap(location)



/obj/machinery/power/bluespace_tap/ui_data(mob/user)
	var/list/data = list()

	data["desiredLevel"] = desired_level
	data["inputLevel"] = input_level
	data["points"] = points
	data["totalPoints"] = total_points
	data["powerUse"] = actual_power_usage
	data["availablePower"] = surplus()
	data["maxLevel"] = max_level
	data["emagged"] = emagged
	data["safeLevels"] = safe_levels
	data["nextLevelPower"] = get_power_use(input_level + 1)

	/// A list of lists, each inner list equals a datum
	var/list/listed_items = list()
	for(var/key = 1 to length(product_list))
		var/datum/data/bluespace_tap_product/A = product_list[key]
		listed_items[++listed_items.len] = list(
				"key" = key,
				"name" = A.product_name,
				"price" = A.product_cost)
	data["product"] = listed_items
	return data


/obj/machinery/power/bluespace_tap/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/power/bluespace_tap/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/power/bluespace_tap/attack_ai(mob/user)
	ui_interact(user)

/**
  * Produces the product with the desired key and increases product cost accordingly
  */
/obj/machinery/power/bluespace_tap/proc/produce(key)
	if(key <= 0 || key > length(product_list))	//invalid key
		return
	var/datum/data/bluespace_tap_product/A = product_list[key]
	if(!A)
		return
	if(A.product_cost > points)
		return
	points -= A.product_cost
	A.product_cost = round(1.2 * A.product_cost, 1)
	playsound(src, 'sound/magic/blink.ogg', 50)
	do_sparks(2, FALSE, src)
	new A.product_path(get_turf(src))



//UI stuff below

/obj/machinery/power/bluespace_tap/ui_act(action, params)
	if(..())
		return
	. = TRUE	// we want to refresh in all the cases below
	switch(action)
		if("decrease")
			decrease_level()
		if("increase")
			increase_level()
		if("set")
			set_level(text2num(params["set_level"]))
		if("vend")//it's not really vending as producing, but eh
			var/key = text2num(params["target"])
			produce(key)

/obj/machinery/power/bluespace_tap/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = TRUE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "BluespaceTap", name, 650, 400, master_ui, state)
		ui.open()

//emaging provides slightly more points but at much greater risk
/obj/machinery/power/bluespace_tap/emag_act(mob/living/user as mob)
	if(emagged)
		return
	emagged = TRUE
	do_sparks(5, FALSE, src)
	if(user)
		user.visible_message("<span class='warning'>[user] overrides the safety protocols of [src].</span>", "<span class='warning'>You override the safety protocols.</span>")

/obj/structure/spawner/nether/bluespace_tap
	spawn_time = 30 SECONDS
	max_mobs = 5		//Dont' want them overrunning the station
	max_integrity = 250

/obj/structure/spawner/nether/bluespace_tap/deconstruct(disassembled)
	new /obj/item/stack/ore/bluespace_crystal(loc)	//have a reward
	return ..()

/obj/item/paper/bluespace_tap
	name = "'Экспериментальный Bluespace Сборщик NT - Добыча полезных ископаемых в других вселенных для науки и получения прибыли!'"
	info = "<h1>Важные Инструкции!</h1>Пожалуйста, следуйте всем инструкциям по настройке, чтобы обеспечить правильную работу. <br>\
	1. Создайте проводной узел с достаточным доступом к запасному питанию. Устройство работает независимо от ЛКП. <br>\
	2. Создайте каркас машины как обычно на проводном узле с учетом размеров устройства (3 на 3 метра). <br>\
	3. Вставьте проводку, плату и необходимые компоненты. Завершите строительство в соответствии со стандартами Инженерии NT. <br>\
	4. Убедитесь, что устройство подключено к соответствующей сети электропитания и что имеется достаточно питания. <br>\
	5. Установите машину на нужный уровень. Периодически проверяйте ход работы машины. <br>\
	6. По желанию, потратьте заработанные очки на веселые и увлекательные награды. <br><hr>\
	<h2>Операционные Принципы</h2> \
	<p>Bluespace Сборщик способен принимать почти безграничное количество энергии для поиска в других вселенных ценностей, которые можно вернуть. Скорость этого поиска контролируется с помощью управления 'уровня' устройства. \
	В то время как он может быть запущен на низком уровне практически любой системой выработки электроэнергии, более высокие уровни требуют работы специальной инженерной команды для питания. \
	Поскольку мы заинтересованы в тестировании того, как устройство работает в условиях стресса, мы хотим призвать вас провести стресс-тестирование и посмотреть, сколько энергии вы можете выделять. \
	По этой причине общее производство очков смены будет рассчитано и объявлено в конце смены. Высокие итоговые суммы могут привести к премиальной выплате сотрудникам инженерного отдела. <p>\
	<p>Научный Директорат Nanotrasen, Исследовательская группа по экстрапространственной эксплуатации</p> \
	<p><small>Устройство в высшей степени экспериментальности. Не продается. Не работайте рядом с маленькими детьми или жизненно важными активами NT. Не вмешивайтесь в работу машины. В случае экзистенциального страха немедленно остановите машину. \
	Пожалуйста, документируйте любые вторжения в другие измерения. В случае неминуемой смерти, пожалуйста, оставьте указанную документацию на виду, чтобы команды по очистке могли восстановить её.</small></p>"

#undef kW
#undef MW
#undef GW
