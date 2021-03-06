
/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_health = 70
	relative_size = 60
	scarring_effect = 4

/obj/item/organ/internal/liver/robotize()
	. = ..()
	icon_state = "liver-prosthetic"

/obj/item/organ/internal/liver/Process()

	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			to_chat(owner, "<span class='danger'>Your skin itches.</span>")
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	//Detox can heal small amounts of damage
	if (health > 0 && !owner.chem_effects[CE_TOXIN])
		heal_damage(0.2 * owner.chem_effects[CE_ANTITOX])

	// Get the effectiveness of the liver.
	var/filter_effect = 3
	if(is_bruised())
		filter_effect -= 1
	if(is_broken())
		filter_effect -= 2
	// Robotic organs filter better but don't get benefits from dylovene for filtering.
	if(BP_IS_ROBOTIC(src))
		filter_effect += 1
	else if(owner.chem_effects[CE_ANTITOX])
		filter_effect += 1

	// If you're not filtering well, you're in trouble. Ammonia buildup to toxic levels and damage from alcohol
	if(filter_effect < 2)
		if(owner.reagents.get_reagent_amount(/datum/reagent/ammonia) < 6)
			owner.reagents.add_reagent(/datum/reagent/ammonia, REM)
		if(owner.chem_effects[CE_ALCOHOL])
			owner.adjustToxLoss(0.5 * max(2 - filter_effect, 0) * (owner.chem_effects[CE_ALCOHOL_TOXIC] + 0.5 * owner.chem_effects[CE_ALCOHOL]))

	if(owner.chem_effects[CE_ALCOHOL_TOXIC])
		take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC], silent=prob(90)) // Chance to warn them

	// Heal a bit if needed and we're not busy. This allows recovery from low amounts of toxloss.
	if(!owner.chem_effects[CE_ALCOHOL] && !owner.chem_effects[CE_TOXIN] && !owner.radiation && isdamaged())
		if(get_damages() < min_broken_damage)
			heal_damage(0.2)
		if(get_damages() < min_bruised_damage)
			heal_damage(0.3)

	//Blood regeneration if there is some space
	var/blood_volume_raw = owner.vessel.get_reagent_amount(/datum/reagent/blood)
	if(blood_volume_raw < species.blood_volume)
		var/datum/reagent/blood/B = owner.get_blood(owner.vessel)
		if(istype(B))
			B.volume += 0.1 + owner.chem_effects[CE_BLOODRESTORE] // regenerate blood VERY slowly

	// Blood loss or liver damage make you lose nutriments
	var/blood_volume = owner.get_blood_volume()
	if(blood_volume < BLOOD_VOLUME_SAFE || is_bruised())
		if(owner.nutrition >= 300)
			owner.nutrition -= 10
		else if(owner.nutrition >= 200)
			owner.nutrition -= 3

	if(owner.chem_effects[CE_ALCOHOL] && scarred) // If your liver is messed up, you can't hold liqour very well
		if(prob(scarred*scarred)) // Scarring 1 == 1%, Scarring 2 == 4%, Scarring 3 == 9%
			spawn owner.vomit()
