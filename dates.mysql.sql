# Author: Edward Crichton

# returns whether a date falls in a holiday or not
DROP FUNCTION IF EXISTS fallsInHoliday;

delimiter //

create function fallsInHoliday(date_in date)
	RETURNS int(1)
	
main:BEGIN
	declare currentYear varchar(5);
	declare yearEnd_par date;
	declare newYear_par date;
	declare christmasClose_par date;
	
	
	# when are the holidays?
	# weekends
	
	# the bank holidays are:
	# New years day
	# good friday
	# easter monday
	# may day
	# spring bank
	# summer bank
	# christmas
	# boxing day
	# office closures for easter thursday, and christmas
	
	# week end
	IF DAYOFWEEK(date_in)=1 OR DAYOFWEEK(date_in)=7
	THEN
	
		RETURN 1;
	
	END IF;
	
	SET currentYear=EXTRACT(YEAR FROM date_in);
	
	# New years day in lieu of weekend:
	IF EXTRACT(MONTH FROM date_in)=1
	THEN
	
		IF DAYOFWEEK(CONCAT(currentYear,'-01-01'))=1 AND date_in=CONCAT(currentYear,'-01-02')
		THEN
			RETURN 1;
		END IF;
		
		IF DAYOFWEEK(CONCAT(currentYear,'-01-01'))=7 AND date_in=CONCAT(currentYear,'-01-03')
		THEN
			RETURN 1;
		END IF;
		
		IF date_in=CONCAT(currentYear,'-01-01')
		THEN
			RETURN 1;
		END IF;
	END IF;
	
	# Office thursday, Good friday, Easter monday
	
	IF EXTRACT(MONTH FROM date_in)=3 OR EXTRACT(MONTH FROM date_in)=4
	THEN
	
		IF date_in=DATE_SUB(easter(currentYear),INTERVAL 3 day) OR date_in=DATE_SUB(easter(currentYear),INTERVAL 2 day) OR date_in=DATE_ADD(easter(currentYear),INTERVAL 1 day)
		THEN
			RETURN 1;
		END IF;
	END IF;
	
	# may day, spring bank. 1st and last monday in may.
	IF EXTRACT(MONTH FROM date_in)=5
	THEN
	
		IF DAYOFWEEK(CONCAT(currentYear,'-05-31'))>=2 AND date_in=DATE_ADD( CONCAT(currentYear,'-05-31'), INTERVAL ( 2 - DAYOFWEEK(  CONCAT(currentYear,'-05-31')  ) ) DAY )
		THEN
			RETURN 1;
		END IF;
		
		IF DAYOFWEEK(CONCAT(currentYear,'-05-31'))=1 AND date_in=DATE_ADD(CONCAT(currentYear,'-05-24'), INTERVAL (2-DAYOFWEEK(CONCAT(currentYear,'-05-31'))) DAY)
		THEN
			RETURN 1;
		END IF;
		
		
		IF (2-DAYOFWEEK(CONCAT(currentYear,'-05-01')))>=0 AND date_in=DATE_ADD( CONCAT(currentYear,'-05-01'), INTERVAL ( 2- DAYOFWEEK(  CONCAT(currentYear,'-05-01') ) ) DAY )
		THEN
			RETURN 1;
		END IF;
		
		
		IF (2-DAYOFWEEK(CONCAT(currentYear,'-05-01')))<0 AND date_in=DATE_ADD(CONCAT(currentYear,'-05-01'), INTERVAL ( 9 - DAYOFWEEK(CONCAT(currentYear,'-05-01') ) ) DAY)
		THEN
			RETURN 1;
		END IF;
		
	END IF;
	
	IF EXTRACT(MONTH FROM date_in)=8
	THEN
	
		IF DAYOFWEEK(CONCAT(currentYear,'-08-31'))>=2 AND date_in=DATE_ADD( CONCAT(currentYear,'-08-31'), INTERVAL ( 2 - DAYOFWEEK(  CONCAT(currentYear,'-08-31')  ) ) DAY )
		THEN
			RETURN 1;
		END IF;
		
		IF DAYOFWEEK(CONCAT(currentYear,'-08-31'))=1 AND date_in=DATE_ADD(CONCAT(currentYear,'-08-24'), INTERVAL (2-DAYOFWEEK(CONCAT(currentYear,'-08-31'))) DAY)
		THEN
			RETURN 1;
		END IF;
		
		
	END IF;
	
	# christmas day in lieu of weekend
	IF EXTRACT(MONTH FROM date_in)=12
	THEN
	
		IF DAYOFWEEK(CONCAT(currentYear,'-12-25'))=1 AND date_in=CONCAT(currentYear,'-12-26')
		THEN
			RETURN 1;
		END IF;
		
		IF DAYOFWEEK(CONCAT(currentYear,'-12-25'))=7 AND date_in=CONCAT(currentYear,'-12-27')
		THEN
			RETURN 1;
		END IF;
		
		IF date_in=CONCAT(currentYear,'-12-25')
		THEN
			RETURN 1;
		END IF;
	END IF;
	
	# boxing day or monday or tuesday in lieu 
	IF EXTRACT(MONTH FROM date_in)=12
	THEN
	
		IF DAYOFWEEK(CONCAT(currentYear,'-12-25'))=1 AND date_in=CONCAT(currentYear,'-12-27')
		THEN
			RETURN 1;
		END IF;

		IF DAYOFWEEK(CONCAT(currentYear,'-12-25'))=7 AND date_in=CONCAT(currentYear,'-12-28')
		THEN
			RETURN 1;
		END IF;

		IF date_in=CONCAT(currentYear,'-12-27') AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))=1
		THEN
			RETURN 1;
		END IF;

		IF date_in=CONCAT(currentYear,'-12-28') AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))=7
		THEN
			RETURN 1;
		END IF;

		IF date_in=CONCAT(currentYear,'-12-26') AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))!=1
		THEN
			RETURN 1;
		END IF;
	END IF;
	
	# christmas closure
	
	IF EXTRACT(MONTH FROM date_in)=12 OR EXTRACT(MONTH FROM date_in)=1
	THEN
		SET yearEnd_par=CONCAT(currentYear+1,'-01-01');

		# When is new year day?
		IF DAYOFWEEK(yearEnd_par)=1
		THEN
			SET newYear_par=CONCAT(currentYear+1,'-01-02');
		END IF;

		IF DAYOFWEEK(yearEnd_par)=7
		THEN
			SET newYear_par=CONCAT(currentYear+1,'-01-03');

		END IF;

		IF DAYOFWEEK(yearEnd_par)!=7 AND DAYOFWEEK(yearEnd_par)!=1
		THEN
			SET newYear_par=yearEnd_par;
		END IF;

		# calc office closed for christmas
		SET christmasClose_par=DATE_SUB(newYear_par,INTERVAL 9 DAY);
		IF DAYOFWEEK(christmasClose_par)=1 OR DAYOFWEEK(christmasClose_par)=7
		THEN
			SET christmasClose_par=DATE_SUB(christmasClose_par,INTERVAL 2 DAY);
		END IF;
		
		RETURN (date_in>=christmasClose_par AND date_in<=newYear_par);
		
	END IF;
	
	RETURN 0;
