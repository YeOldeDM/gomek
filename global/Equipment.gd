extends Node

enum {
	DE, # Direct-Fire Energy
	DB, # Direct-Fire Ballistic
	M,  # Missile
	AI, # Anti-Infantry
	C,  # Cluster
	}

var weapons = {
	# Autocannons
	"Autocannon/2":	{
		"tags":	[DB],
		"short_name":	"AC/2",
		"heat":	1,
		"damage":	2,
		"range":	[4,8,16,24],
		"ammo":	45,
		},
	"Autocannon/5":	{
		"tags":	[DB],
		"short_name":	"AC/5",
		"heat":	1,
		"damage":	5,
		"range":	[3,6,12,18],
		"ammo":	20,
		},
	"Autocannon/10":	{
		"tags":	[DB],
		"short_name":	"AC/10",
		"heat":	3,
		"damage":	10,
		"range":	[0,5,10,15],
		"ammo":	10,
		},
	"Autocannon/20":	{
		"tags":	[DB],
		"short_name":	"AC/20",
		"heat":	7,
		"damage":	20,
		"range":	[0,3,6,9],
		"ammo":	5,
		},
	
	# Machine Guns
	"Machine Gun":	{
		"tags":	[DB,AI],
		"short_name":	"MG",
		"damage":	2,
		"range":	[0,1,2,3],
		"ammo":	200,
		},

	#SRMs
	"SRM 2":	{
		"tags":	[M,C],
		"heat":	2,
		"damage":	2,
		"cluster":	[2,2],
		"range":	[0,3,6,9],
		"ammo":	50,
		},
	"SRM 4":	{
		"tags":	[M,C],
		"heat":	3,
		"damage":	2,
		"cluster":	[2,2],
		"range":	[0,3,6,9],
		"ammo":	25,
		},
	"SRM 6":	{
		"tags":	[M,C],
		"heat":	4,
		"damage":	2,
		"cluster":	[2,2],
		"range":	[0,3,6,9],
		"ammo":	15,
		},
	
	# LRMs
	"LRM 5":	{
		"tags":	[M,C],
		"heat":	2,
		"damage":	1,
		"cluster":	[5,5],
		"range":	[6,7,14,21],
		"ammo":	24,
		},
	"LRM 10":	{
		"tags":	[M,C],
		"heat":	2,
		"damage":	1,
		"cluster":	[5,10],
		"range":	[6,7,14,21],
		"ammo":	12,
		},
	"LRM 15":	{
		"tags":	[M,C],
		"heat":	5,
		"damage":	1,
		"cluster":	[5,15],
		"range":	[6,7,14,21],
		"ammo":	8,
		},
	"LRM 20":	{
		"tags":	[M,C],
		"heat":	6,
		"damage":	1,
		"cluster":	[5,20],
		"range":	[6,7,14,21],
		"ammo":	6,
		},

	# Lasers
	"Small Laser":	{
		"tags":	[DE],
		"short_name":	"SL",
		"heat":	1,
		"damage":	3,
		"range":	[0,1,2,3],
		},
	"Medium Laser":	{
		"tags":	[DE],
		"short_name":	"ML",
		"heat":	3,
		"damage":	5,
		"range":	[0,3,6,9],
		},
	"Large Laser":	{
		"tags":	[DE],
		"short_name":	"LL",
		"heat":	8,
		"damage":	8,
		"range":	[0,5,10,15],
		},

	# PPCs
	"ParticleCannon":	{
		"tags":	[DE],
		"short_name":	"PPC",
		"heat":	10,
		"damage":	10,
		"range":	[3,6,12,18],
		},
	}
