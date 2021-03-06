////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 50
	container_type = OPENCONTAINER
	has_lid = TRUE
	resistance_flags = ACID_PROOF
	var/label_text = ""

/obj/item/reagent_containers/glass/New()
	..()
	base_name = name

/obj/item/reagent_containers/glass/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2 && !is_open_container())
		. += "<span class='notice'>Воздухонепроницаемая крышка полностью герметизирует его.</span>"

/obj/item/reagent_containers/glass/attack(mob/M, mob/user, def_zone)
	if(!is_open_container())
		return ..()

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] пуста!</span>")
		return

	if(istype(M))
		var/list/transferred = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			transferred += R.name
		var/contained = english_list(transferred)

		if(user.a_intent == INTENT_HARM)
			M.visible_message("<span class='danger'>[user] разбрызгивает содержимое [src] на [M]!</span>", \
							"<span class='userdanger'>[user] разбрызгивает содержимое [src] на [M]!</span>")
			add_attack_logs(user, M, "Обрызгал [name] содержащее: [contained]", !!M.ckey ? null : ATKLOG_ALL)

			reagents.reaction(M, REAGENT_TOUCH)
			reagents.clear_reagents()
		else
			if(!iscarbon(M)) // Non-carbons can't process reagents
				to_chat(user, "<span class='warning'>Ты не можешь найти способ, как напоить [M].</span>")
				return
			if(M != user)
				M.visible_message("<span class='danger'>[user] пытается чем-то напоить [M].</span>", \
							"<span class='userdanger'>[user] пытается чем-то вас напоить.</span>")
				if(!do_mob(user, M))
					return
				if(!reagents || !reagents.total_volume)
					return // The drink might be empty after the delay, such as by spam-feeding
				M.visible_message("<span class='danger'>[user] чем-то напоил [M].</span>", "<span class='userdanger'>[user] чем-то тебя напоил.</span>")
				add_attack_logs(user, M, "напоил [name] содержащее: [contained]", !!M.ckey ? null : ATKLOG_ALL)
			else
				to_chat(user, "<span class='notice'> Ты делаешь глоток [src].</span>")

			var/fraction = min(5 / reagents.total_volume, 1)
			reagents.reaction(M, REAGENT_INGEST, fraction)
			addtimer(CALLBACK(reagents, /datum/reagents.proc/trans_to, M, 5), 5)
			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)

/obj/item/reagent_containers/glass/afterattack(obj/target, mob/user, proximity)
	if((!proximity) ||  !check_allowed_items(target,target_self = TRUE))
		return

	if(!is_open_container())
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>Пусто!</span>")
			return

		if(target.reagents.holder_full())
			to_chat(user, "<span class='warning'>[target] полон!</span>")
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>Вы перегнали [trans] юнит/ов в [target].</span>")

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='warning'>[target] пуст и не может быть наполнен снова!</span>")
			return

		if(reagents.holder_full())
			to_chat(user, "<span class='warning'>[src] заполнен.</span>")
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>Ты заполняешь [src] с [trans] юнит/ов содержимого [target].</span>")

	else if(reagents.total_volume)
		if(user.a_intent == INTENT_HARM)
			user.visible_message("<span class='danger'>[user] разбрызгивает содержимое [src] на [target]!</span>", \
								"<span class='notice'>Ты выплескиваешь содержимое [src] на [target].</span>")
			reagents.reaction(target, REAGENT_TOUCH)
			reagents.clear_reagents()

/obj/item/reagent_containers/glass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen) || istype(I, /obj/item/flashlight/pen))
		var/t = rename_interactive(user, I)
		if(!isnull(t))
			label_text = t
	else
		return ..()

/obj/item/reagent_containers/glass/beaker
	name = "Мензурка"
	desc = "Мензурка. Может содержать 50 юнитов."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	materials = list(MAT_GLASS=500)
	var/obj/item/assembly_holder/assembly = null
	var/can_assembly = 1

/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "[icon_state]-10"
			if(10 to 24)
				filling.icon_state = "[icon_state]10"
			if(25 to 49)
				filling.icon_state = "[icon_state]25"
			if(50 to 74)
				filling.icon_state = "[icon_state]50"
			if(75 to 79)
				filling.icon_state = "[icon_state]75"
			if(80 to 90)
				filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid
	if(assembly)
		overlays += "assembly"
	..()

/obj/item/reagent_containers/glass/beaker/verb/remove_assembly()
	set name = "Remove Assembly"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return
	if(assembly)
		to_chat(usr, "<span class='notice'>Вы отделяете [assembly] от [src]</span>")
		usr.put_in_hands(assembly)
		assembly = null
		qdel(GetComponent(/datum/component/proximity_monitor))
		update_icon()
	else
		to_chat(usr, "<span class='notice'>Нет сборки, которую нужно удалить.</span>")

/obj/item/reagent_containers/glass/beaker/proc/heat_beaker()
	if(reagents)
		reagents.temperature_reagents(4000)

/obj/item/reagent_containers/glass/beaker/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/assembly_holder) && can_assembly)
		if(assembly)
			to_chat(usr, "<span class='warning'>[src] уже собран.</span>")
			return ..()
		assembly = W
		user.drop_item()
		W.forceMove(src)
		if(assembly.has_prox_sensors())
			AddComponent(/datum/component/proximity_monitor)
		overlays += "assembly"
	else
		..()