END//

delimiter ;

DROP PROCEDURE IF EXISTS listHolidays;

delimiter //

# list the holidays as a table

create procedure listHolidays(
		IN currentYear int(5)
		)
main:BEGIN		
	declare date_in date;
	declare yearEnd_par date;
	declare newYear_par date;
	declare christmasClose_par date;
	
	SET date_in=CONCAT(currentYear,'-01-01');
	SET yearEnd_par=CONCAT(currentYear+1,'-01-01');
	
	# When is new year day?
	IF DAYOFWEEK(yearEnd_par)=1
	THEN
		SET newYear_par=CONCAT(currentYear+1,'-01-02');
	END IF;

	IF DAYOFWEEK(yearEnd_par)=7
	THEN
		SET newYear_par=CONCAT(currentYear+1,'-01-03');

	END IF;

	IF DAYOFWEEK(yearEnd_par)!=7 AND DAYOFWEEK(yearEnd_par)!=1
	THEN
		SET newYear_par=yearEnd_par;
	END IF;
	
	# extend year end
	IF yearEnd_par < newYear_par
	THEN
	
		SET yearEnd_par=newYear_par;
	
	END IF;
	
	# calc office closed for christmas
	SET christmasClose_par=DATE_SUB(newYear_par,INTERVAL 9 DAY);
	IF DAYOFWEEK(christmasClose_par)=1 OR DAYOFWEEK(christmasClose_par)=7
	THEN
		SET christmasClose_par=DATE_SUB(christmasClose_par,INTERVAL 2 DAY);
	END IF;
	
	create temporary table holidays (title varchar(255) not null, type varchar(255), date date not null);
	
	WHILE date_in <= yearEnd_par
	DO
	
		# new year
		IF EXTRACT(MONTH FROM date_in)=1
		THEN

			IF DAYOFWEEK(CONCAT(currentYear,'-01-01'))=1 AND date_in=CONCAT(currentYear,'-01-02')
			THEN
				INSERT INTO holidays values('New Year','bank',date_in);
				
			END IF;

			IF DAYOFWEEK(CONCAT(currentYear,'-01-01'))=7 AND date_in=CONCAT(currentYear,'-01-03')
			THEN
				INSERT INTO holidays values('New Year','bank',date_in);
				
			END IF;

			IF date_in=CONCAT(currentYear,'-01-01') AND DAYOFWEEK(CONCAT(currentYear,'-01-01'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-01-01'))!=1
			THEN
				INSERT INTO holidays values('New Year','bank',date_in);
				
			END IF;
		END IF;
		
		
		# Good friday, Easter monday
	
		IF EXTRACT(MONTH FROM date_in)=3 OR EXTRACT(MONTH FROM date_in)=4
		THEN
			IF date_in=DATE_SUB(easter(currentYear),INTERVAL 3 day)
			THEN
				INSERT INTO holidays values('Easter','office',date_in);
			END IF;
			
			IF date_in=DATE_SUB(easter(currentYear),INTERVAL 2 day)
			THEN
				INSERT INTO holidays values('Good Friday','bank',date_in);
			END IF;
			
			IF date_in=DATE_ADD(easter(currentYear),INTERVAL 1 day)
			THEN
				INSERT INTO holidays values('Easter Monday','bank',date_in);
			END IF;
		END IF;
		
		# may day, spring bank. 1st and last monday in may.
		IF EXTRACT(MONTH FROM date_in)=5
		THEN

			IF (2-DAYOFWEEK(CONCAT(currentYear,'-05-01')))>=0 AND date_in=DATE_ADD( CONCAT(currentYear,'-05-01'), INTERVAL ( 2- DAYOFWEEK(  CONCAT(currentYear,'-05-01') ) ) DAY )
			THEN
				INSERT INTO holidays values('May Day','bank',date_in);
			END IF;


			IF (2-DAYOFWEEK(CONCAT(currentYear,'-05-01')))<0 AND date_in=DATE_ADD(CONCAT(currentYear,'-05-01'), INTERVAL ( 9 - DAYOFWEEK(CONCAT(currentYear,'-05-01') ) ) DAY)
			THEN
				INSERT INTO holidays values('May Day','bank',date_in);
			END IF;

			IF DAYOFWEEK(CONCAT(currentYear,'-05-31'))>=2 AND date_in=DATE_ADD( CONCAT(currentYear,'-05-31'), INTERVAL ( 2 - DAYOFWEEK(  CONCAT(currentYear,'-05-31')  ) ) DAY )
			THEN
				INSERT INTO holidays values('Spring Bank','bank',date_in);
			END IF;

			IF DAYOFWEEK(CONCAT(currentYear,'-05-31'))=1 AND date_in=DATE_ADD(CONCAT(currentYear,'-05-24'), INTERVAL (2-DAYOFWEEK(CONCAT(currentYear,'-05-31'))) DAY)
			THEN
				INSERT INTO holidays values('Spring Bank','bank',date_in);
			END IF;

		END IF;
		
		IF EXTRACT(MONTH FROM date_in)=8
		THEN

			IF DAYOFWEEK(CONCAT(currentYear,'-08-31'))>=2 AND date_in=DATE_ADD( CONCAT(currentYear,'-08-31'), INTERVAL ( 2 - DAYOFWEEK(  CONCAT(currentYear,'-08-31')  ) ) DAY )
			THEN
				INSERT INTO holidays values('Summer Bank','bank',date_in);
			END IF;

			IF DAYOFWEEK(CONCAT(currentYear,'-08-31'))=1 AND date_in=DATE_ADD(CONCAT(currentYear,'-08-24'), INTERVAL (2-DAYOFWEEK(CONCAT(currentYear,'-08-31'))) DAY)
			THEN
				INSERT INTO holidays values('Summer Bank','bank',date_in);
			END IF;


		END IF;
		
		# christmas day in lieu of weekend
		IF EXTRACT(MONTH FROM date_in)=12
		THEN

			IF DAYOFWEEK(CONCAT(currentYear,'-12-25'))=1 AND date_in=CONCAT(currentYear,'-12-26')
			THEN
				INSERT INTO holidays values('Christmas','bank',date_in);
			END IF;

			IF DAYOFWEEK(CONCAT(currentYear,'-12-25'))=7 AND date_in=CONCAT(currentYear,'-12-27')
			THEN
				INSERT INTO holidays values('Christmas','bank',date_in);
			END IF;

			IF date_in=CONCAT(currentYear,'-12-25') AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1
			THEN
				INSERT INTO holidays values('Christmas','bank',date_in);
			END IF;
		END IF;
	
		# boxing day or monday or tuesday in lieu
		# university office closures
		IF EXTRACT(MONTH FROM date_in)=12 OR EXTRACT(MONTH FROM date_in)=1
		THEN
			
		
			IF (DAYOFWEEK(CONCAT(currentYear,'-12-25'))=1 OR (DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))=1) ) AND date_in=CONCAT(currentYear,'-12-27')
			THEN
				INSERT INTO holidays values('Boxing Day','bank',date_in);
			END IF;

			IF (DAYOFWEEK(CONCAT(currentYear,'-12-25'))=7 OR (DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))=7) ) AND date_in=CONCAT(currentYear,'-12-28')
			THEN
				INSERT INTO holidays values('Boxing Day','bank',date_in);
			END IF;
			
			IF date_in=CONCAT(currentYear,'-12-26') AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-25'))!=1 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))!=7 AND DAYOFWEEK(CONCAT(currentYear,'-12-26'))!=1
			THEN
				INSERT INTO holidays values('Boxing Day','bank',date_in);
			END IF;
			
			
			IF date_in>=christmasClose_par AND date_in <=newYear_par
			THEN
			
				INSERT INTO holidays values('Christmas','office',date_in);
			END IF;
			
			
		END IF;
	
		SET date_in=DATE_ADD(date_in, INTERVAL 1 DAY);
		
	END WHILE;
	
	
	
	SELECT * FROM holidays;
	
	drop temporary table holidays;
