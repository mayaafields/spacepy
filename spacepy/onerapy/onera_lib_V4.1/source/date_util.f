! 
!----------------------------------------------------------------------      
! NAME:
!	JULDAY
!
! PURPOSE:
!	Calculate the Julian Day Number for a given month, day, and year.
!
!
! CALLING SEQUENCE:
!	Result = JULDAY(Year,Month, Day)
!
! INPUTS:
!	MONTH:	Number of the desired month (1 = January, ..., 12 = December).
!
!	DAY:	Number of day of the month.
!
!	YEAR:	Number of the desired year.Year parameters must be valid
!               values from the civil calendar.  Years B.C.E. are represented
!               as negative integers.  Years in the common era are represented
!               as positive integers.  In particular, note that there is no
!               year 0 in the civil calendar.  1 B.C.E. (-1) is followed by
!               1 C.E. (1).
!
! OUTPUTS:
!	JULDAY returns the Julian Day Number (which begins at noon) of the
!	specified calendar date.
!-----------------------------------------------------------------------
       FUNCTION JULDAY (iyear,month,day)
!
       IMPLICIT NONE
!
       INTEGER*4 JULDAY,year,month,day,iyear
       INTEGER*4 min_calendar,max_calendar,bc,inJanFeb
       INTEGER*4 JY,JM,GREG,JA
!
!
! Gregorian Calander was adopted on Oct. 15, 1582
! skipping from Oct. 4, 1582 to Oct. 15, 1582
       GREG = 2299171  ! incorrect Julian day for Oct. 25, 1582
!
       year=iyear
       min_calendar = -4716
       max_calendar = 5000000
       IF ((year .LT. min_calendar) .OR. (year .GT. max_calendar)) THEN
	   write(6,*)'Value of Julian date is out of allowed range.'
	   stop
       ENDIF
       IF (year .eq. 0)  then
	   write(6,*)'There is no year zero in the civil calendar.'
	   write(6,*)'Value of Julian date is out of allowed range.'
	   stop
       ENDIF
!
       bc=0
       IF (year.lt.0) bc=1
       year=year+bc
!
       inJanFeb=0
       IF (month .le.2) inJanFeb=1

       JY = YEAR - inJanFeb
       JM = MONTH + (1 + 12*inJanFeb)


       JULDAY = INT(365.25d0 * JY) + INT(30.6001d0*JM) + DAY + 1720995


! Test whether to change to Gregorian Calandar.
       IF (JULDAY .GE. GREG) THEN   ! change all dates
          JA = INT(0.01d0 * JY)
	  JULDAY = JULDAY + 2 - JA +INT(0.25d0 * JA)
       ENDIF
       END 
!
!-------------------------------------------------------------------------
! NAME:
!	CALDAT
!
! PURPOSE:
!	Return the calendar date given julian day.
!	This is the inverse of the function JULDAY.
! CALLING SEQUENCE:
!	CALDAT, Julian,  Year, Month, Day
!	See also: julday, the inverse of this function.
!
! INPUTS:
!	JULIAN contains the Julian Day Number (which begins at noon) of the
!	specified calendar date.  It should be a long integer.
! OUTPUTS:
!	(Trailing parameters may be omitted if not required.)
!	MONTH:	Number of the desired month (1 = January, ..., 12 = December).
!
!	DAY:	Number of day of the month.
!
!	YEAR:	Number of the desired year.
!-------------------------------------------------------------------------
!
       SUBROUTINE CALDAT(julian, year,month, day)
!
       IMPLICIT NONE
!
       INTEGER*4  julian
       INTEGER*4  year,month, day
       INTEGER*4  min_julian,max_julian,igreg,jalpha,ja,jb,jc,jd,je
!
       min_julian = -1095
       max_julian = 1827933925
!
       IF ((julian .LT. min_julian) .OR. (julian .GT. max_julian)) THEN
          write(6,*)'Value of Julian date is out of allowed range.'
          stop
       ENDIF

       igreg = 2299161    !Beginning of Gregorian calendar

       ja=0
       IF (julian .GE. igreg) THEN    ! all are Gregorian
          jalpha = INT(((julian - 1867216) - 0.25d0) / 36524.25d0)
          ja = julian + 1 + jalpha - INT(0.25d0 * jalpha)
       ENDIF

       jb = ja + 1524
       jc = INT(6680d0 + ((jb-2439870)-122.1d0)/365.25d0)
       jd = INT(365d0 * jc + (0.25d0 * jc))
       je = INT((jb - jd) / 30.6001d0)

       day = jb - jd - INT(30.6001d0 * je)
       month = je - 1
       month = MOD((month - 1),12) + 1
       year = jc - 4715
       if (month .gt. 2) year = year - 1
       if (year .le. 0) year = year - 1

       END
