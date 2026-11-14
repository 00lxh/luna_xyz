local luna_metadata = {};

local status_data = {

	Working = {

		Color = "🟢"; Priority = 1;
		Description = "Service is fully operational and running normally.";
	};

	Maintenance = {

		Color = "🟡"; Priority = 2;
		Description = "Service is currently under maintenance or being updated.";
	};

	Development = {

		Color = "🟠"; Priority = 3;
		Description = "Service is currently in development and is not yet available.";
	};

	Beta = {

		Color = "🟣"; Priority = 4;
		Description = "Service is in beta and only available to beta testers.";
	};

	Down = {

		Color = "🔴"; Priority = 5;
		Description = "Service is currently offline due to an issue. Please wait for an update.";
	};
};

local scripts_data = {

	luna_xyz = {

		Listed = true; Priority = 1; CustomName = "luna.xyz";
		Status = "Working"; Version = "v8.3.7";
	};

	the_rakoof = {

		GameId = 5300929388; LobbyGameId = nil; Priority = 3;
		Listed = true; Status = "Working"; Version = "v3.2.2";
	};

	rake_remastered = {

		GameId = 847722000; LobbyGameId = nil; Priority = 4;
		Listed = true; Status = "Working"; Version = "v2.4.3";
	};

	project_lazarus = {

		GameId = 169302362; LobbyGameId = nil; Priority = 5;
		Listed = true; Status = "Working"; Version = "v1.0.3";	
	};

	violence_district = {

		GameId = 6739698191; LobbyGameId = nil; Priority = 6;
		Listed = true; Status = "Maintenance"; Version = "v1.3.5";	
	};

	chain = {

		GameId = 3741075732; LobbyGameId = 10204250851; Priority = 7;
		Listed = true; Status = "Development"; Version = "v1.0.0";	
	};

	skibidi_game = {

		GameId = 8652734071; LobbyGameId = nil; Priority = math.huge;
		Listed = false; Status = "Working"; Version = "v1.0.0";	
	};
};

local moon_facts = {
	"The Moon is drifting away from Earth at about 3.8 centimeters per year.";
	"The same side of the Moon always faces Earth due to tidal locking.";
	"A day on the Moon (sunrise to sunrise) lasts about 29.5 Earth days.";
	"The Moon has moonquakes, some caused by Earth's gravity.";
	"Footprints left on the Moon can last for millions of years due to no atmosphere.";
	"The Moon has no atmosphere, so there is no weather or wind.";
	"The far side of the Moon was first seen by humans in 1959.";
	"The Moon is the fifth largest moon in the solar system.";
	"The Moon's gravity is about one-sixth of Earth's gravity.";
	"There is water ice on the Moon, especially in permanently shadowed craters.";
	"The Moon was formed about 4.5 billion years ago after a giant impact.";
	"The Moon helps stabilize Earth's rotation and climate.";
	"Temperatures on the Moon can range from about -173°C to 127°C.";
	"The Moon has mountains higher than Mount Everest.";
	"Astronauts brought back about 382 kilograms of Moon rocks.";
	"The Moon has a very weak magnetic field compared to Earth.";
	"The Moon causes tides in Earth's oceans.";
	"The first human landing on the Moon was in 1969";
	"The Moon reflects sunlight, it does not produce its own light.";
	"There are no sounds on the Moon because there is no air.";
	"The Moon is slowly becoming tidally locked more strongly over time, stabilizing its rotation even further.";
	"The Moon has a diameter of about 3,474 kilometers, roughly one-quarter the size of Earth.";
	"The Moon’s surface is covered in a fine dust called regolith.";
	"There are over 1,600 named craters on the Moon.";
	"The largest crater on the Moon is the South Pole–Aitken basin.";
	"The Moon has no liquid water on its surface due to lack of atmosphere and pressure.";
	"The Moon experiences extreme temperature changes because it lacks an atmosphere.";
	"The Moon’s orbit around Earth takes about 27.3 days (sidereal month).";
	"The Moon appears larger near the horizon due to the Moon illusion.";
	"The Moon has 'seas' called maria, which are actually solidified lava plains.";
	"The Moon's core is very small compared to Earth's core.";
	"The Moon has been visited by 12 astronauts in total.";
	"The Moon’s gravity affects not only oceans but also Earth’s crust slightly.";
	"The Moon has tiny amounts of an atmosphere called an exosphere.";
	"The Moon is gradually slowing Earth's rotation over millions of years.";
	"The Moon’s surface is darker than it appears, similar to worn asphalt.";
	"The Moon has no protection from space radiation or meteorites.";
	"Some craters on the Moon have never seen sunlight.";
	"The Moon was once much closer to Earth and appeared larger in the sky.";
	"The Moon helps create eclipses when it aligns with Earth and the Sun.";
};

function luna_metadata:GetGamesMetadata()
	return scripts_data;
end;

function luna_metadata:GetStatusMetadata()
	return status_data;
end;

function luna_metadata:GetMoonMetadata()
	return moon_facts;
end;

return luna_metadata;