END//

delimiter ;

# term dates
# Statutory term: "Michaelmas, Term shall begin on and include 1 October and end on and include 17 December."
# Full term appears to be the first Sunday after the first Monday
# find the first Monday in October and add 6 days.


DROP FUNCTION IF EXISTS michaelmas;

delimiter //

create function michaelmas(Y int(5))
	RETURNS date
	
main:BEGIN


	IF (2-DAYOFWEEK(CONCAT(Y,'-10-01')))>=0
	THEN
		RETURN DATE_ADD(DATE_ADD( CONCAT(Y,'-10-01'), INTERVAL ( 2- DAYOFWEEK(  CONCAT(Y,'-10-01') ) ) DAY ), INTERVAL 6 DAY);
	ELSE
		RETURN DATE_ADD(DATE_ADD(CONCAT(Y,'-10-01'), INTERVAL ( 9 - DAYOFWEEK(CONCAT(Y,'-10-01') ) ) DAY), INTERVAL 6 DAY);
	END IF;
	
END//

delimiter ;

# Statutory term: "Hilary, Term shall begin on and include 7 January and end on and include 25 March or the Saturday before Palm Sunday, whichever is the earlier."
# Full term appears to be the first Sunday after the first Monday after 7th January

DROP FUNCTION IF EXISTS hilary;