! 
!----------------------------------------------------------------------      
! NAME:
!	GET_DOY
!
! PURPOSE:
!	Calculate the day of year for a given month, day, and year.
!
!
! CALLING SEQUENCE:
!	Result = GET_DOY(Year,Month, Day)
!
! INPUTS:
!	MONTH:	Number of the desired month (1 = January, ..., 12 = December).
!
!	DAY:	Number of day of the month.
!
!	YEAR:	Number of the desired year.Year parameters must be valid
!               values from the civil calendar.  Years B.C.E. are represented
!               as negative integers.  Years in the common era are represented
!               as positive integers.  In particular, note that there is no
!               year 0 in the civil calendar.  1 B.C.E. (-1) is followed by
!               1 C.E. (1).
!
! OUTPUTS:
!	GET_DOY returns the day of year of the specified calendar date.
!-----------------------------------------------------------------------
       FUNCTION GET_DOY (year,month,day)
!
       IMPLICIT NONE
!
       INTEGER*4 GET_DOY,JULDAY,year,month,day
       INTEGER*4 firstJanuary
!
       firstJanuary=JULDAY(year,01,01)
       GET_DOY=JULDAY(year,month,day)-firstJanuary+1
       END 
       
!----------------------------------------------------------------------      
! NAME:
!	DECY2DATE_AND_TIME
!
! PURPOSE:
!	Calculate the date and time (yeay,month,day of month, day of year, hour, minute and second and
!         Universal Time).
!
!
! CALLING SEQUENCE:
!	CALL DECY2DATE_AND_TIME(Dec_y,Year,Month, Day, doy, hour,minute,second)
!
! INPUTS:
!       DEC_Y : Decimal year where yyyy.0d0 is January 1st at 00:00:00
!
! OUTPUTS:
!	YEAR:	Number year.Year parameters must be valid
!               values from the civil calendar.  Years B.C.E. are represented
!               as negative integers.  Years in the common era are represented
!               as positive integers.  In particular, note that there is no
!               year 0 in the civil calendar.  1 B.C.E. (-1) is followed by
!               1 C.E. (1).
!
!	MONTH:	Number  month (1 = January, ..., 12 = December).
!
!	DAY:	Number of day of the month.
!
!	DOY: Number of day of year (DOY=1 is for January 1st)
!
!       HOUR, MINUTE and SECOND: Universal time in the day
!
!      UT: Univeral time in seconds
!
!-----------------------------------------------------------------------
       SUBROUTINE DECY2DATE_AND_TIME (dec_y,year,month, day, doy, 
     &           hour,minute,second,UT)
!
       IMPLICIT NONE
!
       INTEGER*4 I
       INTEGER*4 JULDAY,year,month,day,doy,hour,minute,second
       INTEGER*4 firstJanuary,lastDecember,Ndays
       INTEGER*4 dom_n(12),dom_b(12),dom(12),tmp
!
       REAL*8  dec_y,aux,UT
!
       DATA  dom_n /31,28,31,30,31,30,31,31,30,31,30,31/
       DATA  dom_b /31,29,31,30,31,30,31,31,30,31,30,31/
!       
       year=INT(dec_y)
       firstJanuary=JULDAY(year,01,01)
       lastDecember=JULDAY(year,12,31)
       Ndays=lastDecember-firstJanuary+1
       IF (Ndays.EQ.365) THEN
          DO I=1,12
	     dom(I)=dom_n(I)
	  ENDDO
       ELSE
          DO I=1,12
	     dom(I)=dom_b(I)
	  ENDDO
       ENDIF
       aux=(dec_y-year*1.d0)*Ndays
       doy=INT(aux)+1
!
       tmp=0       
       DO I=1,12
          tmp=tmp+dom(I)
	  IF (tmp .GE. doy) GOTO 10
       ENDDO
10     CONTINUE
       month = I
       tmp=tmp-dom(I)
       day = doy-tmp
!
       aux=(aux-(doy-1)*1.d0)*24.d0
       hour=INT(aux)
       aux=(aux-hour*1.d0)*60.d0
       minute=INT(aux)
       aux=(aux-minute*1.d0)*60.d0
       second=INT(aux)
!
       UT=hour*3600.0d0+minute*60.0d0+second*1.0d0
       END 
       
!-------------------------------------------------------------------------
! NAME:
!	DATE_AND_TIME2DECY
!
! PURPOSE:
!	Return the decimal year for a given date and time.
! CALLING SEQUENCE:
!	CALL DATE_2_DECY(Year, Month, Day, hour,minute,second,decy)
!
! INPUTS:
!	MONTH:	Number of the desired month (1 = January, ..., 12 = December).
!
!	DAY:	Number of day of the month.
!
!	YEAR,HOUR,MINUTE,SECOND.
!
! OUTPUTS:
!       decy : decimal year for a given date and time
!-------------------------------------------------------------------------
!
       SUBROUTINE DATE_AND_TIME2DECY(Year,Month,Day,hour,minute
     &,second,decy)
!
       IMPLICIT NONE
!
       INTEGER*4 Year, Month, Day, hour,minute,second
       INTEGER*4 firstJanuary,lastDecember,xut1
       INTEGER*4 julday
!
       REAL*8 decy
!
       firstJanuary=julday(Year,01,01)
       lastDecember=julday(Year,12,31)
       xut1=julday(Year,month,day)
      
       decy=Year*1.d0+(xut1-firstJanuary
     &      +(hour*3600.d0+minute*60.d0+second*1.d0)
     &       /86400.d0)/(lastDecember-firstJanuary+1.d0)

       end