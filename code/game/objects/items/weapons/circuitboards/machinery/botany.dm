#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/biogenerator
	name = T_BOARD("biogenerator")
	build_path = /obj/machinery/biogenerator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)
/obj/item/weapon/circuitboard/botany_extractor
	name = T_BOARD(Lysis-Isolation Centrifuge)
	build_path = /obj/machinery/botany/extractor
	board_type = "machine"
	origin_tech = "biotech=3;programming=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/botany_editor
	name = T_BOARD(Bioballistic Delivery System)
	build_path = /obj/machinery/botany/editor
	board_type = "machine"
	origin_tech = "biotech=3;programming=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)