delimiter //

create function hilary(Y int(5))
	RETURNS date
	
main:BEGIN


	IF (2-DAYOFWEEK(CONCAT(Y,'-01-07')))>=0
	THEN
		RETURN DATE_ADD(DATE_ADD( CONCAT(Y,'-01-07'), INTERVAL ( 2- DAYOFWEEK(  CONCAT(Y,'-01-07') ) ) DAY ), INTERVAL 6 DAY);
	ELSE
		RETURN DATE_ADD(DATE_ADD(CONCAT(Y,'-01-07'), INTERVAL ( 9 - DAYOFWEEK(CONCAT(Y,'-01-07') ) ) DAY), INTERVAL 6 DAY);
	END IF;
	
END//

delimiter ;

# Statutory term: "Trinity, Term shall begin on and include 20 April or the Wednesday after Easter, whichever is the later, and end on and include 6 July."
# Full term appears to be the first Sunday after the latest of (20th April or Wednesday after Easter)

DROP FUNCTION IF EXISTS trinity;

delimiter //

create function trinity(Y int(5))
	RETURNS date
	
main:BEGIN
	DECLARE latest date;
	DECLARE twentyTh date;
	
	SET twentyTh=CONCAT(Y,'-04-20');
	
	# Wednesday after Easter
	SET latest=DATE_ADD(easter(Y), INTERVAL 3 DAY);
	
	IF latest < twentyTh
	THEN
	
		SET latest=twentyTh;
	
	END IF;

	IF (1-DAYOFWEEK(latest))>=0
	THEN
		RETURN DATE_ADD( latest, INTERVAL ( 1- DAYOFWEEK(  latest ) ) DAY );
	ELSE
		RETURN DATE_ADD(latest, INTERVAL ( 8 - DAYOFWEEK(latest ) ) DAY);
	END IF;
	
END//

delimiter ;


# returns where easter is according to the Carter algorithm
DROP FUNCTION IF EXISTS easter;

delimiter //

create function easter(Y int(5))
	RETURNS date
	
main:BEGIN

	DECLARE D int(4);
	DECLARE E int(4);
	DECLARE Q int(4);
	
	SET D=225-(11 * (Y MOD 19));
	
	WHILE D > 50 DO
	
		SET D=D-30;
	
	END WHILE;

	IF D > 48
	THEN
		SET D=D-1;
	END IF;
	
	
	SET E = (Y + FLOOR(Y/4) + D + 1) MOD 7;
	
	SET Q=D + 7 - E;
	
	IF Q<32
	THEN
	
		return CONCAT(Y,'-','03','-',Q);
	
	ELSE
	
		return CONCAT(Y,'-','04','-',(Q-31));
	
	END IF;

END//

delimiter ;