/obj/item/reagent_containers/glass/beaker/HasProximity(atom/movable/AM)
	if(assembly)
		assembly.HasProximity(AM)

/obj/item/reagent_containers/glass/beaker/Crossed(atom/movable/AM, oldloc)
	if(assembly)
		assembly.Crossed(AM, oldloc)

/obj/item/reagent_containers/glass/beaker/on_found(mob/finder) //for mousetraps
	if(assembly)
		assembly.on_found(finder)

/obj/item/reagent_containers/glass/beaker/hear_talk(mob/living/M, list/message_pieces)
	if(assembly)
		assembly.hear_talk(M, message_pieces)

/obj/item/reagent_containers/glass/beaker/hear_message(mob/living/M, msg)
	if(assembly)
		assembly.hear_message(M, msg)

/obj/item/reagent_containers/glass/beaker/large
	name = "Большая мензурка"
	desc = "Большая мензурка. Может вместить до 100 юнитов."
	icon_state = "beakerlarge"
	materials = list(MAT_GLASS=2500)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	container_type = OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/vial
	name = "Флакон"
	desc = "Маленький стеклянный флакончик. Может вместить до 25 юнитов."
	icon_state = "vial"
	materials = list(MAT_GLASS=250)
	volume = 25
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	container_type = OPENCONTAINER
	can_assembly = 0

/obj/item/reagent_containers/glass/beaker/drugs
	name = "Пакетик"
	desc = "Пакетик. Может вместить до 10 юнитов."
	icon_state = "baggie"
	amount_per_transfer_from_this = 2
	possible_transfer_amounts = 2
	volume = 10
	container_type = OPENCONTAINER
	can_assembly = 0

/obj/item/reagent_containers/glass/beaker/thermite
	name = "Термит"
	desc = "Пакетик термита. Может содержать до 20 юнитов."
	icon_state = "baggie"
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = 20
	volume = 20
	container_type = OPENCONTAINER
	can_assembly = 0
	list_reagents = list("thermite" = 20)

/obj/item/reagent_containers/glass/beaker/noreact
	name = "Мензурка для криостаза"
	desc = "мензурка для криостаза, которая позволяет хранить химические вещества без реакций. Может вместить до 50 юнитов."
	icon_state = "beakernoreact"
	materials = list(MAT_METAL=3000)
	volume = 50
	amount_per_transfer_from_this = 10
	origin_tech = "materials=2;engineering=3;plasmatech=3"
	container_type = OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/noreact/New()
	..()
	reagents.set_reacting(FALSE)

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "Bluespace мензурка"
	desc = "Bluespace мензурка, работает на основе экспериментальной технологии Bluespace и Element Cuban в сочетании с соединениями Пита. Может вместить до 300 юнитов."
	icon_state = "beakerbluespace"
	materials = list(MAT_GLASS=3000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100,300)
	container_type = OPENCONTAINER
	origin_tech = "bluespace=5;materials=4;plasmatech=4"

/obj/item/reagent_containers/glass/beaker/cryoxadone
	list_reagents = list("cryoxadone" = 30)

/obj/item/reagent_containers/glass/beaker/sulphuric
	list_reagents = list("sacid" = 50)


/obj/item/reagent_containers/glass/beaker/slime
	list_reagents = list("slimejelly" = 50)

/obj/item/reagent_containers/glass/beaker/drugs/meth
	list_reagents = list("methamphetamine" = 10)


/obj/item/reagent_containers/glass/bucket
	desc = "Это ведро."
	name = "Ведро"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	materials = list(MAT_METAL=200)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,80,100,120)
	volume = 120
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 75, "acid" = 50) //Weak melee protection, because you can wear it on your head
	slot_flags = SLOT_HEAD
	resistance_flags = NONE
	container_type = OPENCONTAINER

/obj/item/reagent_containers/glass/bucket/wooden
	name = "Деревянное ведро"
	icon_state = "woodbucket"
	item_state = "woodbucket"
	materials = null
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 50)
	resistance_flags = FLAMMABLE

/obj/item/reagent_containers/glass/bucket/equipped(mob/user, slot)
    ..()
    if(slot == slot_head && reagents.total_volume)
        to_chat(user, "<span class='userdanger'>Содержимое [src] выливается на тебя!</span>")
        reagents.reaction(user, REAGENT_TOUCH)
        reagents.clear_reagents()

/obj/item/reagent_containers/glass/bucket/attackby(obj/D, mob/user, params)
	if(isprox(D))
		to_chat(user, "Ты добавил [D] к [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		user.unEquip(src)
		qdel(src)
	else
		..()

/obj/item/reagent_containers/glass/beaker/waterbottle
	name = "Бутылка воды"
	desc = "Бутылка воды, наполненная на заводе по розливу старой Земли."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "smallbottle"
	item_state = "bottle"
	list_reagents = list("water" = 49.5, "fluorine" = 0.5) //see desc, don't think about it too hard
	materials = list(MAT_GLASS = 0)
	volume = 50
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/glass/beaker/waterbottle/empty
	list_reagents = list()

/obj/item/reagent_containers/glass/beaker/waterbottle/large
	desc = "свежая бутылка воды коммерческого размера."
	icon_state = "largebottle"
	materials = list(MAT_GLASS = 0)
	list_reagents = list("water" = 100)
	volume = 100
	amount_per_transfer_from_this = 20

/obj/item/reagent_containers/glass/beaker/waterbottle/large/empty
	list_reagents = list()
