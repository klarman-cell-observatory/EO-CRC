/*note: When we created data file for the HPFS, we changed the ids by multiplying 100. 
If you want to combined this data file with other files you creat by yourself, please make the same change to the HPFS's ids*/
/*Seven markers including CD274, PDCD1LG2, PDCD1, NFKB1, RELA, CASR amd tumor neoantigen load have been read in the datastep.*/
/*Two exposure variables, pack-years of smoking and history of endoscopy, were added to the datastep*/ 
/*Most variables from questionnaires have been updated till 2010*/ 
/*Case files of NHS and HPFS have been updated*/
/*The cutoff points of follow-up are set as June 2012 for NHS, and January 2012 for HPFS*/
/*We redefined the time pertiod window of post-diagnosis varaibles to 'at least 6 m and no more than 48m(4 years) after dx'.*/
/*There are two varaibels of tumor stage, stageall and finalstage. stageall is the orignial stage varaible. finalstage is a variable with imputated stages for stage I and II in the HPFS. finalstage is recommeded.*/
/*Most variables from questionnaires have been updated till 2014 (20191107)*/ 
/*Case files of NHS and HPFS have been updated (20191107)*/
/*The cutoff points of follow-up are set as June 2016 for NHS, and January 2016 for HPFS*/
/*Replaced meddata and fileb to meds8016*/
/*HPFS PA up to 2014*/
/*added /proj/nhdats/nh_dat_cdx/endpoints/colon/colc.current.nhs1.dat to import data of id=250502 and 328991*/
/*added to create crcsurvpost in HPFS as in NHS*/
/*HS_LIBRARY_SIZE, Bifidobacterium genus, LC3AB, beclin, and p62, tcellnew, fusonuc2, macrophage if (30% cutoff), HE, budding were added to the datastep*/
/*Myeloid by Koichiro (20200106)*/
/*PTGS2_HPGD_CD68_tryptase by Koichiro (20200522)*/
/*NK by Koichiro (20200707)*/
/*The cutoff points of follow-up are set as Dec 2019 for NHS, and Dec 2019 for HPFS*/
/*BFT by Hide (20230222)*/
/*Cases of NHS and HPFS updated until 2020 and 2018, respectively, by Hide (20230420)*/

options linesize=128 pagesize=78 pageno=1;

/** CREATING FORMATS    **/
proc format;
value cohortf 1 = "NHS"
              2 = "HPFS"
              3 = "NHS-2"
              4 = "PHS";

value dxfmt 1 = "Colorectal CA"
            2 = "Colon Polyp"
            3 = "Pancreatic CA";

value sexfmt 1 = "Female"
             2 = "Male";
              
value CIfmt 1 = "CIMP-n"
            2 = "CIMP-l"
            3 = "CIMP-p";
 
value CI2fmt 1 = "CIMP-H"
             2 = "non-CIMP-H";

value CI2dfmt 1 = "non-CIMP-H"
              2 = "CIMP-H";

value msifmt 1 = "MSI high"
             2 = "MSI low/s";

value msidfmt 1 = "MSI low/s"
              2 = "MSI high";

value ci_msif 1 = "non-CIMP-H/MSI low/s"
              2 = "non-CIMP-H/MSI high"
              3 = "CIMP-H/MSI low/s"
              4 = "CIMP-H/MSI high";

value br_msif 1 = "BRAF-/MSI low/s"
              2 = "BRAF-/MSI high"
              3 = "BRAF+/MSI low/s"
              4 = "BRAF+/MSI high";

value ci_brf 1 = "non-CIMP-H/BRAF-"
             2 = "non-CIMP-H/BRAF-"
             3 = "CIMP-H/BRAF+"
             4 = "CIMP-H/BRAF+";

value tumlocf 1 = "Distal"
              2 = "Proximal";

value tstagef 1 = "T1-invades submucosa"
              2 = "T2-invades muscularis"
              3 = "T3-invades through muscularis into subserosa"
              4 = "T4-invades other organs/structures; perforation"
              5 = "Tis-carcinoma in situ - invasion of lamina propria"
              6 = "Tx-unknown";

value nstagef 1 = "N0-no regional lymph nodes metastases"
              2 = "N1-metastases in 1-3 regional lymph nodes"
              3 = "N2-metastases in 4 or more regional lymph nodes"
              4 = "Positive lymph nodes-number unknown"
              5 = "Nx-unknown status";

value mstagef 1 = "M0-no distant metastases known"
              2 = "M1-distant metastases";

value mworkf 1 = "Distant metastases present"
             2 = "Complete negative workup"
             3 = "Incomplete workup/chest unknown"
             4 = "Incomplete workup/abdomen unknown"
             5 = "No metastatic work-up reported";

/****************************************************************/
/** Accessing NHS READ macros and data formats.                **/
/****************************************************************/

libname nhsfmt '/proj/nhsass/nhsas00/formats';
filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos';
filename channing '/usr/local/channing/sasautos';

/****************************************************************/
/** Accessing HPFS READ macros and data formats.               **/
/****************************************************************/

libname hpfsfmt "/proj/hpsass/hpsas00/formats";
filename hpstools "/proj/hpsass/hpsas00/hpstools/sasautos";

options mautosource sasautos=(channing nhstools hpstools);

/****************************************************************/
/** List location(s) of format libraries.  If you have         **/
/** your own library with data formats, list it here with      **/
/** READFMT.                                                   **/
/****************************************************************/
options fmtsearch=(nhsfmt hpfsfmt);

/****************************************************************/
/**  Assigning filename references to the original disease     **/
/**  files.  This is done because many variables of interest   **/
/**  are not loaded into tissue tracking programs.             **/
/****************************************************************/

filename nh_colc1 '/proj/nhdats/nh_dat_cdx/endpoints/colon/colc7620.021422.cases';
filename hp_colc1 '/proj/hppols/hppol0c/hpfs/CRC/2018/active/CRC_8618_TNM.dat';    
filename derived '/proj/hpdats/hpdat01/comp/derived';

/****************************************************************/
/**           Read physical activity related files             **/
/**                                                            **/
/****************************************************************/

filename hp_mets '/proj/hpdats/hp_dat_der/mets/mets8614/mets8614';     
filename act8614 '/proj/nhdats/nh_dat_der/act8614';
filename hp02 '/proj/hpdats/hp_dat_qqf/hp02';
filename hp04 '/proj/hpdats/hp_dat_qqf/hp04';
filename hp06 '/proj/hpdats/hp_dat_qqf/hp06';
filename aweh '/udd/nhgna/charlie';


/****************************************************************/
/**                  Read all lab files                        **/
/**                                                            **/
/****************************************************************/
/******************creating tumor info files**********************************/
/*****These files included in the Pathoinfo.dat(path2)*****/
/*
data tumor_info; 
infile '/udd/nhogi/colc1pt1tumornew.dat' lrecl=13 recfm=d;
input
@1		TumorID	    4.
@5		id	    6.
@11		Cohort	$   1.
@12		Exclude1case1T     1.;
proc sort data=tumor_info; by TumorID; run;

data Differentiation; 
infile '/udd/nhogi/Survival/DATA/Differentiation.dat' lrecl=7 recfm=d;
input
@1		TumorID	    4.
@5		intPatholDiff	    2.;
proc sort data=Differentiation; by TumorID; run;
*/
/***************creating molecular marker files*****************************/
data cimp_high; infile '/udd/nhogi/Survival/DATA/CIMPnew2014.dat' lrecl=342 recfm=d;
input
@1		TumorID	    4.
@5		BisulfiteID	    4.
@9		TValueCIMP		$   1.
@10		blockNo	$   12.
@22		P16cc		    20.
@42		MLH1cc		    20.
@62		Expr1006	    7.
@69		CACNA1Gcc	    20.
@89		CRABP1cc	    20.
@109		NEUROG1cc	    20.
@129		IGF2cc		    20.
@149		RUNX3cc	    19.
@168		SOCS1cc	    20.
@188		PTGS2cc	    6.
@194		Expr1014	    7.
@201		MINT31cc	    20.
@221		IGFBP3cc	    20.
@241		WRNcc    	    20.
@261		P14cc		    20.
@281		CHFRcc		    6.
@287		HIC1cc		    20.
@307		ExcludeDupulicateCIMP    1.
@308		MGMTcc		    7.
@315		MINT1cc	    20.
@335		MINT2cc	    7.
;

if TValueCIMP ne 'T' then delete; /*tumor only*/

/*8 marker*/
if 0=< P16cc <=4 then p16 =0;
else if P16cc >4 then p16=1; if 0<=p16<=1 then p16r=1; else p16r=0; 
if 0=< CACNA1Gcc <=4 then cacn = 0;
else if CACNA1Gcc >4 then cacn =1; if 0<=cacn<=1 then cacnr=1; else cacnr=0; 
if 0=< CRABP1cc <=6 then crab = 0;
else if CRABP1cc >6 then crab =1; if 0<=crab<=1 then crabr=1; else crabr=0; 
if 0=< IGF2cc <=6 then igf2 = 0;
else if IGF2cc >6 then igf2 =1; if 0<=igf2<=1 then igf2r=1; else igf2r=0; 
if 0=< MLH1cc <=4 then mlh1 = 0;
else if MLH1cc >4 then mlh1 =1; if 0<=mlh1<=1 then mlh1r=1; else mlh1r=0; 
if 0=< NEUROG1cc <=4 then neur = 0;
else if NEUROG1cc >4 then neur =1; if 0<=neur<=1 then neurr=1; else neurr=0; 
if 0=< RUNX3cc <=4 then runx = 0;
else if RUNX3cc >4 then runx =1; if 0<=runx<=1 then runxr=1; else runxr=0; 
if 0=< SOCS1cc <=4 then socs = 0;
else if SOCS1cc >4 then socs =1; if 0<=socs<=1 then socsr=1; else socsr=0; 

/*cimp8score definition*/
cimp8scorea = Sum(p16, cacn, crab, igf2, mlh1, neur, runx, socs); 
cimp8sum = Sum(p16r, cacnr, crabr, igf2r, mlh1r, neurr, runxr, socsr) ;
cimp8score = cimp8scorea / cimp8sum; 
/*cimppeter5 definition (Peter Laird's 5 Marker panel)*/
cimppeter5a= Sum (cacn,neur,igf2,runx,socs);
cimppeter5sum= Sum (cacnr,neurr,igf2r,runxr,socsr);
cimppeter5= cimppeter5a/cimppeter5sum;

if 0=< MGMTcc <=4 then mgmt = 0;
else if MGMTcc >4 then mgmt =1; if 0<=mgmt<=1 then mgmtr=1;else mgmtr=0;
if 0=< CHFRcc <=4 then chfr = 0;
else if CHFRcc >4 then chfr =1;if 0<=chfr<=1 then chfrr=1;else chfrr=0;
if 0=< HIC1cc <=6 then hic1 = 0;
else if HIC1cc >6 then hic1 =1;if 0<=hic1<=1 then hic1r=1;else hic1r=0;
if 0=< IGFBP3cc <=6 then igfb = 0;
else if IGFBP3cc >6 then igfb =1;if 0<=igfb<=1 then igfbr=1;else igfbr=0;
if 0=< P14cc <=4 then p14 = 0;
else if P14cc >4 then p14 =1;if 0<=p14<=1 then p14r=1;else p14r=0;
if 0=< MINT1cc <=4 then mint1 = 0;
else if MINT1cc >4 then mint1 =1;if 0<=mint1<=1 then mint1r=1;else mint1r=0;
if 0=< MINT31cc <=6 then mint31 = 0;
else if MINT31cc >6 then mint31 =1;if 0<=mint31<=1 then mint31r=1;else mint31r=0;
if 0=< WRNcc <=6 then wrn = 0;
else if WRNcc >6 then wrn =1;if 0<=wrn<=1 then wrnr=1;else wrnr=0;

/*cimp16score fefinition*/
cimp16scorea = Sum(p16, cacn, crab, igf2, mlh1, neur, runx, socs, 
mgmt, p14, chfr, hic1, igfb,mint1, wrn); 
cimp16scoresum = Sum(p16r, cacnr, crabr, igf2r, mlh1r, neurr, runxr, socsr, 
mgmtr, p14r, chfrr, hic1r, igfbr,mint1r, wrnr); 
cimp16score= cimp16scorea/cimp16scoresum;

     if cimp8score gt 0.70                     then cimphigh=1; /*cimp-high */
else if cimp8score ge 0 and cimp8score le 0.70 then cimphigh=0; /*non-cimp-h*/

/** criteria for CIMP-h, cimp-low, cimp-0 **/
     if cimp8score gt 0.70                     then cimphigh3=2; /*cimp-high*/
else if cimp8score gt 0 and cimp8score le 0.70 then cimphigh3=1; /*cimp-low */
else if cimp8score eq 0                        then cimphigh3=0; /*cimp-0   */

/** Creating variables to represent CIMP status using 16 markers (11 of 16).  **/
     if CIMP16score gt 0.625                      then cimphigh16=2; /** Cimp-High     **/
else if 0.18 < CIMP16score le 0.625 then cimphigh16=1;              /** non Cimp-High **/
else if CIMP16score ge 0 and CIMP16score le 0.18 then cimphigh16=0; /** CIMP-0**/

/* Peter Laird's 5 Marker panel*/
if 0=< cimppeter5 <0.5  then cip=0; /*cimp-low0*/
else if 0.5 =< cimppeter5 =<1  then cip=1; /*cimp-h*/

/* Peter Laird's 5 Marker panel - 3 categories*/
if  cimppeter5 =0  then cip1=0; /*cimp-0*/
else if 0< cimppeter5 <0.5  then cip1=1; /*cimp-low*/
else if 0.5 =< cimppeter5 =<1  then cip1=2; /*cimp-h*/

/*JP Issa's CIMP panel*/
cimissa= p16+mlh1+p14+mint1+mint31;
if 0=<cimissa<=1 then cjp1=0; 
else if cimissa>1 then cjp1=1;
if 0=<cimissa<=2 then cjp2=0;
else if cimissa>2 then cjp2=1; 
if 0<=cimissa<=3 then cjp3=0;
else if cimissa>3 then cjp3=1;
if 0<=cimissa<=1 then cjp4=0;
else if cimissa>2 then cjp4=1;

proc sort data=cimp_high; by TumorID; run;


data braf; 
infile '/udd/nhogi/Survival/DATA/braf20140903.dat' lrecl=35 recfm=d;
input
@1		TumorID	    4.
@5		BrafID	    4.
@9		BrafScrapeID	    4.
@13		Braf600nuc	$   3.
@16		Braf600	    1.
@17		BrafcodonWT	$   3.
@20		BrafcodonMut	$   3.
@23		BrafotherMutAminoAcid $   10.
@33		BrafotherMut	    1.
@34		BrafExcludeDup	    1.;
if Braf600=1  then mutatebraf600=1;
else if Braf600=0 and Braf600nuc = 'gtg' then mutatebraf600=2;
if mutatebraf600=1 then brafmt=1; /*BRAF mut*/
else if mutatebraf600=2 then brafmt=0; /*BRAF wt*/
proc sort data=braf nodupkey; by TumorID; run;


data msi; infile '/udd/nhogi/Survival/DATA/msi20140617.dat' lrecl=465 recfm=d;
input
@1		intMSIID	    4.
@5		TumorID	    4.
@9		intMSI		    1.
@10		intShift	    2.
@12		intMarker	    2.
@14		ysnOnlyTDNA	    1.
@15		ysnDone		    1.
@16		dtmD2Sdate	$   18.
@34		ysnD2sduplicate	    1.
@35		ysnD2STailedPrimer     1.
@36		dblTD2S_1	    3.
@39		dblTD2S_2	    3.
@42		dblND2S_1	    3.
@45		dblND2S_2	    3.
@48		dblD2SLgshift	    3.
@51		dblD2SSmshift	    3.
@54		dblD2Sshift	    2.
@56		D2S		    1.
@57		ysnD2sLOH	    1.
@58		dtmD5Sdate	$   18.
@76		ysnD5StailedPrimer     1.
@77		dblTD5S_1	    3.
@80		dblTD5S_2	    3.
@83		dblND5S_1	    3.
@86		dblND5S_2	    3.
@89		dblD5SLgshift	    3.
@92		dblD5SSmshift	    3.
@95		dblD5Sshift	    2.
@97		D5S		    1.
@98		ysnD5sLOH	    1.
@99		dtmD17Sdate	$   18.
@117		ysnD17Stailedprimer     1.
@118		dblTD17S_1	    3.
@121		dblTD17S_2	    3.
@124		dblND17S_1	    3.
@127		dblND17S_2	    3.
@130		dblD17SLgshift	    3.
@133		dblD17SSmshift	    2.
@135		dblD17Sshift	    2.
@137		D17S		    1.
@138		ysnD17sLOH	    1.
@139		dtmBAT25date	$   18.
@157		ysnB25duplicated     1.
@158		dblTBAT25_1	    3.
@161		dblTBAT25_2	    3.
@164		dblNBAT25_1	    3.
@167		dblNBAT25_2	    2.
@169		dblBAT25Lgshift	    2.
@171		dblBAT25Smshift	    2.
@173		dblBAT25shift	    2.
@175		BAT25	    1.
@176		ysnBAT25polymorphism     1.
@177		dtmBAT26date	$   18.
@195		ysnB26dupliacte	    1.
@196		dblTBAT26_1	    3.
@199		dblTBAT26_2	    2.
@201		dblNBAT26_1	    3.
@204		dblNBAT26_2	    2.
@206		dblBAT26Lgshift	    2.
@208		dblBAT26Smshift	    2.
@210		dblBAT26shift	    2.
@212		BAT26	    1.
@213		ysnBAT26polymorphism     1.
@214		dtmD18s55Sdate	$   18.
@232		ysnD18s55duplicate     1.
@233		ysnD18S55tailprimer     1.
@234		dblTD18S551t	    3.
@237		dblTD18S552t	    3.
@240		dblND18S551normal     3.
@243		dblND18S552normal     3.
@246		dblD18S55Lgshift     3.
@249		dblD18S5Smshift	    3.
@252		dblD18S55shift	    2.
@254		D18S55MSI	    1.
@255		ysnD18s55Info	    1.
@256		intD18s55LOH	    1.
@257		dtmD18s56Sdate	$   18.
@275		ysnD18s56duplicate     1.
@276		ysnD18s56Tailprimer     1.
@277		dblTD18S561T	    3.
@280		dblTD18S562T	    3.
@283		dblND18S561N	    3.
@286		dblND18S562N	    3.
@289		dblD18S56Lgshift     2.
@291		dblD18S56mshift	    2.
@293		dblD18S56shift	    2.
@295		D18S56MSI	    1.
@296		ysnD18s56Info	    1.
@297		intD18s56LOH	    1.
@298		dtmD18s67Sdate	$   18.
@316		ysnD18s67duplicate     1.
@317		ysnD18s67tailprimer     1.
@318		dblTD18S671T	    3.
@321		dblTD18S672T	    3.
@324		dblND18S671N	    3.
@327		dblND18S672N	    3.
@330		dblD18S67Lgshift     3.
@333		dblD18S67mshift	    3.
@336		dblD18S67shift	    2.
@338		D18S67MSI	    1.
@339		ysnD18s67Info	    1.
@340		intD18s67LOH	    1.
@341		dtmD18s487Sdate	$   18.
@359		ysnD18s487duplicate     1.
@360		ysnD18s487tailprimer     1.
@361		dblTD18S4871T	    3.
@364		dblTD18S4872N	    3.
@367		dblND18S4871	    3.
@370		dblND18S4872	    3.
@373		dblD18S487Lgshift     2.
@375		dblD18S487mshift     2.
@377		dblD18S487shift	    2.
@379		D18S487MSI	    1.
@380		ysnD18s487Info	    1.
@381		intD18s487LOH	    1.
@382		dtmBAT40date	$   18.
@400		dblTBAT401	    3.
@403		dblTBAT402	    3.
@406		dblNBAT401	    3.
@409		dblNBAT402	    3.
@412		dblBAT40Lgshift	    1.
@413		dblBAT40Smshift	    1.
@414		dblBAT40shift	    1.
@415		BAT40	    1.
@416		ysnBAT40polymorphism     1.
@417		dtmTGFBR2date	$   17.
@434		dblTTGFBR2	    2.
@436		dblNTGFBR2	    2.
@438		dblTGFBR2shift	    1.
@439		TGFBR2	    1.
@440		dtmBAXdate	$   18.
@458		dblTBAX		    2.
@460		dblNBAX		    2.
@462		dblBAXshift	    1.
@463		BAX		    1.
@464		ysnBAXTshiftedpeaklow     1.;

/*0=no result, 1=no shift, 2=shift, 3=indeterminate*/
if 1<=D2S<=2 then D2Sm=1; else D2Sm=0;
if 1<=D5S<=2 then D5Sm=1; else D5Sm=0;
if 1<=D17S<=2 then D17Sm=1; else D17Sm=0;
if 1<=BAT25<=2 then BAT25m=1; else BAT25m=0;
if 1<=BAT26<=2 then BAT26m=1; else BAT26m=0;
if 1<=BAT40<=2 then BAT40m=1; else BAT40m=0;
if 1<=D18S55MSI<=2 then D18S55MSIm=1; else D18S55MSIm=0;
if 1<=D18S56MSI<=2 then D18S56MSIm=1; else D18S56MSIm=0;
if 1<=D18S67MSI<=2 then D18S67MSIm=1; else D18S67MSIm=0;
if 1<=D18S487MSI<=2 then D18S487MSIm=1; else D18S487MSIm=0;

CountMarker=D2Sm+D5Sm+D17Sm+BAT25m+BAT26m+BAT40m+D18S55MSIm+D18S56MSIm+D18S67MSIm+D18S487MSIm;

if D2S=2 then D2Sshitc=1; else  D2Sshitc=0;
if D5S=2 then D5Sshitc=1; else  D5Sshitc=0;
if D17S=2 then D17Sshitc=1; else  D17Sshitc=0;
if BAT25=2 then BAT25shitc=1; else  BAT25shitc=0;
if BAT26=2 then BAT26shitc=1; else  BAT26shitc=0;
if BAT40=2 then BAT40shitc=1; else  BAT40shitc=0;
if D18S55MSI=2 then D18S55MSIshitc=1; else  D18S55MSIshitc=0;
if D18S56MSI=2 then D18S56MSIshitc=1; else  D18S56MSIshitc=0;
if D18S67MSI=2 then D18S67MSIshitc=1; else  D18S67MSIshitc=0;
if D18S487MSI=2 then D18S487MSIshitc=1; else  D18S487MSIshitc=0;

shiftmarker=D2Sshitc+D5Sshitc+D17Sshitc+BAT25shitc+BAT26shitc+
BAT40shitc+D18S55MSIshitc+D18S56MSIshitc+D18S67MSIshitc+D18S487MSIshitc;

if CountMarker <5 and BAT25m =0 and BAT26m = 0 then delete; 

ShiftMarkerRatio=shiftmarker/CountMarker;

/* Creating MSI status variables */
msin2=.; 
     if    ShiftMarkerRatio ge 0.3 then msin2=2; /* MSI-H */
else if 0< ShiftMarkerRatio <0.3   then msin2=1; /* MSI-L */
else if ShiftMarkerRatio =0        then msin2=0; /* MSS   */

/*Shuji Ogino checked these cases*/
if tumorID = 40  then msin2 = 2; 
if tumorID = 51  then msin2 = 1;
if tumorID = 119 then msin2 = 2;
if tumorID = 122 then msin2 = 1; 
if tumorID = 175 then msin2 = 1;
if tumorID = 281 then msin2 = 1; 
if tumorID = 350 then msin2 = 1;
if tumorID = 492 then msin2 = 2; 
if tumorID = 620  then msin2 = 1;
if tumorID = 1173 then msin2 = 1; 
if tumorID = 1873 then msin2 = 2;

/* Creating MSI status variables */
msin=.; if    msin2 =2  then msin = 1; /* MSI-H     */
   else if 0<=msin2 <=1 then msin = 0; /* non-MSI-H */

/*for 2 marker panel*/
BAT2526shiftmarker=BAT25shitc+BAT26shitc;
BAT2526CountMarker=BAT25m+BAT26m;
if BAT2526shiftmarker=0 then msi2marker=0;
else if 1<=BAT2526shiftmarker<=2 then msi2marker=1;

proc sort data=msi; by TumorID; run;

data kras; infile '/udd/nhogi/Survival/DATA/kras20140903.dat' lrecl=35 recfm=d;
input
@1		TumorID	    4.
@5		krasScrapeID	    4.
@9		Kras12nuc	$   3.
@12		Kras12nucsecond	$   3.
@15		Kras12	    1.
@16		Kras13nuc	$   3.
@19		Kras13	    1.
@20		Krasother	$   9.
@29		KrasotherAminAcid $   4.
@33		KrasInstrument	    1.
@34		krasFlag		    1.;
if Kras12=1  then Kras12mut=1; 
else if Kras12=0 and Kras12nuc = 'ggt' then Kras12mut=0; 
if Kras12nuc = 'tgt'  then Kras12mutgt=1; 
else if Kras12=0 and Kras12nuc = 'ggt' and Kras12nuc = 'agt' and Kras12nuc = 'cgt' and Kras12nuc = 'gat' and Kras12nuc = 'gct' and Kras12nuc = 'gtt' and Kras12nuc = 'gca' then Kras12mutgt=0; 
if Kras13=1  then Kras13mut=1;
else if Kras13=0 and Kras13nuc = 'ggc' then Kras13mut=0; 
if Kras12mut=1 or Kras13mut=1 then mutate=1;
else if Kras12mut=0 and Kras13mut=0 then mutate=2;
if mutate=1 then krasmut=1; 
else if mutate=2 then krasmut=0; 
proc sort data=kras; by TumorID; run;




/*KRAS codon 61 & 146*/
data kras2; infile '/udd/nhogi/Survival/DATA/kras61_146.dat' lrecl=18 recfm=d;
input
@1		TumorID	    4.
@5		kras2ScrapeID	    4.
@9		Kras61nuc	$   3.
@12		Kras61	    1.
@13		k180_181delinsAA     1.
@14		Kras146nuc	$   3.
@17		Kras146	    1.;

if Kras61=1  then Kras61mut=1; 
else if Kras61=0 and Kras61nuc = 'caa' then Kras61mut=0; 
if Kras146=1  then Kras146mut=1;
else if Kras146=0 and Kras146nuc = 'gca' then Kras146mut=0;  
proc sort data=kras2; by TumorID; run;




/*FASN*/
data fasn; infile '/udd/nhogi/Survival/DATA/FASN.dat' lrecl=23 recfm=d;
input  @1	TumorID	    4.
@5		fasnTMA		    1.
@6		fasnBlockSlideNo	$   6.
@12		fasnPathDx	    1.
@13		fasnIHCoverall     1.
@14		fasnIHCstrongest     1.
@15		fasnIHCpos	    2.
@17		fasnIHCnormalcontrol     1.
@18		fasnIHCnormalworked     1.
@19		fasnTissueSize	    1.
@20		fasnFlagged	    1.
@21		fasnfatabsent	    1.
@22		fasnExcludedups	    1.  ;
proc sort data=fasn; by TumorID; run; 

data fasnnew; infile '/udd/nhogi/Survival/DATA/FASNnew.dat' lrecl=51 recfm=d;
input
@1		fasnnewIHCID	    4.
@5		TumorID	    4.
@9		fasnnewDate		$   18.
@27		fasnnewReviewerID	    1.
@28		fasnnewLookID	    1.
@29		fasnnewTMA		    1.
@30		fasnnewBlockSlideNo	$   3.
@33		fasnnewPathDx	    1.
@34		fasnnewIHCoverall     1.
@35		fasnnewIHCstrongest     1.
@36		fasnnewIHCnormalcontrol     1.
@37		fasnnewIHCnormalworked     1.
@38		fasnnewIHCFASN	$   9.
@47		fasnnewTissueSize	    1.
@48		fasnnewFlagged	    1.
@49		fasnnewfatabsent	    1.
@50		fasnnewExcludedups	    1.;
proc sort data=fasnnew; by TumorID; run; 

data fasntma121; infile '/udd/nhogi/Survival/DATA/FASNTMA12sub1.dat' lrecl=60 recfm=d;
input
@1		fasntma121IHCID	    4.
@5		TumorID	    4.
@9		fasntma121Date		$   18.
@27		fasntma121ReviewerID	    1.
@28		fasntma121LookID	    1.
@29		fasntma121TMA		    1.
@30		fasntma121BlockSlideNo	    2.
@32		fasntma121PathDx	    1.
@33		fasntma121overall     1.
@34		fasntma121strongest     1.
@35		fasntma121normalcontrol     1.
@36		fasntma121normalworked     1.
@37		fasntma121IHC	$   18.
@55		fasntma121TissueSize	    1.
@56		fasntma121Flagged	    1.
@57		fasntma121fatabsent	    1.
@58		fasntma121Excludedups	    1.
@59		fasntma121BlockSlidesubNo     1.;
proc sort data=fasntma121; by TumorID; run; 

data fasntma122; infile '/udd/nhogi/Survival/DATA/FASNTMA12sub2.dat' lrecl=42 recfm=d;
input
@1		fasntma122IHCID	    4.
@5		TumorID	    4.
@9		fasntma122Date		$   18.
@27		fasntma122ReviewerID	    1.
@28		fasntma122LookID	    1.
@29		fasntma122TMA		    1.
@30		fasntma122BlockSlideNo	    2.
@32		fasntma122PathDx	    1.
@33		fasntma122overall     1.
@34		fasntma122strongest     1.
@35		fasntma122normalcontrol     1.
@36		fasntma122normalworked     1.
@37		fasntma122TissueSize	    1.
@38		fasntma122Flagged	    1.
@39		fasntma122fatabsent	    1.
@40		fasntma122Excludedups	    1.
@41		fasntma122BlockSlidesubNo     1.;
proc sort data=fasntma122; by TumorID; run; 

/*CDX2*/
data cdx2; infile '/udd/nhogi/Survival/DATA/CDX2.dat' lrecl=22 recfm=d;
input
@1	    CDX2ID	    3.
@4		TumorID	    4.
@8		cdx2ReviewerID	    1.
@9		CDX2BlockSlideNo	    2.
@11		CDX2Overall     1.
@12		CDX2Strongest     1.
@13		CDX2OverallComparisonN     1.
@14		CDX2StrongestComparisonN     1.
@15		CDX2modstrong     2.
@17		CDX2wkstrong     2.
@19		cdx2Flagged	    1.
@20		CDX2normaltissueScoreOverall     1.
@21		cdx2BlockSlideSubNo	    1.;
proc sort data=cdx2; by tumorID; run; 

/*PTGS2 (the official symbol for COX-2)*/
data cox2all; infile '/udd/nhogi/Survival/DATA/COX2all.dat' lrecl=57 recfm=d;
input @1	TumorID	    4.
@5		cox2allExpr1001	    1.
@6		cox2allExpr1002	$   5.
@11		cox2allPathDx	    1.
@12		cox2allIHCoverall     1.
@13		cox2allIHCstrongest     1.
@14		cox2allTMA		    1.
@15		cox2allBlockSlideNo	$   5.
@20		cox2allIHCpos	    3.
@23		cox2allIHCsmall	    1.
@24		cox2allIHCTMAnormal     1.
@25		cox2allIHCComarisonAdenoma     1.
@26		cox2allIHC	$   29.
@55		cox2allFlagged	    1.
@56		cox2allExclude	    1.;
proc sort data=cox2all; by TumorID; run;

data cox2new; infile '/udd/nhogi/Survival/DATA/COX2new.dat' lrecl=51 recfm=d;
input
@1		cox2newIHCID	    4.
@5		TumorID	    4.
@9		cox2newDate		$   16.
@25		cox2newReviewerID	    1.
@26		cox2newLookID	    1.
@27		cox2newTMA		    1.
@28		cox2newPathDx	    1.
@29		cox2newIHCoverall     1.
@30		cox2newIHCstrongest     1.
@31		cox2newIHCsmall	    1.
@32		cox2newIHCTMAnormal     1.
@33		cox2newIHCnoComparison     1.
@34		cox2newIHCComarisonAdenoma     1.
@35		cox2newIHCstroma     1.
@36		cox2newIHC	$   12.
@48		cox2newFlagged	    1.
@49		cox2newExclude	    1.
@50		cox2newBlockSlideSubNo	    1.;
if cox2newIHCoverall =1 then cox2=1; 
else if cox2newIHCoverall =2 then cox2=2; 
else if cox2newIHCoverall =3 then cox2=3; 
else if cox2newIHCoverall=4 then cox2=4; 
if cox2=1 then cox=0; else cox=1; 
	 if     cox2=1 then cox2cat=1;
else if 2<=cox2<=4 then cox2cat=2; 
proc sort data=cox2new; by TumorID; run;

data cox2tma121; infile '/udd/nhogi/Survival/DATA/COX2TMA12sub1.dat' lrecl=54 recfm=d;
input
@1		cox2tma121IHCID	    4.
@5		TumorID	    4.
@9		cox2tma121Date		$   17.
@26		cox2tma121ReviewerID	    1.
@27		cox2tma121LookID	    1.
@28		cox2tma121TMA		    1.
@29		cox2tma121BlockSlideNo	    2.
@31		cox2tma121PathDx	    1.
@32		cox2tma121overall     1.
@33		cox2tma121strongest     1.
@34		cox2tma121small	    1.
@35		cox2tma121normal     1.
@36		cox2tma121noCompa     1.
@37		cox2tma121CompaAdenoma     1.
@38		cox2tma121stroma     1.
@39		cox2tma121IHC	$   12.
@51		cox2tma121Flagged	    1.
@52		cox2tma121Exclude	    1.
@53		cox2tma121BlockSlideSubNo	    1.;
proc sort data=cox2tma121; by TumorID; run;

data cox2tma122; infile '/udd/nhogi/Survival/DATA/COX2TMA12sub2.dat' lrecl=42 recfm=d;
input
@1		cox2tma122IHCID	    4.
@5		TumorID	    4.
@9		cox2tma122Date		$   17.
@26		cox2tma122ReviewerID	    1.
@27		cox2tma122LookID	    1.
@28		cox2tma122TMA		    1.
@29		cox2tma122BlockSlideNo	    2.
@31		cox2tma122PathDx	    1.
@32		cox2tma122overall     1.
@33		cox2tma122strongest     1.
@34		cox2tma122small	    1.
@35		cox2tma122normal     1.
@36		cox2tma122noCompa    1.
@37		cox2tma122CompaAdenoma     1.
@38		cox2tma122stroma     1.
@39		cox2tma122Flagged    1.
@40		cox2tma122Exclude	    1.
@41		cox2tma122BlockSlideSubNo	    1.;
proc sort data=cox2tma122; by TumorID; run;

data ptgs2newtma1314; infile '/udd/nhogi/Survival/DATA/CleanPTGS2newTMA1314.dat' lrecl=39 recfm=d;
input
@1		IHCPTGS2novo_ID	    4.
@5		TumorID	    4.
@9		ptgs2tma1314intReviewerID     1.
@10		ptgs2tma1314intLookID     1.
@11		ptgs2tma1314strBlockSlideNo     3.
@14		ptgs2tma1314intBlockSubNo     1.
@15		ptgs2tma1314intPathDx     1.
@16		ptgs2tma1314overall     1.
@17		ptgs2tma1314intIHCPTGS2strongest     1.
@18		ptgs2tma1314ysnIHCsmall $   5.
@23		ptgs2tma1314PTGS2TMAnormal $   5.
@28		ptgs2tma1314PTGS2noComparison     1.
@29		ptgs2tma1314ysnFlagged $   5.
@34		ptgs2tma1314ysnExclude $   5.
;

proc sort data=ptgs2newtma1314; by TumorID; run;

/*TP53 (the official symbol for p53)*/
data p53; infile '/udd/nhogi/Survival/DATA/p53.dat' lrecl=70 recfm=d;
input
@1		TumorID	    4.
@5		p53TMA		    1.
@6		p53BlockSlideNo	$   6.
@12		p53PathDx	    1.
@13		p53IHCoverall     1.
@14		p53IHCstrongest     1.
@15		p53IHCpos	    3.
@18		p53IHC	$   50.
@68		p53Flagged	    1.
@69		p53ExcludeDuplicate     1.;
proc sort data=p53; by TumorID; run; 

data p53new; infile '/udd/nhogi/Survival/DATA/p53new.dat' lrecl=42 recfm=d;
input
@1		p53newIHCID	    4.
@5		TumorID	    4.
@9		p53newDate		$   18.
@27		p53newReviewerID	    1.
@28		p53newLookID	    1.
@29		p53newTMA		    1.
@30		p53newBlockSlideNo	$   3.
@33		p53newPathDx	    1.
@34		p53newIHCoverall     1.
@35		p53newIHCstrongest     1.
@36		p53newIHCpos	    2.
@38		p53newIHCresult	    1.
@39		p53newFlagged	    1.
@40		p53newExcludeDuplicate     1.
@41		p53newBlockSlideSubNo	    1.;
proc sort data=p53new; by TumorID; run; 

data p53tma121; infile '/udd/nhogi/Survival/DATA/p53TMA12sub1.dat' lrecl=51 recfm=d;
input
@1		p53tma121IHCID	    4.
@5		TumorID	    4.
@9		p53tma121Date		$   18.
@27		p53tma121ReviewerID	    1.
@28		p53tma121LookID	    1.
@29		p53tma121TMA		    1.
@30		p53tma121BlockSlideNo	    2.
@32		p53tma121PathDx	    1.
@33		p53tma121overall     1.
@34		p53tma121strongest     1.
@35		p53tma121perc	    2.
@37		p53tma121IHCresult	    1.
@38		p53tma121IHC	$   10.
@48		p53tma121Flagged	    1.
@49		p53tma121ExcludeDuplicate     1.
@50		p53tma121BlockSlideSubNo	    1. ;
proc sort data=p53tma121; by TumorID; run; 

data p53tma122; infile '/udd/nhogi/Survival/DATA/p53TMA12sub2.dat' lrecl=41 recfm=d;
input
@1		p53tma122IHCID	    4.
@5		TumorID	    4.
@9		p53tma122Date		$   18.
@27		p53tma122ReviewerID	    1.
@28		p53tma122LookID	    1.
@29		p53tma122TMA		    1.
@30		p53tma122BlockSlideNo	    2.
@32		p53tma122PathDx	    1.
@33		p53tma122overall     1.
@34		p53tma122strongest     1.
@35		p53tma122perc	    2.
@37		p53tma122IHCresult	    1.
@38		p53tma122Flagged	    1.
@39		p53tma122ExcludeDuplicate     1.
@40		p53tma122BlockSlideSubNo	    1. ;
proc sort data=p53tma122; by TumorID; run; 

/*CTNNB1 (the official symbol for beta-catenin)*/
data ctnnb1; infile '/udd/nhogi/Survival/DATA/ctnnb1.dat' lrecl=21 recfm=d;
input
@1		TumorID	    4.
@5		bcateReviewerID	    1.
@6		bcateoverallcyto     1.
@7		bcatestrongestcyto     1.
@8		bcateperccyto     2.
@10		bcateoverallnuclear     1.
@11		bcatestrongestnuclear     1.
@12		bcatepercnuclear     2.
@14		bcateoverallmemb     1.
@15		bcatestrongestmemb     1.
@16		bcatepercmemb     3.
@19		bcateExcludedups	    1.
@20		bcatePathDx	    1. ;
if 1<=bcatestrongestmemb<=2 then ctmemb=0; 
else if    bcatestrongestmemb =3 then ctmemb=1; 
else if    bcatestrongestmemb =4 then ctmemb=2;
	 if 1<=bcatestrongestmemb<=2 then ctmem=0; 
else if 3<=bcatestrongestmemb<=4 then ctmem=1; 
	 if 1<=bcateoverallcyto <=2 then ctbc3c=0; 
else if    bcateoverallcyto =3  then ctbc3c=1;  
else if    bcateoverallcyto =4  then ctbc3c=2;  
	 if 1<=bcatestrongestnuclear <=2 then ctbn=1;
else if 3<=bcatestrongestnuclear <=4 then ctbn=2;  
	 if 1<=bcatestrongestnuclear <=2 then ctbn3=0; 
else if    bcatestrongestnuclear =3  then ctbn3=1;  
else if    bcatestrongestnuclear =4  then ctbn3=2;  
ctnnb = ctmem + ctbc3c + ctbn3; 
	 if      ctnnb = 0  then ctnnb3c = 1;
else if 1 <= ctnnb <=2  then ctnnb3c = 2;
else if      ctnnb >=3  then ctnnb3c = 3;
	 if 0<= ctnnb <=2 then ctnnb2c = 1; 
else if     ctnnb >=3 then ctnnb2c = 2; 
if ctnnb2c=2 then ctnnb1=1; else ctnnb1=0; 
proc sort data=ctnnb1; by TumorID; run; 

/*LINE1*/
data line1; infile '/udd/nhogi/Survival/DATA/LINE1new2014.dat' lrecl=70 recfm=d;
input
@1		line1BisulfiteID	    4.
@5		line1Tvalue		$   1.
@6		TumorID	    4.
@10		line1BlockID		$   10.
@20		line1datepyro	$   18.
@38		line1overallpyro    1.
@39		line1pos1Cmethylated    5.
@44		line1pos1check	    1.
@45		line1pos2Cmethylated    5.
@50		line1pos2check	    1.
@51		line1pos3Cmethylated     6.
@57		line1pos3check	    1.
@58		line1pos4Cmethylated     5.
@63		line1pos4check	    1.
@64		line1peakheightcf	$   5.
@69		line1excludeduplicate    1.
;
if TumorID ne .;
/*poscheck=0(blue), poscheck=1(yellow), poscheck=2(red)*/
if 0<=line1pos1check<=1 then line1pos1V=1;
else if line1pos1check=2 then line1pos1V=0;
if 0<=line1pos2check<=1 then line1pos2V=1;
else if line1pos2check=2 then line1pos2V=0;
if 0<=line1pos3check<=1 then line1pos3V=1;
else if line1pos3check=2 then line1pos3V=0;
if 0<=line1pos4check<=1 then line1pos4V=1;
else if line1pos4check=2 then line1pos4V=0;

line1totalposition=line1pos1V+line1pos2V+line1pos3V+line1pos4V;

line1AVGsimple=(line1pos1Cmethylated+line1pos2Cmethylated+line1pos3Cmethylated+line1pos4Cmethylated)/4;

line1pos1Cmethylatedvalue=line1pos1Cmethylated*line1pos1V;
line1pos2Cmethylatedvalue=line1pos2Cmethylated*line1pos2V;
line1pos3Cmethylatedvalue=line1pos3Cmethylated*line1pos3V;
line1pos4Cmethylatedvalue=line1pos4Cmethylated*line1pos4V;

line1totalvalue=line1pos1Cmethylatedvalue+line1pos2Cmethylatedvalue+line1pos3Cmethylatedvalue+line1pos4Cmethylatedvalue;

if line1totalposition ne 0 then do;
lineavgr=line1totalvalue/line1totalposition; end;
if 0<=line1totalposition<=2 then delete;

if 75<=lineavgr<=100 then line4f=1; 
else if 60<=lineavgr <75  then line4f=2;
else if 45<=lineavgr <60  then line4f=3;
else if 0<= lineavgr <45  then line4f=4; 
	 if 70<=lineavgr<100  then line3f=1; 
else if 50<=lineavgr <70  then line3f=2;
else if 0<= lineavgr <50  then line3f=3; 
	 if 60<=lineavgr <=100 then linecat=0; 
else if 0<= lineavgr <60   then linecat=1; 
lineavg = (100 - lineavgr)/30; 
	 if lineavgr = . then line1=0; else line1=lineavg; 
	 if lineavgr = . then linemis=1; else linemis=0; 
	 if lineavgr = . then line=1.3; else line=lineavg; 

proc sort data=line1; by TumorID; run; 


/*CDKN1A (p21, CIP1)*/
data p21; infile '/udd/nhogi/Survival/DATA/p21.dat' lrecl=30 recfm=d;
input
@1		p21TumorID	  $ 4.
@5		p21TMA		    1.
@6		p21BlockSlideNo	$   8.
@14		p21PathDx	    1.
@15		p21overall     1.
@16		p21strongest     1.
@17		p21perc	    2.
@19		p21normalcontrol     1.
@20		p21normalworked     1.
@21		p21mesenchymalworked     1.
@22		p21adenomaworked     1.
@23		p21TissueSize	    1.
@24		p21ExcludeDups	    1.
@25		p21Flagged	    1. ;

if p21TumorID ne '9t"' then TumorID=p21TumorID*1;
else TumorID=.;
run;

proc sort data=p21; by TumorID; run; 

/*CDKN1B (p27, KIP1)*/
data p27; infile '/udd/nhogi/Survival/DATA/p27.dat' lrecl=30 recfm=d;
input
@1		TumorID	    4.
@5		p27TMA		    1.
@6		p27BlockSlideNo	$   10.
@16		p27PathDx	    1.
@17		p27SmallTissue	    1.
@18		p27TissueSize	    1.
@19		p27Noverall     1.
@20		p27Nperc	    2.
@22		p27Coverall     1.
@23		p27Cperc	    2.
@25		p27Flagged	    1.
@26		p27ExcludeDups	    1.
@27		p27NCpercDiff	    3. ;
proc sort data=p27; by TumorID; run; 

/*CDKN2A (p16, INK4A)*/
data p16; infile '/udd/nhogi/Survival/DATA/p16.dat' lrecl=21 recfm=d;
input
@1		TumorID	    4.
@5		p16ExcludeDuplicate     1.
@6		p16TMA		    1.
@7		p16BlockSlideNo	$   8.
@15		p16overall     1.
@16		p16strongest     1.
@17		p16lostArea	    1.
@18		p16internalcontrolpositive     1.
@19		p16smallarealoss     1.
@20		p16Flagged	    1. ;
proc sort data=p16; by TumorID; run; 

/*CCND1*/
data ccnd1; infile '/udd/nhogi/Survival/DATA/CCND1.dat' lrecl=18 recfm=d;
input @1   TumorID	    4.
@5		ccnd1TMA		    1.
@6		ccnd1PathDx	    1.
@7		ccnd1Expr1003	    1.
@8		ccnd1Flagged	    1.
@9		ccnd1Excludedups	    1.
@10		ccnd1TissueSize	    1.
@11		CCND1overall     1.
@12		CCND1strongest     1.
@13		CCND1modstrongperc     2.
@15		CCND1wkstrongperc     3. ;
proc sort data= ccnd1; by TumorID; run; 

data ccnd1tma1314; infile '/udd/nhogi/Survival/DATA/CCND1newTMA1314.dat' lrecl=25 recfm=d;
input
@1		TumorID	    4.
@5		strBlockSlideNo	    3.
@8		CCND1overall1314     1.
@9		CCND1strongest1314     1.
@10		CCND1msperc     2.
@12		CCND1CAwsperc     2.
@14		intCCND1CAnormal     1.
@15		ysnFlagged	$   5.
@20		ysnExcludedups	$   5.
;
proc sort data= ccnd1tma1314; by TumorID; run; 

/*PIK3CA*/
data pik3ca; infile '/udd/nhogi/Survival/DATA/pik3ca20140903.dat' lrecl=15 recfm=d;

input
@1		TumorID	    4.
@5		pikfail		    1.
@6		pikwt	    1.
@7		pikmt	    1.
@8		pikflag		    1.
@9		pikExcludeDup	    1.
@10		PIK3CA1mut	    1.
@11		pik3cagtoa		    1.
@12		PIKex1done	    1.
@13		PIK3CA9mut	    1.
@14		PIK3CA20mut	    1.
;


if pik3cagtoa=1 and PIK3CA1mut=1 then pikgtoa1=1;
else if  PIKex1done=1 and pikwt=1 then pikgtoa1=0;
else if pik3cagtoa=0 and PIK3CA1mut=1 then pikgtoa1=0;
if pik3cagtoa=1  then pikgtoa=1;
else  pikgtoa=0;
proc sort data=pik3ca; by TumorID; run;


/*CDK8*/
data cdk8; infile '/udd/nhogi/Survival/DATA/CDK8RF.dat' lrecl=102 recfm=d;
input @1		TumorID	    4.
@5		cdk8Date		$   17.
@22		cdk8Comment		$   67.
@89		cdk8Flagged	    1.
@90		cdk8Excludedups	    1.
@91		cdk8TMA		    1.
@92		cdk8PathDx	    1.
@93		cdk8ReviewerID	    1.
@94		cdk8LookID	    1.
@95		cdk8noverall     1.
@96		cdk8nstrongest     1.
@97		cdk8cyto       1.
@98		cdk8perc	    3.
@101    cdk8normal     1. ;
proc sort data=cdk8; by tumorID; run; 

data cdk8ks; infile '/udd/nhogi/Survival/DATA/CDK8ks.dat' lrecl=18 recfm=d;
input @1		TumorID	    4.
@5		cdk8ksFlagged	    1.
@6		cdk8ksTMA		    1.
@7		cdk8ksPathDx	    1.
@8		cdk8ksNOverall     1.
@9		cdk8ksExcludedups	    1.
@10		cdk8ksLookID	    1.
@11		cdk8ksReviewerID	    1.
@12		cdk8ksNStrongest     1.
@13		cdk8ksCyto     1.
@14		cdk8ksperc	    2.
@16		CDK8ksResult	    1.
@17		cdk8ksnormal     1. ;
proc sort data=cdk8ks; by tumorID; run; 


/*SIRT1*/
data sirt1; infile '/udd/nhogi/Survival/DATA/sirt1full.dat' lrecl=29 recfm=d;
input
@1		TumorID	    4.
@5		sirt1TMA		    1.
@6		sirt1PathDx	    1.
@7		sirt1ReviewerID	    1.
@8		sirt1ComparedNoverall     1.
@9		sirt1ComparedNstrongest     1.
@10		sirt1percweakstrong     2.
@12		sirt1N	$   6.
@18		sirt1NoComparisonoverall     1.
@19		sirt1NoComparisonstrongest     1.
@20		sirt1Cpercmodstrong     2.
@22		sirt1Flagged	    1.
@23		sirt1ExcludeDups	    1.
@24		sirt1BlockSlideNo	$   5.
;
proc sort data=sirt1; by TumorID; run; 

data sirt1sub1; infile '/udd/nhogi/Survival/DATA/sirt1tma12sub1.dat' lrecl=36 recfm=d;
input
@1		TumorID	    4.
@5		sirt1sub1TMA		    1.
@6		sirt1sub1PathDx	    1.
@7		sirt1sub1ReviewerID	    1.
@8		sirt1sub1ComparedNoverall     1.
@9		sirt1sub1ComparedNstrongest     1.
@10		sirt1sub1percweakstrong     2.
@12		sirt1sub1NoComparisonoverall     1.
@13		sirt1sub1NoComparisonstrongest     1.
@14		sirt1sub1Cpercmodstrong     2.
@16		sirt1sub1C	$   15.
@31		sirt1sub1Flagged	    1.
@32		sirt1sub1ExcludeDups	    1.
@33		sirt1sub1BlockSubNo	    1.
@34		sirt1sub1BlockSlideNo	    2.
;
proc sort data=sirt1sub1; by TumorID; run; 

data sirt1sub2; infile '/udd/nhogi/Survival/DATA/sirt1tma12sub2.dat' lrecl=21 recfm=d;
input
@1		TumorID	    4.
@5		sirt1sub2TMA		    1.
@6		sirt1sub2PathDx	    1.
@7		sirt1sub2ReviewerID	    1.
@8		sirt1sub2ComparedNoverall     1.
@9		sirt1sub2ComparedNstrongest     1.
@10		sirt1sub2percweakstrong     2.
@12		sirt1sub2NoComparisonoverall     1.
@13		sirt1sub2NoComparisonstrongest     1.
@14		sirt1sub2Cpercmodstrong     2.
@16		sirt1sub2Flagged	    1.
@17		sirt1sub2ExcludeDups	    1.
@18		sirt1sub2BlockSubNo	    1.
@19		sirt1sub2BlockSlideNo	    2.
;
proc sort data=sirt1sub2; by TumorID; run; 


/*STMN1*/
data stmn; infile '/udd/nhogi/Survival/DATA/STMN.dat' lrecl=22 recfm=d;
input  @1	stmnID	    3.
@4		TumorID	    4.
@8		stmnReviewerID	    1.
@9		stmnTMA		    1.
@10		stmnPathDx	    1.
@11		stmnOverall     1.
@12		stmnStrongest     1.
@13		stmnoverall_compn     1.
@14		stmnstrongest_compn    1.
@15	    stmnmodstrongperc     2.
@17		stmnwkstrongperc     2.
@19		stmnedgeoftissue     1.
@20		stmnFlagged	    1.
@21		stmnExcludedups	    1. ;
proc sort data=stmn; by TumorID; run;

/*PPARG*/
data pparg; 
infile '/udd/nhogi/Survival/DATA/PPARG.dat' lrecl=27 recfm=d;
input  @1		ppargID	    4.
@5		TumorID	    4.
@9		ppargReviewerID	    1.
@10		ppargTMA		    1.
@11		ppargBlockSlideNo	 $   2.
@13		ppargPathDx	    1.
@14		ppargnuclearoverall     1.
@15		ppargperc		    2.
@17		ppargcompare	    1.
@18		ppargoverexp	    1.
@19		ppargnlstrongest     1.
@20		ppargcytoplasmoverall     1.
@21		ppargcytoperc	    2.
@23		ppargnormal	    1.
@24		PPARGFlagged	    1.
@25		ppargExcludedups	    1.
@26		ppargLookID	    1. ;
proc sort data=pparg; by TumorID; run; 

/*RPS6 (p-RPS6)*/
data rps6; infile '/udd/nhogi/Survival/DATA/RPS6.dat' lrecl=20 recfm=d;
input
@1		TumorID	    4.
@5		RPS6Expr1001	    1.
@6		RPS6PathDx	    1.
@7		RPS6Overall     1.
@8		RPS6Strongest     1.
@9		RPS6Overall_Compare_N     1.
@10		RPS6Strongest_Compare_N     1.
@11		RPS6mod_strperc    2.
@13		RPS6wk_strperc    2.
@15		RPS6edgescore     1.
@16		RPS6tissueSize	    1.
@17		RPS6Flagged	    1.
@18		RPS6Excludedups	    1.
@19		RPS6TMA		    1.;
proc sort data=rps6; by tumorID; run; 

/*IGF2DMR0*/
data IGF2DMR0; infile '/udd/nhogi/Survival/DATA/IGF2DMR0.dat' lrecl=83 recfm=d;
input
@1		IGF2DMR0ID		    4.
@5		IGF2DMR0BisulfiteID	    4.
@9		tumorID	    4.
@13		IGF2DMR0BlockID		$   6.
@19		IGF2DMR0date	$   18.
@37		IGF2DMR0overall     1.
@38		IGF2DMR0pos1perc     5.
@43		IGF2DMR0pos1check    1.
@44		IGF2DMR0pos2perc      5.
@49		IGF2DMR0pos2check    1.
@50		IGF2DMR0pos3perc      5.
@55		IGF2DMR0pos3check    1.
@56		IGF2DMR0excludedups     1.
@57		IGF2DMR0comment $   25.
@82		IGF2DMR0normal_tissue	    1.;
proc sort data=IGF2DMR0; by tumorID; run; 

/*AKT (p-AKT)*/
data pakt; 
infile '/udd/nhogi/Survival/DATA/pAkt.dat' lrecl=23 recfm=d;
input
@1		paktID	    3.
@4		TumorID	    4.
@8		paktReviewerID	    1.
@9		paktLookID	    1.
@10		paktBlockSlideNo	    2.
@12		paktoverall     1.
@13		paktstrongest     1.
@14		paktposperc	    2.
@16		paktavgIntensity     1.
@17		paktxIntperc	    1.
@18		pAktnoComparison     1.
@19		paktNUCoverall     1.
@20		paktNUCposperc     2.
@22		pAktNUCnoComparison     1.;
proc sort data=pakt; by TumorID; run; 

data paktTMA12sub1; 
infile '/udd/nhogi/Survival/DATA/p-AktTMA12sub1.dat' lrecl=48 recfm=d;
input
@1		paktTMA121ID	    4.
@5		TumorID	    4.
@9		paktTMA121Date		$   18.
@27		paktTMA121ReviewerID	    1.
@28		paktTMA121LookID	    1.
@29		paktTMA121TMA		    1.
@30		paktTMA121BlockSlideNo	    2.
@32		paktTMA121overall     1.
@33		paktTMA121strongest    1.
@34		paktTMA121percpos	    2.
@36		paktTMA121avgIntensity     1.
@37		paktTMA121normal     1.
@38		paktTMA121noComparison     1.
@39		paktTMA121NUCoverall     1.
@40		paktTMA121NUCstrongest     1.
@41		paktTMA121NUCpercpos     2.
@43		paktTMA121NUCavgIntensity     1.
@44		paktTMA121NUCnormal     1.
@45		paktTMA121NUCnoComparison     1.
@46		paktTMA121Flagged	    1.
@47		paktTMA121BlockSlideSubNo	    1.;
proc sort data=paktTMA12sub1; by TumorID; run; 

data paktTMA12sub2; 
infile '/udd/nhogi/Survival/DATA/p-AktTMA12sub2.dat' lrecl=49 recfm=d;
input
@1		paktTMA122ID	    4.
@5		TumorID	    4.
@9		paktTMA122Date		$   18.
@27		paktTMA122ReviewerID	    1.
@28		paktTMA122LookID	    1.
@29		paktTMA122TMA		    1.
@30		paktTMA122BlockSlideNo	    2.
@32		paktTMA122PathDx	    1.
@33		paktTMA122overall     1.
@34		paktTMA122strongest     1.
@35		paktTMA122percpos	    2.
@37		paktTMA122avgIntensity     1.
@38		paktTMA122normal     1.
@39		paktTMA122noComparison     1.
@40		paktTMA122NUCoverall     1.
@41		paktTMA122NUCstrongest     1.
@42		paktTMA122NUCpercpos     2.
@44		paktTMA122NUCavgIntensity     1.
@45		paktTMA122NUCTMAnormal     1.
@46		paktTMA122NUCnoComparison     1.
@47		paktTMA122Flagged	    1.
@48		paktTMA122BlockSlideSubNo	    1.;
proc sort data=paktTMA12sub2; by TumorID; run; 

/*PTEN*/
data pten;
infile '/udd/nhogi/Survival/DATA/PTENnew.dat' lrecl=23 recfm=d;
input
@1		TumorID		    4.
@5		ptenReviewerID	    1.
@6		ptenExpr	    2.
@8		ptenPathDx		    1.
@9		ptenFlagged	    1.
@10		ptenExcludedups	    1.
@11		ptenExprn	    1.
@12		PTENoverallcomparedN     1.
@13		PTENstrongestcomparedN     1.
@14		PTENpercentlosscomparedN     2.
@16		PTENoverall		    1.
@17		PTENstrongest	    1.
@18		PTENpercent		    2.
@20		ptenBlockSlideNo	    2.
@22		ptenBlockSlideSubNo	    1.;
proc sort data=pten; by TumorID; run; 

/*CDH1*/
data CDH1;
infile '/udd/nhogi/Survival/DATA/CDH1KG.dat' lrecl=16 recfm=d;
input
@1		CDH1IHCID	    3.
@4		TumorID	    4.
@8		CDH1ReviewerID	    1.
@9		CDH1TMA		    1.
@10		CDH1BlockSlideNo	    2.
@12		CDH1overallcyto     1.
@13		CDH1overallnor     1.
@14		CDH1overallmem    1.
@15		CDH1BlockSlideSubNo	    1.
;
proc sort data=CDH1; by TumorID; run; 

data CDH1TMA12sub1;
infile '/udd/nhogi/Survival/DATA/CDH1KGTMA12sub1.dat' lrecl=33 recfm=d;
input
@1		CDH1TMA121IHCID	    3.
@4		TumorID	    4.
@8		CDH1TMA121Date		$   18.
@26		CDH1TMA121ReviewerID	    1.
@27		CDH1TMA121BlockSlideNo	    2.
@29		CDH1TMA121overallcyto     1.
@30		CDH1TMA121overallnor     1.
@31		CDH1TMA121overallmem     1.
@32		CDH1TMA121BlockSlideSubNo	    1.
;
proc sort data=CDH1TMA12sub1; by TumorID; run; 

data CDH1TMA12sub2;
infile '/udd/nhogi/Survival/DATA/CDH1KGTMA12sub2.dat' lrecl=16 recfm=d;
input
@1		CDH1TMA122IHCID	    4.
@5		TumorID	    4.
@9		CDH1TMA122ReviewerID	    1.
@10		CDH1TMA122BlockSlideNo	    2.
@12		CDH1TMA122overallcyto    1.
@13		CDH1TMA122overallnor     1.
@14		CDH1TMA122overallmem     1.
@15		CDH1TMA122BlockSlideSubNo	    1.
;
proc sort data=CDH1TMA12sub2; by TumorID; run; 

/*KDM1*/
data KDM1;
infile '/udd/nhogi/Survival/DATA/KDM1.dat' lrecl=23 recfm=d;
input
@1		KDM1IHCID	    3.
@4		TumorID	    4.
@8		KDM1ReviewerID	    1.
@9		KDM1PathDx	    1.
@10		KDM1IHCoverallnuclear     1.
@11		KDM1IHCposweaknucperc     2.
@13		KDM1IHCposstrongnucperc     2.
@15		KDM1IHCstrongestnuclear     1.
@16		KDM1IHCnocomparison     1.
@17		KDM1IHCnormalnuc     1.
@18		KDM1IHCposnucnormalperc     2.
@20		KDM1IHCstromal     1.;
proc sort data=KDM1; by TumorID; run; 

data KDM1TMA12sub1;
infile '/udd/nhogi/Survival/DATA/KDM1TMA12sub1.dat' lrecl=25 recfm=d;
input
@1		KDM1TMA121IHCID	    3.
@4		TumorID	    4.
@8		KDM1TMA121ReviewerID	    1.
@9		KDM1TMA121BlockSlideNo	    2.
@11		KDM1TMA121overall     1.
@12		KDM1TMA121pospercweaknuc     2.
@14		KDM1TMA121pospercstrongnuc     2.
@16		KDM1TMA121strongest     1.
@17		KDM1TMA121nocomparison     1.
@18		KDM1TMA121normal     1.
@19		KDM1TMA121percposnucnormal     2.
@21		KDM1TMA121stromal     1.
@22		KDM1TMA121normalcontrol     1.
@23		KDM1TMA121Flagged	    1.
@24		KDM1TMA121BlockSlideSubNo	    1.;
proc sort data=KDM1TMA12sub1; by TumorID; run; 

data KDM1TMA12sub2;
infile '/udd/nhogi/Survival/DATA/KDM1TMA12sub2.dat' lrecl=27 recfm=d;
input
@1		KDM1TMA122IHCID	    4.
@5		TumorID	    4.
@9		KDM1TMA122ReviewerID	    1.
@10		KDM1TMA122LookID	    1.
@11		KDM1TMA122BlockSlideNo	    2.
@13		KDM1TMA122overall     1.
@14		KDM1TMA122pospercweaknuc     2.
@16		KDM1TMA122pospercstrongnuc     2.
@18		KDM1TMA122strongest     1.
@19		KDM1TMA122nocomparison     1.
@20		KDM1TMA122normal     1.
@21		KDM1TMA122percposnucnormal     2.
@23		KDM1TMA122stromal     1.
@24		KDM1TMA122normalcontrol    1.
@25		KDM1TMA122Flagged	    1.
@26		KDM1TMA122BlockSlideSubNo	    1.;
proc sort data=KDM1TMA12sub2; by TumorID; run;

/*STAT3 (p-STAT3)*/
data STAT3TMA12sub1;infile '/udd/nhogi/Survival/DATA/STAT3TMA12sub1.dat' lrecl=50 recfm=d;
input
@1		STAT3TMA121IHCID	    4.
@5		TumorID	    4.
@9		STAT3TMA121Date		$   16.
@25		STAT3TMA121ReviewerID	    1.
@26		STAT3TMA121LookID	    1.
@27		STAT3TMA121TMA		    1.
@28		STAT3TMA121BlockSlideNo	    2.
@30		STAT3TMA121overallcyto     1.
@31		STAT3TMA121percposcyto     2.
@33		STAT3TMA121overallnuclear     1.
@34		STAT3TMA121strongestnuclear      1.
@35		STAT3TMA121nocomparison     1.
@36		STAT3TMA121percposnuclear     2.
@38		STAT3TMA121normalnuc     1.
@39		STAT3TMA121normalcyto     1.
@40		STAT3TMA121Inflammatory      1.
@41		STAT3TMA121IHCnormalcontrol     1.
@42		STAT3TMA121fibroblast     1.
@43		STAT3TMA121percposfibroblast     2.
@45		STAT3TMA121percposinfla     2.
@47		STAT3TMA121Flagged	    1.
@48		STAT3TMA121Excludedups	    1.
@49		STAT3TMA121BlockSlideSubNo	    1.;
proc sort data=STAT3TMA12sub1; by TumorID; run; 

data STAT3TMA12sub2;
infile '/udd/nhogi/Survival/DATA/STAT3TMA12sub2.dat' lrecl=30 recfm=d;
input
@1		STAT3TMA122ID	    4.
@5		TumorID	    4.
@9		STAT3TMA122ReviewerID	    1.
@10		STAT3TMA122LookID	    1.
@11		STAT3TMA122BlockSlideNo	    2.
@13		STAT3TMA122overallcyto     1.
@14		STAT3TMA122percposcyto     2.
@16		STAT3TMA122overallnuclear     1.
@17		STAT3TMA122strongestnuclear      1.
@18		STAT3TMA122nocomparison      1.
@19		STAT3TMA122percposnuclear     2.
@21		STAT3TMA122normalnuc     1.
@22		STAT3TMA122normalcyto    1.
@23		STAT3TMA122Inflammatory     1.
@24		STAT3TMA122fibroblast     1.
@25		STAT3TMA122percposfibroblast     2.
@27		STAT3TMA122percposinfla     2.
@29		STAT3TMA122BlockSlideSubNo	    1.;
proc sort data=STAT3TMA12sub2; by TumorID; run; 

data stat3; infile '/udd/nhogi/Survival/DATA/STAT3.dat' lrecl=30 recfm=d;
input
@1		stat3ID	    4.
@5		TumorID	    4.
@9		stat3ReviewerID	    1.
@10		stat3LookID	    1.
@11		stat3BlockSlideNo	    2.
@13		stat3overallcyto     1.
@14		stat3poscytoperc    2.
@16		stat3overallnuc     1.
@17		stat3strongestnuc     1.
@18		stat3nocomparison    1.
@19		stat3posnucperc     2.
@21		stat3normalnuc     1.
@22		stat3normalcyto     1.
@23		stat3Infla     1.
@24		stat3fibro     1.
@25		stat3posfibroperc     2.
@27		stat3posinflaperc     2.
@29		stat3Flagged	    1.;
proc sort data=stat3; by TumorID; run; 

/*PTGER2*/
data PTGER2;
infile '/udd/nhogi/Survival/DATA/PTGER2.dat' lrecl=26 recfm=d;
input
@1		PTGER2ID	    3.
@4		TumorID	    4.
@8		PTGER2ReviewerID	    1.
@9		PTGER2LookID	    1.
@10		PTGER2BlockSlideNo	    2.
@12		PTGER2overallcyto     1.
@13		PTGER2percposcyto     2.
@15		PTGER2strongestcyto     1.
@16		PTGER2nocomparison     1.
@17		PTGER2normalcyto     1.
@18		PTGER2Inflammatory     1.
@19		PTGER2normalcontrol     1.
@20		PTGER2fibroblast     1.
@21		PTGER2percposfibro     2.
@23		PTGER2percposinfla     2.
@25		PTGER2Flagged	    1.;
proc sort data=PTGER2; by TumorID; run;
 
data PTGER2TMA12sub1;
infile '/udd/nhogi/Survival/DATA/PTGER2TMA12sub1.dat' lrecl=25 recfm=d;
input
@1		PTGER2TMA121ID	    3.
@4		TumorID	    4.
@8		PTGER2TMA121ReviewerID	    1.
@9		PTGER2TMA121LookID	    1.
@10		PTGER2TMA121BlockSlideNo	    2.
@12		PTGER2TMA121overallcyto     1.
@13		PTGER2TMA121perccyto     2.
@15		PTGER2TMA121strongestcyto     1.
@16		PTGER2TMA121nocomparison     1.
@17		PTGER2TMA121normalcyto     1.
@18		PTGER2TMA121Inflammatory     1.
@19		PTGER2TMA121fibroblast     1.
@20		PTGER2TMA121percposfibro     2.
@22		PTGER2TMA121percposinfla     2.
@24		PTGER2TMA121BlockSlideSubNo	    1.;
proc sort data=PTGER2TMA12sub1; by TumorID; run;

data PTGER2TMA12sub2;
infile '/udd/nhogi/Survival/DATA/PTGER2TMA12sub2.dat' lrecl=26 recfm=d;
input
@1		PTGER2TMA122ID	    4.
@5		TumorID	    4.
@9		PTGER2TMA122ReviewerID	    1.
@10		PTGER2TMA122LookID	    1.
@11		PTGER2TMA122BlockSlideNo	    2.
@13		PTGER2TMA122overallcyto     1.
@14		PTGER2TMA122percposcyto     2.
@16		PTGER2TMA122strongestcyto     1.
@17		PTGER2TMA122nocomparison     1.
@18		PTGER2TMA122normalcyto     1.
@19		PTGER2TMA122Inflammatory     1.
@20		PTGER2TMA122fibroblast     1.
@21		PTGER2TMA122percposfibro     2.
@23		PTGER2TMA122percposinfla    2.
@25		PTGER2TMA122BlockSlideSubNo	    1.;
proc sort data=PTGER2TMA12sub2; by TumorID; run;

/*AURKA*/
data aurka; infile '/udd/nhogi/Survival/DATA/AURKA.dat' lrecl=38 recfm=d;
input @1		TumorID	    4.
@5		aurkaDate		$   17.
@22		aurkaReviewerID	    1.
@23		aurkaBlockSlideNo	  $  2.
@25		aurkaTMA		    1.
@26		AURKAoverall     1.
@27		AURKANoverall     1.
@28		AURKANstrongest     1.
@29		AURKANperc     2.
@31		AURKANnormalcomp     1.
@32		AURKANnoComparison     1.
@33		strIHCAURKA	$   3.
@36		AURKAFlag	    1.
@37		aurkaBlockSlideSubNo	    1.;
proc sort data=aurka; by tumorID; run; 

/*HIF1A*/
data HIF1A;
infile '/udd/nhogi/Survival/DATA/HIF1A.dat' lrecl=23 recfm=d;
input
@1		HIF1AIHCID	    4.
@5		TumorID	    4.
@9		HIF1AReviewerID	    1.
@10		HIF1ALookID	    1.
@11		HIF1ATMA		    1.
@12		HIF1ABlockSlideNo	    2.
@14		HIF1Aoverall     1.
@15		HIF1Astrongest     1.
@16		HIF1Aposperc	    2.
@18		HIF1AavgIntensity     1.
@19		HIF1Anormal     1.
@20		HIF1AnoComparison    1.
@21		HIF1ANUCoverall     1.
@22		HIF1ABlockSlidesubNo     1.;
proc sort data=HIF1A; by TumorID; run; 

data HIF1ATMA12sub1;
infile '/udd/nhogi/Survival/DATA/HIF1ATMA12sub1.dat' lrecl=25 recfm=d;
input
@1		HIF1ATMA121IHCID	    3.
@4		TumorID	    4.
@8		HIF1ATMA121ReviewerID	    1.
@9		HIF1ATMA121LookID	    1.
@10		HIF1ATMA121TMA		    1.
@11		HIF1ATMA121BlockSlideNo	    2.
@13		HIF1ATMA121PathDx	    1.
@14		HIF1ATMA121overall   1.
@15		HIF1ATMA121strongest     1.
@16		HIF1ATMA121posperc     2.
@18		HIF1ATMA121AavgIntensity    1.
@19		HIF1ATMA121normalysn      1.
@20		HIF1ATMA121normal     1.
@21		HIF1ATMA121noComparison     1.
@22		HIF1ATMA121NUCoverall     1.
@23		HIF1ATMA121Flagged	    1.
@24		HIF1ATMA121BlockSlidesubNo     1.;
proc sort data=HIF1ATMA12sub1; by TumorID; run; 

data HIF1ATMA12sub2;
infile '/udd/nhogi/Survival/DATA/HIF1ATMA12sub2.dat' lrecl=40 recfm=d;
input
@1		HIF1ATMA122IHCID	    4.
@5		TumorID	    4.
@9		HIF1ATMA122Date		$   16.
@25		HIF1ATMA122ReviewerID	    1.
@26		HIF1ATMA122LookID	    1.
@27		HIF1ATMA122TMA		    1.
@28		HIF1ATMA122BlockSlideNo	    2.
@30		HIF1ATMA122PathDx	    1.
@31		HIF1ATMA122overall      1.
@32		HIF1ATMA122strongest     1.
@33		HIF1ATMA122posperc 	    2.
@35		HIF1ATMA122avgIntensity      1.
@36		HIF1ATMA122normalysn     1.
@37		HIF1ATMA122normal     1.
@38		HIF1ATMA122noComparison     1.
@39		HIF1ATMA122BlockSlidesubNo     1.;
proc sort data=HIF1ATMA12sub2; by TumorID; run; 

/*EPAS1 (HIF-2A)*/
data EPAS1;
infile '/udd/nhogi/Survival/DATA/EPAS1.dat' lrecl=19 recfm=d;
input
@1		EPAS1IHCID	    3.
@4		TumorID	    4.
@8		EPAS1BlockSlideNo	    2.
@10		EPAS1overall     1.
@11		EPAS1strongest     1.
@12		EPAS1posperc	    2.
@14		EPAS1TMAnormal     1.
@15		EPAS1noComparison     1.
@16		EPAS1stromall     1.
@17		EPAS1NUCoverall     1.
@18		EPAS1BlockSlidesubNo     1.;
proc sort data=EPAS1; by TumorID; run; 

data EPAS1TMA12sub1;
infile '/udd/nhogi/Survival/DATA/EPAS1TMA12sub1.dat' lrecl=26 recfm=d;
input
@1		EPAS1TMA121IHCID	    4.
@5		TumorID	    4.
@9		EPAS1TMA121ReviewerID	    1.
@10		EPAS1TMA121LookID	    1.
@11		EPAS1TMA121TMA		    1.
@12		EPAS1TMA121BlockSlideNo	    2.
@14		EPAS1TMA121PathDx	    1.
@15		EPAS1TMA121overall     1.
@16		EPAS1TMA121strongest     1.
@17		EPAS1TMA121posperc    2.
@19		EPAS1TMA121normalysn     1.
@20		EPAS1TMA121normal     1.
@21		EPAS1TMA121noComparison    1.
@22		EPAS1TMA121stromall   1.
@23		EPAS1TMA121NUCoverall     1.
@24		EPAS1TMA121Flagged	    1.
@25		EPAS1TMA121BlockSlidesubNo     1.;
proc sort data=EPAS1TMA12sub1; by TumorID; run; 

data EPAS1TMA12sub2;
infile '/udd/nhogi/Survival/DATA/EPAS1TMA12sub2.dat' lrecl=44 recfm=d;
input
@1		EPAS1TMA122IHCID	    4.
@5		TumorID	    4.
@9		EPAS1TMA122Date		$   17.
@26		EPAS1TMA122ReviewerID	    1.
@27		EPAS1TMA122LookID	    1.
@28		EPAS1TMA122TMA		    1.
@29		EPAS1TMA122BlockSlideNo	    2.
@31		EPAS1TMA122PathDx	    1.
@32		EPAS1TMA122overall    1.
@33		EPAS1TMA122strongest      1.
@34		EPAS1TMA122posperc	    2.
@36		EPAS1TMA122normalysn     1.
@37		EPAS1TMA122normal      1.
@38		EPAS1TMA122noComparison     1.
@39		EPAS1TMA122stromall      1.
@40		EPAS1TMA122NUCoverall   1.
@41		EPAS1TMA122Expr1018	    1.
@42		EPAS1TMA122Flagged	    1.
@43		EPAS1TMA122BlockSlidesubNo     1.;
proc sort data=EPAS1TMA12sub2; by TumorID; run; 

/*PRKAA (AMP-activated protein kinase)*/
data PRKAATMA12sub1;
infile '/udd/nhogi/Survival/DATA/PRKAATMA12sub1.dat' lrecl=24 recfm=d;
input
@1		PRKAATMA121ID	    3.
@4		TumorID	    4.
@8		PRKAATMA121ReviewerID	    1.
@9		PRKAATMA121LookID	    1.
@10		PRKAATMA121BlockSlideNo	    2.
@12		PRKAATMA121PathDx	    1.
@13		PRKAATMA121overall     1.
@14		PRKAATMA121strongest     1.
@15		PRKAATMA121percpos	    2.
@17		PRKAATMA121avgIntensity     1.
@18		PRKAATMA121normalysn     1.
@19		PRKAATMA121normalTMA12     1.
@20		PRKAATMA121noComparison     1.
@21		PRKAATMA121NUCoverall     1.
@22		PRKAATMA121Flagged	    1.
@23		PRKAATMA121BlockSlidesubNo     1.;
proc sort data=PRKAATMA12sub1; by TumorID; run; 

data PRKAATMA12sub2;
infile '/udd/nhogi/Survival/DATA/PRKAATMA12sub2.dat' lrecl=42 recfm=d;
input
@1		PRKAATMA122IHCID	    4.
@5		TumorID	    4.
@9		PRKAATMA122Date		$   18.
@27		PRKAATMA122ReviewerID	    1.
@28		PRKAATMA122LookID	    1.
@29		PRKAATMA122TMA		    1.
@30		PRKAATMA122BlockSlideNo	    2.
@32		PRKAATMA122overall     1.
@33		PRKAATMA122strongest     1.
@34		PRKAATMA122percpos	    2.
@36		PRKAATMA122avgIntensity     1.
@37		PRKAATMA122normalysn     1.
@38		PRKAATMA122normal     1.
@39		PRKAATMA122noComparison     1.
@40		PRKAATMA122Flagged	    1.
@41		PRKAATMA122BlockSlidesubNo     1.;
proc sort data=PRKAATMA12sub2; by TumorID; run;

data prkaa; 
infile '/udd/nhogi/Survival/DATA/PRKAA.dat' lrecl=22 recfm=d;
input
@1		PRKAAID	    3.
@4		TumorID	    4.
@8		PRKAAReviewerID	    1.
@9		prkaaBlockSlideNo	    2.
@11		PRKAAoverall     1.
@12		PRKAAstrongest     1.
@13		PRKAAposperc	    2.
@15		PRKAAavgIntensity     1.
@16		PRKAATMAnormal     1.
@17		PRKAAnormal     1.
@18		PRKAAnoComparison     1.
@19		PRKAANUCoverall     1.
@20		PRKAAFlagged	    1.
@21		PRKAABlockSlidesubNo     1.;
proc sort data=prkaa; by TumorID; run; 

/*MAPK (p-MAPK3/1) */
data MAPKTMA12sub1;
infile '/udd/nhogi/Survival/DATA/MAPKTMA12sub1.dat' lrecl=26 recfm=d;
input
@1		MAPKTMA121IHCID	    3.
@4		TumorID	    4.
@8		MAPKTMA121ReviewerID	    1.
@9		MAPKTMA121LookID	    1.
@10		MAPKTMA121TMA		    1.
@11		MAPKTMA121BlockSlideNo	    2.
@13		MAPKTMA121overallcyto     1.
@14		MAPKTMA121percposcyto     2.
@16		MAPKTMA121overallnuclear     1.
@17		MAPKTMA121strongestnuclear     1.
@18		MAPKTMA121nocomparison     1.
@19		MAPKTMA121percposnuclear     2.
@21		MAPKTMA121normalnuc     1.
@22		MAPKTMA121normalcyto     1.
@23		MAPKTMA121stromal     1.
@24		MAPKTMA121Excludedups	    1.
@25		MAPKTMA121BlockSlideSubNo	    1.;
proc sort data=MAPKTMA12sub1; by TumorID; run; 

data MAPKTMA12sub2;
infile '/udd/nhogi/Survival/DATA/MAPKTMA12sub2.dat' lrecl=27 recfm=d;
input
@1		MAPKTMA122ID	    4.
@5		TumorID	    4.
@9		MAPKTMA122ReviewerID	    1.
@10		MAPKTMA122LookID	    1.
@11		MAPKTMA122BlockSlideNo	    2.
@13		MAPKTMA122overallcyto     1.
@14		MAPKTMA122percposcyto     2.
@16		MAPKTMA122overallnuclear     1.
@17		MAPKTMA122strongestnuclear     1.
@18		MAPKTMA122nocomparison     1.
@19		MAPKTMA122percposnuclear     2.
@21		MAPKTMA122normalnuc     1.
@22		MAPKTMA122normalcyto     1.
@23		MAPKTMA122stromal     1.
@24		MAPKTMA122normalcontrol     1.
@25		MAPKTMA122Flagged	    1.
@26		MAPKTMA122BlockSlideSubNo	    1.;
proc sort data=MAPKTMA12sub2; by TumorID; run; 

data MAPK;
infile '/udd/nhogi/Survival/DATA/MAPK.dat' lrecl=26 recfm=d;
input
@1		MAPKIHCID	    3.
@4		TumorID	    4.
@8		MAPKReviewerID	    1.
@9		MAPKLookID	    1.
@10		MAPKBlockSlideNo	    2.
@12		MAPKPathDx	    1.
@13		MAPKovercyto     1.
@14		MAPKposcytoper     2.
@16		MAPKovernuc     1.
@17		MAPKstrnuc     1.
@18		MAPKnocompar     1.
@19		MAPKposnucper     2.
@21		MAPKnornuc     1.
@22		MAPKnorcyto     1.
@23		MAPKstro     1.
@24		MAPKnormalcontrol     1.
@25		MAPKFlagged	    1.;
proc sort data=MAPK; by TumorID; run; 

/*CTSB*/
data CTSB;
infile '/udd/nhogi/Survival/DATA/CTSBYB.dat' lrecl=21 recfm=d;
input
@1		CTSBIHCID	    4.
@5		TumorID	    4.
@9		CTSBReviewerID	    1.
@10		CTSBLookID	    1.
@11		CTSBTMA		    1.
@12		CTSBoverall     1.
@13		CTSBstrongest     1.
@14		CTSBposper	    2.
@16		CTSBnormal     1.
@17		CTSBnormal     1.
@18		CTSBnoComparison     1.
@19		CTSBstroma     1.
@20		CTSBIHCcytototalper     1.;
proc sort data=CTSB; by TumorID; run; 

data CTSBTMA12sub1;
infile '/udd/nhogi/Survival/DATA/CTSBTMA12sub1.dat' lrecl=21 recfm=d;
input
@1		CTSBTMA121ID	    4.
@5		TumorID	    4.
@9		CTSBTMA121ReviewerID	    1.
@10		CTSBTMA121LookID	    1.
@11		CTSBTMA121BlockSlideNo	    2.
@13		CTSBTMA121BlockSlideSubNo	    1.
@14		CTSBTMA121overall      1.
@15		CTSBTMA121strongest     1.
@16		CTSBTMA121percpos	    2.
@18		CTSBTMA121normal     1.
@19		CTSBTMA121noComparison     1.
@20		CTSBTMA121stroma     1.;
proc sort data=CTSBTMA12sub1; by TumorID; run; 

data CTSBTMA12sub2;
infile '/udd/nhogi/Survival/DATA/CTSBTMA12sub2.dat' lrecl=21 recfm=d;
input
@1		CTSBTMA122ID	    4.
@5		TumorID	    4.
@9		CTSBTMA122ReviewerID	    1.
@10		CTSBTMA122LookID	    1.
@11		CTSBTMA122BlockSlideNo	    2.
@13		CTSBTMA122BlockSlideSubNo	    1.
@14		CTSBTMA122overall     1.
@15		CTSBTMA122strongest     1.
@16		CTSBTMA122percpos	    2.
@18		CTSBTMA122normal     1.
@19		CTSBTMA122noComparison    1.
@20		CTSBTMA122stroma      1.;
proc sort data=CTSBTMA12sub2; by TumorID; run; 

/*MLH1*/
data MLH1IHC;
infile '/udd/nhogi/Survival/DATA/MLH1IHC20100722.dat' lrecl=83 recfm=d;
input
@1		MLH1IHCID	    4.
@5		TumorID	    4.
@9		MLH1Date		$   17.
@26		MLH1ReviewerID	    1.
@27		MLH1LookID	    1.
@28		MLH1TMA		    1.
@29		MLH1BlockSlideNo	$   4.
@33		MLH1PathDx	    1.
@34		MLH1overall     1.
@35		MLH1strongest     1.
@36		MLH1smallLoss     1.
@37		MLH1IHC	$   45.
@82		MLH1Flagged	    1.;
proc sort data=MLH1IHC; by TumorID; run; 

/*MSH2*/
data MSH2IHC;
infile '/udd/nhogi/Survival/DATA/MSH2IHC20100722.dat' lrecl=77 recfm=d;
input
@1		MSH2IHCID	    3.
@4		TumorID	    4.
@8		MSH2Date		$   17.
@25		MSH2ReviewerID	    1.
@26		MSH2LookID	    1.
@27		MSH2TMA		    1.
@28		MSH2BlockSlideNo	$   4.
@32		MSH2overall     1.
@33		MSH2strongest     1.
@34		MSH2percpos	    2.
@36		MSH2smallLoss     1.
@37		MSH2IHC	$   39.
@76		MSH2Flagged	    1.;

proc sort data=MSH2IHC; by TumorID; run; 

/*MGMT*/
data MGMTIHC;
infile '/udd/nhogi/Survival/DATA/mgmt.dat' lrecl=19 recfm=d;
input
@1		TumorID	    4.
@5		MGMTReviewerID	    1.
@6		MGMTLookID	    1.
@7		MGMTTMA		    1.
@8		MGMTPathDx	    1.
@9		MGMToverall     1.
@10		MGMTpartialloss     1.
@11		MGMTnormalcontrol     1.
@12		MGMTnormalworked     1.
@13		MGMTFlagged	    1.
@14		MGMTNewAb	    1.
@15		MGMTnormalcolon     1.
@16		MGMTnlpartialLoss     1.
@17		MGMTnlflag	    1.
@18		MGMTExcludedups	    1.;
proc sort data=MGMTIHC; by TumorID; run; 

/*CD3*/
libname ogino '/udd/nhogi/Survival/DATA';
data cd3; set ogino.meanall2_nuc_cd3; 
nuclei_ca_cd3_raw=nuclei_ca_cd3;
nuclei_wa_cd3_raw=nuclei_wa_cd3;

nuclei_sa_cd3=nuclei_sa_cd3*1000000;
nuclei_ca_cd3=nuclei_ca_cd3*1000000/383829;
logcd3=log(nuclei_ca_cd3);
nuclei_wa_cd3=nuclei_wa_cd3*1000000/383829;
proc sort data=cd3; by TumorID; run; 

/*CD8*/
libname ogino '/udd/nhogi/Survival/DATA';
data cd8; set ogino.meanall2_nuc_cd8; 
nuclei_ca_cd8_raw=nuclei_ca_cd8;
nuclei_wa_cd8_raw=nuclei_wa_cd8;

nuclei_sa_cd8=nuclei_sa_cd8*1000000;
nuclei_ca_cd8=nuclei_ca_cd8*1000000/383829;

if nuclei_ca_cd8>0 then do;
logcd8=log(nuclei_ca_cd8);end;
nuclei_wa_cd8=nuclei_wa_cd8*1000000/383829;
proc sort data=cd8; by TumorID; run;

/*PTPRC (CD45RO)*/
libname ogino '/udd/nhogi/Survival/DATA';
data cd45ro; set ogino.meanall2_nuc_cd45ro; 
nuclei_ca_cd45ro_raw=nuclei_ca_cd45ro;
nuclei_wa_cd45ro_raw=nuclei_wa_cd45ro;

nuclei_sa_cd45=nuclei_sa_cd45ro*1000000;
nuclei_ca_cd45=nuclei_ca_cd45ro*1000000/383829;
logcd45ro=log(nuclei_ca_cd45ro);
nuclei_wa_cd45=nuclei_wa_cd45ro*1000000/383829;
proc sort data=cd45ro; by TumorID; run;

/*FOXP3*/
libname ogino '/udd/nhogi/Survival/DATA';
data foxp3; set ogino.meanall2_nuc_foxp3;
nuclei_ca_foxp3_raw=nuclei_ca_foxp3;
nuclei_wa_foxp3_raw=nuclei_wa_foxp3;

nuclei_sa_foxp3=nuclei_sa_foxp3*1000000;
nuclei_ca_foxp3=nuclei_ca_foxp3*1000000/383829;
logfoxp3=log(nuclei_ca_foxp3);
nuclei_wa_foxp3=nuclei_wa_foxp3*1000000/383829;
proc sort data=foxp3; by TumorID; run;

/*JCVT (JC virus T antigen)*/
data jcvt; infile '/udd/nhogi/Survival/DATA/JCVT.dat' lrecl=34 recfm=d;
input
@1		TumorID	    7.
@8		jcvtTMA		    1.
@9		jcvtBlockSlideNo   $ 7.
@16		jcvtPathDx	    1.
@17		jcvtoverallnuc     1.
@18		jcvtstrongestnuc     1.
@19		jcvtpernuclear_weakstrong     4.
@23		jcvtpernuclear_modstrong    4.
@27		jcvtnuclearNormal     1.
@28		jcvtpercnuclearNormal     4.
@32		jcvtFlagged	    1.
@33		jcvtExcludedups	    1.;
proc sort data=jcvt; by TumorID; run; 

/*DNMT3B*/
data dnmt3b; infile '/udd/nhogi/Survival/DATA/DNMT3Bnew.dat' lrecl=75 recfm=d;
input
@1		TumorID	    4.
@22		dnmt3bReviewerID	    1.
@23		dnmt3bTMA		    1.
@28		dnmt3bPathDx	    1.
@29		dnmt3boverallcyto     1.
@30		dnmt3bstrongestcyto     1.
@31		dnmt3bpercentposcyto	    2.
@33		dnmt3boverallnuclear     2.
@35		dnmt3bstrongestnuclear     1.
@36		dnmt3boverallmemb     1.
@37		dnmt3bposnuclear     2.
@39		dnmt3bstrongestmemb     1.
@40		dnmt3bpercentposmemb	    2.
@42		dnmt3bmembNormal     2.
@44		dnmt3bIHCnormalcontrol     1.
@45		dnmt3bIHCnormalworkedmemb     1.
@73		dnmt3bFlagged	    1.
@74		dnmt3bExcludedups	    1.;
proc sort data=dnmt3b; by TumorID; run;

/*VDR*/
data vdrnew; infile '/udd/nhogi/Survival/DATA/VDRnew.dat' lrecl=39 recfm=d;
input
@1		TumorID	    4.
@5		vdrPathDx	    1.
@6		vdrTMA		    1.
@7		vdrExpr1003	    2.
@9		vdroverall    1.
@10		vdrstrongest	    1.
@11		vdrpercentpos     2.
@13		vdroverallcomparedN     1.
@14		vdrstrongestcomparedN     1.
@15		vdrpercentposcomparedN     1.
@16		vdrNormalTissue     2.
@18		vdrNuclear	    1.
@19		vdrIHC	$   15.
@34		vdrFlagged	    1.
@35		vdrExcludedups	    1.
@36		vdrBlockSlideNo	    2.
@38		vdrReviewerID	    1.;
proc sort data=vdrnew; by TumorID; run;

data vdrtma121; infile '/udd/nhogi/Survival/DATA/VDRTMA12sub1.dat' lrecl=25 recfm=d;
input
@1		TumorID	    4.
@5		vdrtma121PathDx	    1.
@6		vdrtma121		    1.
@7		vdrtma121Expr1003	    2.
@9		vdrtma121overall	    1.
@10		vdrtma121strong	    1.
@11		vdrtma121percentpos     2.
@13		vdrtma121overallcomparedN     1.
@14		vdrtma121strongestcomparedN     1.
@15		vdrtma121percentposcomparedN    1.
@16		vdrtma121NormalTissue     1.
@17		vdrtma121Nuclear	    1.
@18		vdrtma121Flagged	    1.
@19		vdrtma121Excludedups	    1.
@20		vdrtma121Expr1015	    1.
@21		vdrtma121BlockSlideNo	    2.
@23		vdrtma121ReviewerID	    1.
@24		vdrtma121BlockSlideSubNo	    1.;
proc sort data=vdrtma121; by TumorID; run;

data vdrtma122; infile '/udd/nhogi/Survival/DATA/VDRTMA12sub2.dat' lrecl=25 recfm=d;
input
@1		TumorID	    4.
@5		vdrtma122PathDx	    1.
@6		vdrtma122	    1.
@7		vdrtma122Expr1003	    2.
@9		vdrtma122overall	    1.
@10		vdrtma122strongest    1.
@11		vdrtma122percentpos     2.
@13		vdrtma122overallcomparedN     1.
@14		vdrtma122strongestcomparedN     1.
@15		vdrtma122percentposcomparedN     1.
@16		vdrtma122NormalTissue     1.
@17		vdrtma122Nuclear	    1.
@18		vdrtma122Flagged	    1.
@19		vdrtma122Excludedups	    1.
@20		vdrtma122Expr1015	    1.
@21		vdrtma122BlockSlideNo	    2.
@23		vdrtma122ReviewerID	    1.
@24		vdrtma122BlockSlideSubNo	    1.;
proc sort data=vdrtma122; by TumorID; run;


data ctnnb1TMnon12; infile '/udd/nhogi/Survival/DATA/bcateninTMnon12.dat' lrecl=72 recfm=d;

input
@1		intIHCbcateID	    4.
@5		TumorID	    4.
@9		ctnnb1TMnon12dtmDate		$   17.
@26		ctnnb1TMnon12ReviewerID	    1.
@27		ctnnb1TMnon12LookID	    1.
@28		ctnnb1TMnon12TMA		    1.
@29		ctnnb1BlockSlideNo	    2.
@31		bcateoverallcytoTMnon12     1.
@32		bcatestrongestcytoTMnon12     1.
@33		bcatepercposcytoTMnon12     3.
@36		bcateoverallnucTMnon12     1.
@37		bcatestrongestnucTMnon12     1.
@38		bcatepercposnucTMnon12     3.
@41		bcateoverallmembTMnon12     1.
@42		bcatestronmembTMnon12     1.
@43		bcatepercposmembTMnon12     3.
@46		bcatenorcontTMnon12    1.
@47		bcatenorworkedmembTMnon12     1.
@48		strIHCbcate	$   22.
@70		FlaggedTMnon12	    1.
@71		ExcludedupsTMnon12	    1.;

proc sort data=ctnnb1TMnon12; by TumorID; run; 


data ctnnb1TM121; infile '/udd/nhogi/Survival/DATA/bcateninTM121.dat' lrecl=56 recfm=d;

input
@1		intIHCbcateID	    4.
@5		TumorID	    4.
@9		ctnnb1TM121dtmDate		$   17.
@26		ctnnb1TM121ReviewerID	    1.
@27		ctnnb1TM121LookID	    1.
@28		ctnnb1TM121TMA		    1.
@29		ctnnb1BlockSlideNo	    2.
@31		bcateoverallcytoTM121     1.
@32		bcatestrongestcytoTM121     1.
@33		bcatepercposcytoTM121     2.
@35		bcateoverallnuclearTM121     1.
@36		bcatestrongestnuclearTM121     1.
@37		bcatepercposnuclearTM121     2.
@39		bcateoverallmembTM121     1.
@40		bcatestrongestmembTM121     1.
@41		bcatenormalcontrolTM121     1.
@42		bcatenormalworkedmembTM121    1.
@43		strIHCbcate	$   10.
@53		FlaggedTM121	    1.
@54		ExcludedupsTM121	    1.
@55		BlockSubNoTM121	    1.;

proc sort data=ctnnb1TM121; by TumorID; run; 


data ctnnb1TM122; infile '/udd/nhogi/Survival/DATA/bcateninTM122.dat' lrecl=66 recfm=d;

input
@1		intIHCbcateID	    4.
@5		TumorID	    4.
@9		ctnnb1TM122dtmDate		$   17.
@26		ctnnb1TM122ReviewerID	    1.
@27		ctnnb1TM122LookID	    1.
@28		ctnnb1TM122TMA		    1.
@29		ctnnb1BlockSlideNo	    2.
@31		bcateoverallcytoTM122    1.
@32		bcatestrongestcytoTM122     1.
@33		bcatepercposcytoTM122     2.
@35		bcateoverallnuclearTM122     1.
@36		bcatestrongestnuclearTM122     1.
@37		bcatepercposnuclearTM122     2.
@39		bcateoverallmembTM122     1.
@40		bcatestrongestmembTM122     1.
@41		bcatenormalcontrolTM122     1.
@42		bcatenormalworkedmembTM122     1.
@43		strIHCbcate	$   20.
@63		FlaggedTM122	    1.
@64		ExcludedupsTM122	    1.
@65		BlockSubNoTM122	    1.;

proc sort data=ctnnb1TM122; by TumorID; run; 


data ctnnb1TMfullsec;  infile '/udd/nhogi/Survival/DATA/bcateninfullsecTM.dat' lrecl=81 recfm=d;

input
@1		intIHCbcateID	    4.
@5		TumorID	    4.
@9		ctnnb1TMfullsecdtmDate		$   17.
@26		ctnnb1TMfullsecReviewerID	    1.
@27		ctnnb1TMfullsecLookID	    1.
@28		ctnnb1TMfullsecTMA		    1.
@29		ctnnb1TMfullsecBlockSlideNo	$   4.
@33		bcateoverallcytofullsec     1.
@34		bcatestrongestcytofullsec     1.
@35		bcateperposcytofullsec     2.
@37		bcateoverallnuclearfullsec     1.
@38		bcatestrongestnuclearfullsec     1.
@39		bcateperposnuclearfullsec     2.
@41		bcateoverallmembfullsec     1.
@42		bcatestrongestmembfullsec     1.
@43		bcatenormalcontrolfullsec     1.
@44		bcatenormalworkedmembfullsec     1.
@45		bcate	$   33.
@78		Flaggedfullsec	    1.
@79		Excludedupsfullsec	    1.
@80		BlockSubNofullsec	    1.;

proc sort data=ctnnb1TMfullsec; by TumorID; run; 

data ctnnb1so; infile '/udd/nhogi/Survival/DATA/ctnnb1so.dat' lrecl=15 recfm=d;

input
@1		ctnnb1soIHCbcateID	    3.
@4		TumorID	    4.
@8		ctnnb1soReviewerID	    1.
@9		ctnnb1soTMA		    1.
@10		ctnnb1sooverallcyto     1.
@11		ctnnb1sooverallnuclear     1.
@12		ctnnb1sooverallmemb     1.
@13		ctnnb1soFlagged	    1.
@14		ctnnb1soExcludedups	    1.
;
proc sort data=ctnnb1so; by TumorID; run; 

data ctnnb1tma1314; infile '/udd/nhogi/Survival/DATA/Cleanctnnb1TMA131420130601.dat' lrecl=27 recfm=d;
input
@1		TumorID		    4.
@5		ctnnb1TMnon1314ReviewerID     1.
@6		ctnnb1TMnon1314LookID     1.
@7		ctnnb1TMnon1314TMA $   4.
@11		ctnnb1BlockSlideNo     3.
@14		bcateocytoTM1314     1.
@15		bcateonucTM1314     1.
@16		bcateomembTM1314     1.
@17		FlaggedTMnon1314 $   5.
@22		ExcludedupsTMnon1314 $   5.
;

proc sort data=ctnnb1tma1314; by TumorID; run; 


data irs1; infile '/udd/nhogi/Survival/DATA/irs1new.dat' lrecl=16 recfm=d;
input
@1		TumorID	    4.
@5		IRS1ReviewerID	    1.
@6		IRS1LookID	    1.
@7		IRS1TMA		    1.
@8		IRS1BlockSlideNo	    2.
@10		IRS1cyto_overall     1.
@11		IRS1nuc_overall	    1.
@12		IRS1nuc_perc	    2.
@14		IRS1Flagged	    1.
@15		IRS1BlockSubNo	    1.
;
proc sort data=irs1; by TumorID; run; 


data yap1; infile '/udd/nhogi/Survival/DATA/YAP.dat' lrecl=17 recfm=d;
input
@1		TumorID	    4.
@5		YAP1ReviewerID	    1.
@6		YAP1LookID	    1.
@7		YAP1TMA		    1.
@8		YAP1BlockSlideNo	    2.
@10		YAP1BlockSubNo	    1.
@11		YAP1cytooverall	    1.
@12		YAP1cytostrongest     1.
@13		YAP1nuclearoverall     1.
@14		YAP1nuclearstrongest     1.
@15		YAP1Flagged	    1.
@16		YAP1Excludedups	    1.
;
proc sort data=yap1; by TumorID; run; 

data igf2bp3; infile '/udd/nhogi/Survival/DATA/igf2bp3new.dat' lrecl=18 recfm=d;
input
@1		IHC_IGF2BP3_ID	    4.
@5		TumorID	    4.
@9		IGF2BP3ReviewerID     1.
@10		IGF2BP3LookID	    1.
@11		IGF2BP3TMA		    1.
@12		IGF2BP3BlockSlideNo	    2.
@14		IGF2BP3overall	    1.
@15		IGF2BP3normal	    1.
@16		IGF2BP3Flagged	    1.
@17		IGF2BP3BlockSubNo	    1.
;
proc sort data=igf2bp3; by TumorID; run; 

data irs2ale; infile '/udd/nhogi/Survival/DATA/IRS2ale.dat' lrecl=9 recfm=d;
input
@1		irs2aleID		    3.
@4		TumorID	    4.
@8		irs2ale		    1.
;
proc sort data=irs2ale; by TumorID; run; 


data irs2; infile '/udd/nhogi/Survival/DATA/irs2.dat' lrecl=15 recfm=d;
input
@1		TumorID	    4.
@5		IRS2ReviewerID	    1.
@6		IRS2LookID	    1.
@7		IRS2TMA		    1.
@8		IRS2BlockSlideNo	    2.
@10		IRS2BlockSubNo	    1.
@11		IRS2cytooverall	    1.
@12		IRS2nuclearoverall     1.
@13		IRS2Flagged	    1.
@14		IRS2Excludedups	    1.
;
proc sort data=irs2; by TumorID; run; 


data mageanon12; infile '/udd/nhogi/Survival/DATA/mageanon12new.dat' lrecl=48 recfm=d;

input
@1		IHC_MAGEA_ID	    4.
@5		TumorID	    4.
@9		MAGEADate		$   17.
@26		MAGEAReviewerID	    1.
@27		MAGEALookID	    1.
@28		MAGEATMA		    1.
@29		MAGEABlockSlideNo	    2.
@31		MAGEAoverall	    1.
@32		MAGEAcomment	$   15.
@47		MAGEAFlagged	    1.
;
proc sort data=mageanon12; by TumorID; run;


data mageatma121; infile '/udd/nhogi/Survival/DATA/mageatma121.dat' lrecl=45 recfm=d;
input
@1		IHC_MAGEA_ID	    3.
@4		TumorID	    4.
@8		MAGEA121Date		$   17.
@25		MAGEA121ReviewerID	    1.
@26		MAGEA121LookID	    1.
@27		MAGEA121TMA		    1.
@28		MAGEA121BlockSlideNo	    2.
@30		MAGEA121overall	    1.
@31		MAGEA121comment	$   12.
@43		MAGEA121Flagged	    1.
@44		MAGEA121BlockSubNo	    1.
;
proc sort data=mageatma121; by TumorID; run;


data mageatma122; infile '/udd/nhogi/Survival/DATA/mageatma122.dat' lrecl=47 recfm=d;
input
@1		IHC_MAGEA_ID	    4.
@5		TumorID	    4.
@9		MAGEA122Date		$   17.
@26		MAGEA122ReviewerID	    1.
@27		MAGEA122LookID	    1.
@28		MAGEA122TMA		    1.
@29		MAGEA122BlockSlideNo	    2.
@31		MAGEA122overall	    1.
@32		MAGEA122comment	$   13.
@45		MAGEA122Flagged	    1.
@46		MAGEA122BlockSubNo	    1.
;
proc sort data=mageatma122; by TumorID; run;


data cmet; infile '/udd/nhogi/Survival/DATA/MET.dat' lrecl=18 recfm=d;
input
@1		IHCMET_ID	    3.
@4		TumorID	    4.
@8		MET_ReviewerID	    1.
@9		MET_LookID	    1.
@10		ysnTMA		    1.
@11		strBlockSlideNo	    2.
@13		intBlockSubNo	    1.
@14		MET_cytooverall	    1.
@15		MET_cytostrongest     1.
@16		MET_Flagged	    1.
@17		MET_Excludedups	    1.
;
proc sort data=cmet; by TumorID; run;


data hpgd; infile '/udd/nhogi/Survival/DATA/hpgd.dat' lrecl=18 recfm=d;
input
@1		IHCHPGD_ID	    3.
@4		TumorID	    4.
@8		HPGD_ReviewerID	    1.
@9		HPGD_LookID	    1.
@10		HPGDTMA		    1.
@11		HPGDBlockSlideNo	    2.
@13		HPGDBlockSubNo	    1.
@14		HPGD_cytooverall     1.
@15		HPGD_cytostrongest     1.
@16		HPGD_Flagged	    1.
@17		HPGD_Excludedups     1.
;
proc sort data=hpgd; by TumorID; run;


data vdrnovo; infile '/udd/nhogi/Survival/DATA/vdrnovo4.dat' lrecl=21 recfm=d;
input
@1		IHCVDRnovo_ID	    3.
@4		TumorID	    4.
@8		VDRnovo_ReviewerID     1.
@9		VDRnovo_LookID	    1.
@10		VDRnovoysnTMA		    1.
@11		VDRnovoBlockSlideNo	    2.
@13		VDRnovo_nuclearoverall     1.
@14		VDRnovo_nuclearstrongest     1.
@15		VDRnovopercposiive     3.
@18		VDRnovo_normal	    1.
@19		VDRnovo_Flagged	    1.
@20		VDRnovo_Excludedups     1.
;
proc sort data=vdrnovo; by TumorID; run;



data cd274non12;infile '/udd/nhogi/Survival/DATA/CD274nonTMA.dat' lrecl=18 recfm=d;

input
@1		IHCCD274ID	    4.
@5		TumorID	    4.
@9		CD274ReviewerID	    1.
@10		CD274LookID	    1.
@11		CD274TMA		    1.
@12		CD274BlockSlideNo	    2.
@14		CD274overall	    1.
@15		CD274strongest	    1.
@16		CD274Flagged	    1.
@17		CD274Excludedups     1.
;
proc sort data=cd274non12; by TumorID; run;


data cd274tma121;infile '/udd/nhogi/Survival/DATA/cd274tma121.dat' lrecl=51 recfm=d;

input
@1		IHCCD274ID	    3.
@4		TumorID	    4.
@8		dtmDatetma121		$   17.
@25		CD274ReviewerIDtma121	    1.
@26		CD274LookIDtma121	    1.
@27		CD274TMAtma121		    1.
@28		CD274strBlockSlideNo     2.
@30		CD274overalltma121	    1.
@31		CD274strongesttma121	    1.
@32		CD274compareNtma121	    1.
@33		CD274stromatma121	    1.
@34		CD274normaltma121	    1.
@35		CD274commenttma121	$   9.
@44		CD274Flaggedtma121	    1.
@45		CD274Excludedups     1.
@46		intBlockSubNo	    1.
@47		CD274percmodtma121	    2.
@49		CD274percweaktma121	    2.
;
proc sort data=cd274tma121; by TumorID; run;

data cd274tma122;infile '/udd/nhogi/Survival/DATA/cd274tma121.dat' lrecl=51 recfm=d;
input
@1		IHCCD274ID	    3.
@4		TumorID	    4.
@8		dtmDatetma122		$   17.
@25		CD274ReviewerIDtma122	    1.
@26		CD274LookIDtma122	    1.
@27		CD274TMAtma122		    1.
@28		CD274strBlockSlideNo     2.
@30		CD274overalltma122	    1.
@31		CD274strongesttma122	    1.
@32		CD274compareNtma122	    1.
@33		CD274stromatma122	    1.
@34		CD274normaltma122	    1.
@35		CD274commenttma122	$   9.
@44		CD274Flaggedtma122	    1.
@45		CD274Excludedupstma122     1.
@46		intBlockSubNo	    1.
@47		CD274percmodtma122	    2.
@49		CD274percweaktma122	    2.
;
proc sort data=cd274tma122; by TumorID; run;


/*CD274 (PD-L1) by Masugi Y (Gut 2016)*/
data CD274;infile '/udd/nhogi/Survival/DATA/CD274.dat' lrecl=8 recfm=d;
input
@1		TumorID		    4.
@5		CD274cy		    1.
@6		CD274me		    1.
@7		CD274st		    1.
;
proc sort data=CD274 nodupkey; by TumorID; run;


/*PDCD1LG2 (PD-L2)*/
data PDCD1LG2;infile '/udd/nhogi/Survival/DATA/PDCD1LG2.dat' lrecl=13 recfm=d;
input
@1		TumorID		    4.
@5		PDCD1LG2cy	    1.
@6		PDCD1LG2cystrongest     1.
@7		PDCD1LG2me	    1.
@8		PDCD1LG2cy_per	    1.
@9		PDCD1LG2_perpositive     3.
@12		PDCD1LG2_normal	    1.
;
proc sort data=PDCD1LG2 ; by TumorID; run;


/*PDCD1LG2 (PD-L2) additional data (stroma and membrane expression)*/
data PDCD1LG2add;infile '/udd/nhogi/Survival/DATA/PDCD1LG2add.dat' lrecl=7 recfm=d;
input
@1		TumorID		    4.
@5		PDCD1LG2me_rev	    1.
@6		PDCD1LG2st	    1.
;
proc sort data=PDCD1LG2add ; by TumorID; run;


/*PDCD1 (PD-1) (Gut 2016)*/
data PDCD1;infile '/udd/nhogi/Survival/DATA/PDCD1.dat' lrecl=13 recfm=d;
input
@1		TumorID		    4.
@5		PDCD1cy_TIL	    1.
@6		PDCD1me_TIL	    1.
@7		PDCD1cy_TumorStroma     1.
@8		PDCD1me_TumorStroma     1.
@9		PDCD1cy_whole	    1.
@10		PDCD1_me_whole	    1.
@11		PDCD1cy_Normal	    1.
@12		PDCD1_me_Normal	    1.
;
proc sort data=PDCD1 ; by TumorID; run;



data ctnnb1normal;infile '/udd/nhogi/Survival/DATA/CTNNB1normal.dat' lrecl=17 recfm=d;
input
@1		ctnnb1normalID	    4.
@5		TumorID	    4.
@9		ctnnb1normalReviewerID	    1.
@10		ctnnb1normalTMA		    1.
@11		ctnnb1normalBlockSlideNo	    2.
@13		ctnnb1normalBlockSubNo	    1.
@14		CTNNB1normalnuc	    1.
@15		CTNNB1normalcyto     1.
@16		CTNNB1normalmemb     1.
;
proc sort data=ctnnb1normal; by TumorID; run;


data hgf; infile '/udd/nhogi/Survival/DATA/HGF.dat' lrecl=21 recfm=d;
input
@1		IHC_HGF_ID	    3.
@4		TumorID	    4.
@8		HGF_ReviewerID	    1.
@9		HGF_LookID	    1.
@10		HGF_TMA		    1.
@11		HGF_BlockSlideNo	    2.
@13		HGF_BlockSubNo	    1.
@14		HGF_cytooverall	    1.
@15		HGF_cytostrongest     1.
@16		HGF_Flagged	    1.
@17		HGF_Excludedups	    1.
@18		HGF_stromaperc	    2.
@20		HGF_stromaintense     1.
;
proc sort data=hgf; by TumorID; run;

data smo; infile '/udd/nhogi/Survival/DATA/smo.dat' lrecl=31 recfm=d;
input
@1		IHC_SMO_ID	    3.
@4		TumorID	    4.
@8		SMODate		$   17.
@25		SMOReviewerID	    1.
@26		SMOLookID	    1.
@27		SMOTMA		    1.
@28		SMOBlockSlideNo	    2.
@30		SMOcytooverall	    1.
;
proc sort data=smo; by TumorID; run;

data smotm; infile '/udd/nhogi/Survival/DATA/smotm.dat' lrecl=13 recfm=d;
input
@1		IHC_SMOTM_ID	    4.
@5	    TumorID	    4.
@9		SMOTMReviewerID	    1.
@10		SMOTMBlockSlideNo	    2.
@12		SMOTMcytooverall	    1.
;
proc sort data=smotm; by TumorID; run;

/*Fusobacterium */

data fuso; infile '/udd/nhogi/Survival/DATA/fusobacterium20140703.dat' lrecl=215 recfm=d;
input
@1         TumorID             4.
@5         T_PGT_Ct       11.
@16        N_PGT_Ct       11.
@27        T_fusobacterium_spp_Ct     11.
@38        T_fusobacterium_spp_dCt     12.
@50        fusospp             11.
@61        N_fusobacterium_spp_Ct     11.
@72        N_fusobacterium_spp_dCt     12.
@84        N_fusospp      11.
@95        T_fusobacterium_nuc_Ct     11.
@106       T_fusobacterium_nuc_dCt     12.
@118       fusonuc             11.
@129       N_fusobacterium_nuc_Ct     11.
@140       N_fusobacterium_nuc_dCt     12.
@152       N_fusonuc      11.
@163       T_fusobacterium_spp_pathseq     13.
@176       N_fusobacterium_spp_pathseq     12.
@188       T_fusobacterium_nuc_pathseq     13.
@201       N_fusobacterium_nuc_pathseq     11.
@212       low80ng_T      1.
@213       low80ng_N      1.
@214       SameBlock      1.
;
/*fusospp, fusonuc, N_fusospp, N_fusonuc = 2^(-delta Ct) */
proc sort data=fuso nodupkey; by TumorID; run;
 
data mir21155; infile '/udd/nhogi/Survival/DATA/mir21_155_20140813.dat' lrecl=50 recfm=d;
input
@1                  TumorID                         4.
@5                  mir21t                 13.
@18                mir155t                           10.
@28                mir21n                            12.
@40                mir155n                         10.
;
proc sort data=mir21155; by TumorID; run;
/*
mir21t: MIR21 expression level in tumor tissue (the average Ct value of MIR21・- the average Ct value of RNU6-2・
mir155t: MIR155 expression level in tumor tissue (the average Ct value of MIR155・- the average Ct value of RNU6-2・
mir21n (about 60 cases): MIR21 expression level in non-tumor colonic mucosa  
mir155n (about 60 cases): MIR155 expression level in non-tumor colonic mucosa
*/


/*NFKB1 (NFKB family protein)*/
data NFKB1; infile '/udd/nhogi/Survival/DATA/NFKB1.dat' lrecl=18 recfm=d;
input
@1		TumorID		    4.
@5		NFKB1_nuc_overall     1.
@6		NFKB1_nuc_weak_perc     3.
@9		NFKB1_nuc_strong_perc     3.
@12		NFKB1_cyt_overall     1.
@13		NFKB1_normal_nuc_overall     1.
@14		NFKB1_normal_nuc_weak_perc     2.
@16		NFKB1_normal_nuc_strong_perc     2.
;
proc sort data=NFKB1; by TumorID; run;


/*RELA (NFKB family protein)*/
data RELA; infile '/udd/nhogi/Survival/DATA/RELA.dat' lrecl=12 recfm=d;
input
@1		TumorID		    4.
@5		RELA_nuc_overall     1.
@6		RELA_nuc_perpositive     2.
@8		RELA_cyt_overall     1.
@9		RELA_normal_nuc_overall     1.
@10		RELA_normal_nuc_perpositive     2.
;
proc sort data=RELA; by TumorID; run;

/*CASR (calcium sensing receptor; modified on 2016719)*/
data CASR;infile '/udd/nhogi/Survival/DATA/CASR_20160719.dat' lrecl=9 recfm=d;
input
@1		TumorID		    4.
@5		CASR_overall_absolute     1.
@6		CASR_me_overall	    1.
@7		CASR_immune	    1.
@8		CASR_normal	    1.
;
proc sort data=CASR ; by TumorID; run;

/*neoantigen*/
data neoag; infile '/udd/nhogi/Survival/DATA/neoag_20180216.dat' lrecl=43 recfm=d;
input
@7		TumorID		    4.
@12		neoag	    5.
@17		Mutation_rate_SNV_perMb     13.
@30		Mutation_rate_All_per_Mb     13.
;
proc sort data=neoag; by TumorID; run;

/*ColonEpiExome_metrics*/
data HS_LIBRARY_SIZE;infile '/udd/nhogi/Survival/DATA/ColonEpiExome_metrics.dat' lrecl=19 recfm=d;
input
@1		TumorID		    6.
@7		HS_LIBRARY_SIZE	    12.
;
proc sort data=HS_LIBRARY_SIZE ; by TumorID; run;

/*Bifidobacterium genus*/
data Bifido;infile '/udd/nhogi/Survival/DATA/bifido_20160223.dat' lrecl=117 recfm=d;
input
@1		TumorID		    4.
@5		T_N		$   5.
@10		sample_code	$   6.
@16		Ct1_16s		$   12.
@28		Ct2_16s		    11.
@39		CtMean_16s	    11.
@50		Ct1_Bifido	    11.
@61		Ct2_Bifido	    11.
@72		CtMean_Bifido	    11.
@83		deltaCt		    12.
@95		bifido		    11.
@106		loge_bifido	    11.
;
proc sort data=Bifido ; by TumorID; run;

/*LC3AB*/
data LC3AB; infile '/udd/nhogi/Survival/DATA/CleanLC3AB150417.dat' lrecl=13 recfm=d;
input
@1		TumorID		    4.
@5		strBlockSlideNo	    3.
@8		LC3AB_nuclearoverall     1.
@9		LC3AB_cytooverall     1.
@10		LC3AB_cytostrongest     1.
@11		LC3AB_cytopercposiive     2.
;
proc sort data=LC3AB; by TumorID; run;

/*beclin*/
data beclin; infile '/udd/nhogi/Survival/DATA/beclin.dat' lrecl=8 recfm=d;
input
@1		TumorID		    4.
@5		TMA		    2.
@7		beclin		    1.
;
proc sort data=beclin; by TumorID; run;

/*p62*/
data p62; infile '/udd/nhogi/Survival/DATA/CleanResultsIHCp6220150509.dat' lrecl=14 recfm=d;
input
@1		TumorID		    4.
@5		strBlockSlideNo	    3.
@8		p62_cytooverall	    1.
@9		p62_cytostrongest     1.
@10		p62_cytoperpositive     3.
@13		p62_cytonormal	    1.
;
proc sort data=p62; by TumorID; run;

/*t cell IF*/
data tcellif; infile '/udd/nhogi/Survival/DATA/tcell_image_analysis_tumor_20191210_TMA_N.dat' lrecl=2256 recfm=d;
input
@1		TumorID		    4.
@5		count_tumor_cd3p     14.
@19		count_tumor_cd3pcd4p     13.
@32		count_tumor_cd3pcd8p     14.
@46		count_tumor_cd3dn     14.
@60		count_tumor_cd45rop     14.
@74		count_tumor_cd3pcd4pfoxp3p     13.
@87		count_tumor_cd3pcd4pfoxp3n     13.
@100		count_tumor_cd3pcd4pcd45rop     13.
@113		count_tumor_cd3pcd4pcd45ron     13.
@126		count_tumor_cd3pcd8pcd45rop     13.
@139		count_tumor_cd3pcd8pcd45ron     14.
@153		count_tumor_cd3ncd45rop     14.
@167		count_tumor_cd3pcd45rop     13.
@180		count_stroma_cd3p     14.
@194		count_stroma_cd3pcd4p     14.
@208		count_stroma_cd3pcd8p     13.
@221		count_stroma_cd3dn     13.
@234		count_stroma_cd45rop     14.
@248		count_stroma_cd3pcd4pfoxp3p     13.
@261		count_stroma_cd3pcd4pfoxp3n     13.
@274		count_stroma_cd3pcd4pcd45rop     13.
@287		count_stroma_cd3pcd4pcd45ron     13.
@300		count_stroma_cd3pcd8pcd45rop     13.
@313		count_stroma_cd3pcd8pcd45ron     13.
@326		count_stroma_cd3ncd45rop     14.
@340		count_stroma_cd3pcd45rop     14.
@354		count_all_cd3p	    14.
@368		count_all_cd3pcd4p     14.
@382		count_all_cd3pcd8p     14.
@396		count_all_cd3dn	    14.
@410		count_all_cd45rop     14.
@424		count_all_cd3pcd4pfoxp3p     13.
@437		count_all_cd3pcd4pfoxp3n     14.
@451		count_all_cd3pcd4pcd45rop     13.
@464		count_all_cd3pcd4pcd45ron     13.
@477		count_all_cd3pcd8pcd45rop     13.
@490		count_all_cd3pcd8pcd45ron     14.
@504		count_all_cd3ncd45rop     14.
@518		count_all_cd3pcd45rop     14.
@532		density_tumor_cd3p     14.
@546		density_tumor_cd3pcd4p     14.
@560		density_tumor_cd3pcd8p     14.
@574		density_tumor_cd3dn     14.
@588		density_tumor_cd45rop     14.
@602		density_tumor_cd3pcd4pfoxp3p     14.
@616		density_tumor_cd3pcd4pfoxp3n     14.
@630		density_tumor_cd3pcd4pcd45rop     14.
@644		density_tumor_cd3pcd4pcd45ron     14.
@658		density_tumor_cd3pcd8pcd45rop     14.
@672		density_tumor_cd3pcd8pcd45ron     14.
@686		density_tumor_cd3ncd45rop     14.
@700		density_tumor_cd3pcd45rop     14.
@714		density_stroma_cd3p     14.
@728		density_stroma_cd3pcd4p     14.
@742		density_stroma_cd3pcd8p     14.
@756		density_stroma_cd3dn     14.
@770		density_stroma_cd45rop     15.
@785		density_stroma_cd3pcd4pfoxp3p     14.
@799		density_stroma_cd3pcd4pfoxp3n     14.
@813		density_stroma_cd3pcd4pcd45rop     14.
@827		density_stroma_cd3pcd4pcd45ron     14.
@841		density_stroma_cd3pcd8pcd45rop     14.
@855		density_stroma_cd3pcd8pcd45ron     14.
@869		density_stroma_cd3ncd45rop     15.
@884		density_stroma_cd3pcd45rop     14.
@898		density_all_cd3p     14.
@912		density_all_cd3pcd4p     14.
@926		density_all_cd3pcd8p     14.
@940		density_all_cd3dn     14.
@954		density_all_cd45rop     14.
@968		density_all_cd3pcd4pfoxp3p     14.
@982		density_all_cd3pcd4pfoxp3n     14.
@996		density_all_cd3pcd4pcd45rop     14.
@1010		density_all_cd3pcd4pcd45ron     14.
@1024		density_all_cd3pcd8pcd45rop     14.
@1038		density_all_cd3pcd8pcd45ron     14.
@1052		density_all_cd3ncd45rop     14.
@1066		density_all_cd3pcd45rop     14.
@1080		dis_cd3p_mclosest     13.
@1093		dis_cd3p_sdclosest     13.
@1106		dis_cd3p_mmult	    13.
@1119		dis_cd3p_sdmult	    13.
@1132		dis_cd3p_medge	    13.
@1145		dis_cd3p_sdedge	    12.
@1157		dis_cd3pcd4p_mclosest     13.
@1170		dis_cd3pcd4p_sdclosest     13.
@1183		dis_cd3pcd4p_mmult     13.
@1196		dis_cd3pcd4p_sdmult     13.
@1209		dis_cd3pcd4p_medge     13.
@1222		dis_cd3pcd4p_sdedge     12.
@1234		dis_cd3pcd8p_mclosest     13.
@1247		dis_cd3pcd8p_sdclosest     13.
@1260		dis_cd3pcd8p_mmult     13.
@1273		dis_cd3pcd8p_sdmult     13.
@1286		dis_cd3pcd8p_medge     13.
@1299		dis_cd3pcd8p_sdedge     12.
@1311		dis_cd3dn_mclosest     13.
@1324		dis_cd3dn_sdclosest     14.
@1338		dis_cd3dn_mmult	    13.
@1351		dis_cd3dn_sdmult     13.
@1364		dis_cd3dn_medge	    13.
@1377		dis_cd3dn_sdedge     13.
@1390		dis_cd3pcd4pfoxp3p_mclosest     13.
@1403		dis_cd3pcd4pfoxp3p_sdclosest     13.
@1416		dis_cd3pcd4pfoxp3p_mmult     13.
@1429		dis_cd3pcd4pfoxp3p_sdmult     13.
@1442		dis_cd3pcd4pfoxp3p_medge     13.
@1455		dis_cd3pcd4pfoxp3p_sdedge     13.
@1468		dis_cd3pcd4pfoxp3n_mclosest     13.
@1481		dis_cd3pcd4pfoxp3n_sdclosest     13.
@1494		dis_cd3pcd4pfoxp3n_mmult     13.
@1507		dis_cd3pcd4pfoxp3n_sdmult     13.
@1520		dis_cd3pcd4pfoxp3n_medge     13.
@1533		dis_cd3pcd4pfoxp3n_sdedge     12.
@1545		dis_cd3pcd4pcd45rop_mclosest     13.
@1558		dis_cd3pcd4pcd45rop_sdclosest     13.
@1571		dis_cd3pcd4pcd45rop_mmult     13.
@1584		dis_cd3pcd4pcd45rop_sdmult     13.
@1597		dis_cd3pcd4pcd45rop_medge     13.
@1610		dis_cd3pcd4pcd45rop_sdedge     12.
@1622		dis_cd3pcd4pcd45ron_mclosest     13.
@1635		dis_cd3pcd4pcd45ron_sdclosest     14.
@1649		dis_cd3pcd4pcd45ron_mmult     13.
@1662		dis_cd3pcd4pcd45ron_sdmult     13.
@1675		dis_cd3pcd4pcd45ron_medge     13.
@1688		dis_cd3pcd4pcd45ron_sdedge     13.
@1701		dis_cd3pcd8pcd45rop_mclosest     13.
@1714		dis_cd3pcd8pcd45rop_sdclosest     13.
@1727		dis_cd3pcd8pcd45rop_mmult     13.
@1740		dis_cd3pcd8pcd45rop_sdmult     13.
@1753		dis_cd3pcd8pcd45rop_medge     13.
@1766		dis_cd3pcd8pcd45rop_sdedge     12.
@1778		dis_cd3pcd8pcd45ron_mclosest     13.
@1791		dis_cd3pcd8pcd45ron_sdclosest     13.
@1804		dis_cd3pcd8pcd45ron_mmult     13.
@1817		dis_cd3pcd8pcd45ron_sdmult     13.
@1830		dis_cd3pcd8pcd45ron_medge     13.
@1843		dis_cd3pcd8pcd45ron_sdedge     13.
@1856		dis_cd3ncd45rop_mclosest     13.
@1869		dis_cd3ncd45rop_sdclosest     14.
@1883		dis_cd3ncd45rop_mmult     13.
@1896		dis_cd3ncd45rop_sdmult     13.
@1909		dis_cd3ncd45rop_medge     13.
@1922		dis_cd3ncd45rop_sdedge     12.
@1934		count_tumor_foxp3p     13.
@1947		count_stroma_foxp3p     13.
@1960		count_all_foxp3p     13.
@1973		density_tumor_foxp3p     14.
@1987		density_stroma_foxp3p     14.
@2001		density_all_foxp3p     14.
@2015		dis_foxp3p_mclosest     13.
@2028		dis_foxp3p_sdclosest     13.
@2041		dis_foxp3p_mmult     13.
@2054		dis_foxp3p_sdmult     13.
@2067		dis_foxp3p_medge     13.
@2080		dis_foxp3p_sdedge     13.
@2093		count_tumor_cd8p     14.
@2107		count_stroma_cd8p     13.
@2120		count_all_cd8p	    14.
@2134		density_tumor_cd8p     14.
@2148		density_stroma_cd8p     14.
@2162		density_all_cd8p     14.
@2176		dis_cd8p_mclosest     13.
@2189		dis_cd8p_sdclosest     13.
@2202		dis_cd8p_mmult	    13.
@2215		dis_cd8p_sdmult	    13.
@2228		dis_cd8p_medge	    13.
@2241		dis_cd8p_sdedge	    12.
@2253		number_of_cores	    1.
@2254		TMA_N		    2. /*TMA number;CRC case:1,2,3,4,6,10,11,12,13,14*/
;
proc sort data=tcellif; by TumorID; run;

/*t cell IF*/
data tcellnew;
infile '/udd/nhsug/ETBF/tcellnew_cleaned.csv' dlm=',' firstobs=2; /*TumorID level measurements for NHSHPFS.cohort20240927v3.csv*/
input TumorID CD3_dens_epi CD3_dens_epi_naive CD3_dens_epi_memory CD3CD4_dens_epi CD3CD4_dens_epi_naive CD3CD4_dens_epi_memory CD3CD4_dens_epi_regulatory 
CD3CD8_dens_epi CD3CD8_dens_epi_naive CD3CD8_dens_epi_memory CD3CD8_dens_epi_regulatory CD3DN_dens_epi CD3DN_dens_epi_naive CD3DN_dens_epi_memory 
CD3_dens_st CD3_dens_st_naive CD3_dens_st_memory CD3CD4_dens_st CD3CD4_dens_st_naive CD3CD4_dens_st_memory CD3CD4_dens_st_regulatory CD3CD8_dens_st CD3CD8_dens_st_naive CD3CD8_dens_st_memory CD3CD8_dens_st_regulatory CD3DN_dens_st CD3DN_dens_st_naive CD3DN_dens_st_memory CD3_dens_all CD3_dens_all_naive 
CD3_dens_all_memory CD3CD4_dens_all CD3CD4_dens_all_naive CD3CD4_dens_all_memory CD3CD4_dens_all_regulatory CD3CD8_dens_all CD3CD8_dens_all_naive 
CD3CD8_dens_all_memory CD3CD8_dens_all_regulatory CD3DN_dens_all CD3DN_dens_all_naive CD3DN_dens_all_memory;
proc sort data=tcellnew; by TumorID; run;


/*Fusobacterium20181224 */

data fusonuc2; infile '/udd/nhogi/Survival/DATA/fusobacterium20181224.dat' lrecl=50 recfm=d;

input
@1		TumorID		    4.
@5		T_PGT_Ct	    11.
@16		T_fusobacterium_nuc_Ct     11.
@27		T_fusobacterium_nuc_dCt     12.
@39		fusonuc		    11.
;
/*fusonuc = 2^(-delta Ct) */

proc sort data=fusonuc2; by TumorID; run;

/*HE immune cells*/
data HEcell; infile '/udd/nhogi/Survival/DATA/HE_cell_densities_20190606.dat' lrecl=454 recfm=d;

input
@1		TumorID		    4.
@5		dens_Lymphocyte_Tumor     14.
@19		dens_Neutrophil_Tumor     14.
@33		dens_Other_Tumor     13.
@46		dens_Plama_cell_Tumor     13.
@59		dens_Tumor_Tumor     14.
@73		dens_Eosinophil_Tumor     13.
@86		dens_Granulocyte_Tumor     1.
@87		dens_Lymphocyte_Stroma     14.
@101		dens_Neutrophil_Stroma     14.
@115		dens_Other_Stroma     13.
@128		dens_Plama_cell_Stroma     13.
@141		dens_Tumor_Stroma     13.
@154		dens_Eosinophil_Stroma     13.
@167		dens_Granulocyte_Stroma     11.
@178		dens_Lymphocyte_Other     14.
@192		dens_Neutrophil_Other     14.
@206		dens_Other_Other     13.
@219		dens_Plama_cell_Other     13.
@232		dens_Tumor_Other     14.
@246		dens_Eosinophil_Other     13.
@259		dens_Granulocyte_Other     1.
@260		dens_Lymphocyte_TumorStroma     14.
@274		dens_Neutrophil_TumorStroma     14.
@288		dens_Other_TumorStroma     12.
@300		dens_Plama_cell_TumorStroma     13.
@313		dens_Tumor_TumorStroma     15.
@328		dens_Eosinophil_TumorStroma     13.
@341		dens_Granulocyte_TumorStroma     11.
@352		dens_Eosinophil_all     13.
@365		dens_Neutrophil_all     14.
@379		dens_Lymphocyte_all     14.
@393		dens_Plasma_cell_all     13.
@406		dens_Tumor_all	    15.
@421		dens_Other_all	    12.
@433		stroma_percentage     10.
@443		necrosis_percentage     11.
;

proc sort data=HEcell; by TumorID; run;

/*macrophage singleplex*/
data MF; infile '/udd/nhogi/Survival/DATA/macrophage_IF_tumor_20190626.dat' lrecl=1038 recfm=d;

input
@1		TumorID		    4.
@5		regions		    1.
@6		tumorpixels	    7.
@13		stromapixels	    7.
@20		otherpixels	    7.
@27		allpixels	    7.
@34		Opal_540_fac	    2.
@36		Opal_690_fac	    1.
@37		Opal_650_fac	    1.
@38		Opal_570_fac	    1.
@39		count_tumor_MF	    13.
@52		count_tumor_tumor_cell     12.
@64		count_tumor_stroma_cell     1.
@65		count_tumor_CD86     13.
@78		count_tumor_CD206     13.
@91		count_tumor_IRF5     13.
@104		count_tumor_MAF	    13.
@117		count_tumor_CD86_CD206     13.
@130		count_tumor_CD86_IRF5     13.
@143		count_tumor_CD86_MAF     13.
@156		count_tumor_CD206_IRF5     13.
@169		count_tumor_CD206_MAF     13.
@182		count_tumor_IRF5_MAF     13.
@195		count_stroma_MF	    13.
@208		count_stroma_tumor_cell     1.
@209		count_stroma_stroma_cell     13.
@222		count_stroma_CD86     13.
@235		count_stroma_CD206     14.
@249		count_stroma_IRF5     13.
@262		count_stroma_MAF     13.
@275		count_stroma_CD86_CD206     13.
@288		count_stroma_CD86_IRF5     13.
@301		count_stroma_CD86_MAF     13.
@314		count_stroma_CD206_IRF5     13.
@327		count_stroma_CD206_MAF     13.
@340		count_stroma_IRF5_MAF     13.
@353		count_all_MF	    14.
@367		count_all_tumor_cell     12.
@379		count_all_stroma_cell     13.
@392		count_all_CD86	    14.
@406		count_all_CD206	    14.
@420		count_all_IRF5	    13.
@433		count_all_MAF	    13.
@446		count_all_CD86_CD206     14.
@460		count_all_CD86_IRF5     13.
@473		count_all_CD86_MAF     13.
@486		count_all_CD206_IRF5     13.
@499		count_all_CD206_MAF     13.
@512		count_all_IRF5_MAF     13.
@525		density_tumor_MF     14.
@539		density_tumor_tumor_cell     12.
@551		density_tumor_stroma_cell     1.
@552		density_tumor_CD86     14.
@566		density_tumor_CD206     14.
@580		density_tumor_IRF5     14.
@594		density_tumor_MAF     14.
@608		density_tumor_CD86_CD206     14.
@622		density_tumor_CD86_IRF5     14.
@636		density_tumor_CD86_MAF     14.
@650		density_tumor_CD206_IRF5     14.
@664		density_tumor_CD206_MAF     14.
@678		density_tumor_IRF5_MAF     13.
@691		density_stroma_MF     13.
@704		density_stroma_tumor_cell     1.
@705		density_stroma_stroma_cell     13.
@718		density_stroma_CD86     14.
@732		density_stroma_CD206     14.
@746		density_stroma_IRF5     14.
@760		density_stroma_MAF     14.
@774		density_stroma_CD86_CD206     14.
@788		density_stroma_CD86_IRF5     14.
@802		density_stroma_CD86_MAF     14.
@816		density_stroma_CD206_IRF5     14.
@830		density_stroma_CD206_MAF     14.
@844		density_stroma_IRF5_MAF     14.
@858		density_all_MF	    13.
@871		density_all_tumor_cell     14.
@885		density_all_stroma_cell     13.
@898		density_all_CD86     14.
@912		density_all_CD206     14.
@926		density_all_IRF5     14.
@940		density_all_MAF	    14.
@954		density_all_CD86_CD206     14.
@968		density_all_CD86_IRF5     14.
@982		density_all_CD86_MAF     14.
@996		density_all_CD206_IRF5     14.
@1010		density_all_CD206_MAF     14.
@1024		density_all_IRF5_MAF     14.
;

proc sort data=MF; by TumorID; run;

/*macrophage polarization*/
data MF_index; infile '/udd/nhogi/Survival/DATA/MF_index_20190626.dat' lrecl=79 recfm=d;

input
@1		TumorID		    4.
@5		index_mean_stroma     12.
@17		index_sd_stroma	    13.
@30		index_mean_tumor     12.
@42		index_sd_tumor	    12.
@54		index_mean_all	    12.
@66		index_sd_all	    13.
;
proc sort data=MF_index; by TumorID; run;

/*macrophage M1 M2 density 30% cutoff*/
data MF_M1M2; infile '/udd/nhogi/Survival/DATA/MF_M1M2_dens_30_30_all_20190626.dat' lrecl=248 recfm=d;

input
@1		TumorID		    4.
@5		count_M1_tumor	    13.
@18		count_M2_tumor	    13.
@31		count_M1M2_tumor     13.
@44		count_M1_stroma	    13.
@57		count_M2_stroma	    13.
@70		count_M1M2_stroma     13.
@83		count_M1_all	    13.
@96		count_M2_all	    13.
@109		count_M1M2_all	    13.
@122		density_M1_tumor     14.
@136		density_M2_tumor     14.
@150		density_M1M2_tumor     14.
@164		density_M1_stroma     14.
@178		density_M2_stroma     14.
@192		density_M1M2_stroma     14.
@206		density_M1_all	    14.
@220		density_M2_all	    14.
@234		density_M1M2_all     14.
;

proc sort data=MF_M1M2; by TumorID; run;

/*HE Gcross AUC category*/
data HE_Gcross; infile '/udd/nhogi/Survival/DATA/Gcross_AUC_Q4_20190806.dat' lrecl=9 recfm=d;

input
@1		TumorID		    4.
@5		Gc_Eosino	    1.
@6		Gc_Lym		    1.
@7		Gc_Neu		    1.
@8		Gc_Plasma	    1.
;

proc sort data=HE_Gcross; by TumorID; run;

/*budding PDC */
data budding; infile '/udd/nhogi/Survival/DATA/budding_20190903_N947.dat' lrecl=14 recfm=d;

input
@1		TumorID		    4.
@5		bud_IM		    2. /*invasive front*/
@7		bud_CT		    2. /*tumor center*/
@9		PDC_IM		    2. /*invasive front*/
@11		PDC_CT		    2. /*tumor center*/
@13		border_new	    1.
;

proc sort data=budding; by TumorID; run;

/*pks+ E. coli*/
data pks;
infile '/udd/nhogi/Survival/DATA/clbB20191219.dat' lrecl=27 recfm=d;

input
@1		TumorID	    4.
@5		clbb165		    11.
@16		clbb93		    11.
;
proc sort data=pks; by TumorID; run;

/*dr*/
data drs; infile '/udd/nhogi/Survival/DATA/dr20200319.dat' lrecl=19 recfm=d;

input
@1		TumorID	    4.
@5		dr1		    2.
@7		dr2		    2.
@9		myx		    2.
@11		col		    2.
@13		fib		    2.
@15		tsr_ave		    2.
@17		tsr_max		    2.
;
proc sort data=drs; by TumorID; run;

/*Myeloid IF*/
data Myeloid; infile '/udd/nhogi/Survival/DATA/myeloid_densities_20200106.dat' lrecl=1304 recfm=d;

input
@1		TumorID		    4.
@5		cd14p_t		    14.
@19		cd14phladrp_t	    14.
@33		cd14phladrn_t	    14.
@47		cd14pcd33p_t	    14.
@61		cd14pcd33n_t	    14.
@75		cd14parg1p_t	    14.
@89		cd14parg1n_t	    14.
@103		cd14phladrpcd33p_t     14.
@117		cd14phladrncd33p_t     13.
@130		cd14phladrpcd33n_t     14.
@144		cd14phladrncd33n_t     14.
@158		cd14phladrparg1p_t     14.
@172		cd14phladrnarg1p_t     14.
@186		cd14phladrparg1n_t     14.
@200		cd14phladrnarg1n_t     14.
@214		cd14phladrpcd33parg1p_t     13.
@227		cd14phladrncd33parg1p_t     13.
@240		cd14phladrpcd33parg1n_t     13.
@253		cd14phladrncd33parg1n_t     12.
@265		cd14phladrpcd33narg1p_t     14.
@279		cd14phladrncd33narg1p_t     14.
@293		cd14phladrpcd33narg1n_t     14.
@307		cd14phladrncd33narg1n_t     14.
@321		cd15p_t		    14.
@335		cd15parg1p_t	    14.
@349		cd15parg1n_t	    13.
@362		cd15pcd33p_t	    13.
@375		cd15pcd33n_t	    14.
@389		cd15pcd33parg1p_t     13.
@402		cd15pcd33parg1n_t     12.
@414		cd15pcd33narg1p_t     14.
@428		cd15pcd33narg1n_t     13.
@441		cd14p_s		    13.
@454		cd14phladrp_s	    14.
@468		cd14phladrn_s	    13.
@481		cd14pcd33p_s	    14.
@495		cd14pcd33n_s	    13.
@508		cd14parg1p_s	    14.
@522		cd14parg1n_s	    13.
@535		cd14phladrpcd33p_s     14.
@549		cd14phladrncd33p_s     13.
@562		cd14phladrpcd33n_s     14.
@576		cd14phladrncd33n_s     13.
@589		cd14phladrparg1p_s     14.
@603		cd14phladrnarg1p_s     13.
@616		cd14phladrparg1n_s     14.
@630		cd14phladrnarg1n_s     13.
@643		cd14phladrpcd33parg1p_s     13.
@656		cd14phladrncd33parg1p_s     13.
@669		cd14phladrpcd33parg1n_s     13.
@682		cd14phladrncd33parg1n_s     13.
@695		cd14phladrpcd33narg1p_s     14.
@709		cd14phladrncd33narg1p_s     13.
@722		cd14phladrpcd33narg1n_s     14.
@736		cd14phladrncd33narg1n_s     13.
@749		cd15p_s		    14.
@763		cd15parg1p_s	    14.
@777		cd15parg1n_s	    14.
@791		cd15pcd33p_s	    14.
@805		cd15pcd33n_s	    14.
@819		cd15pcd33parg1p_s     14.
@833		cd15pcd33parg1n_s     12.
@845		cd15pcd33narg1p_s     14.
@859		cd15pcd33narg1n_s     14.
@873		cd14p_a		    14.
@887		cd14phladrp_a	    13.
@900		cd14phladrn_a	    14.
@914		cd14pcd33p_a	    13.
@927		cd14pcd33n_a	    14.
@941		cd14parg1p_a	    14.
@955		cd14parg1n_a	    14.
@969		cd14phladrpcd33p_a     13.
@982		cd14phladrncd33p_a     13.
@995		cd14phladrpcd33n_a     13.
@1008		cd14phladrncd33n_a     14.
@1022		cd14phladrparg1p_a     14.
@1036		cd14phladrnarg1p_a     13.
@1049		cd14phladrparg1n_a     13.
@1062		cd14phladrnarg1n_a     14.
@1076		cd14phladrpcd33parg1p_a     13.
@1089		cd14phladrncd33parg1p_a     13.
@1102		cd14phladrpcd33parg1n_a     13.
@1115		cd14phladrncd33parg1n_a     13.
@1128		cd14phladrpcd33narg1p_a     14.
@1142		cd14phladrncd33narg1p_a     13.
@1155		cd14phladrpcd33narg1n_a     13.
@1168		cd14phladrncd33narg1n_a     14.
@1182		cd15p_a		    14.
@1196		cd15parg1p_a	    14.
@1210		cd15parg1n_a	    13.
@1223		cd15pcd33p_a	    14.
@1237		cd15pcd33n_a	    14.
@1251		cd15pcd33parg1p_a     14.
@1265		cd15pcd33parg1n_a     12.
@1277		cd15pcd33narg1p_a     14.
@1291		cd15pcd33narg1n_a     13.
;

proc sort data=Myeloid; by TumorID; run;

/*Myeloid G cross*/
data Myeloid_Gcross; infile '/udd/nhogi/Survival/DATA/myeloid_gcross_20200117.dat' lrecl=113 recfm=d;

input
@1		TumorID		    4.
@5		G_tumor_cd14	    10.
@15		G_cd14_tumor	    11.
@26		G_tumor_cd15	    10.
@36		G_cd15_tumor	    11.
@47		G_tumor_cd14phladrn     10.
@57		G_cd14phladrn_tumor     11.
@68		G_tumor_cd14phladrp     10.
@78		G_cd14phladrp_tumor     11.
@89		Gm_cd14phladrp_hladrn     12.
@101		Gm_cd14_cd15     12.
;
proc sort data=Myeloid_Gcross; by TumorID; run;

/*PTGS2 HPGD IF*/

data PTGS2_HPGD; infile '/udd/nhogi/Survival/DATA/PTGS2_patient_level_20200519.dat' lrecl=706 recfm=d;

input
@1		TumorID		    4.
@5		tryp_dens_t     13.
@18		cd68_dens_t	    14.
@32		tryp_ptgs2p_dens_t     13.
@45		tryp_ptgs2n_dens_t     13.
@58		tryp_hpgdp_dens_t     13.
@71		tryp_hpgdn_dens_t     13.
@84		tryp_ptgs2hpgdrh_dens_t     13.
@97		tryp_ptgs2hpgdrl_dens_t     13.
@110		cd68_ptgs2p_dens_t     14.
@124		cd68_ptgs2n_dens_t     14.
@138		cd68_hpgdp_dens_t     13.
@151		cd68_hpgdn_dens_t     14.
@165		cd68_ptgs2hpgdrh_dens_t     14.
@179		cd68_ptgs2hpgdrl_dens_t     14.
@193		tryp_dens_s     14.
@207		cd68_dens_s     13.
@220		tryp_ptgs2p_dens_s     13.
@233		tryp_ptgs2n_dens_s     14.
@247		tryp_hpgdp_dens_s     14.
@261		tryp_hpgdn_dens_s     14.
@275		tryp_ptgs2hpgdrh_dens_s     13.
@288		tryp_ptgs2hpgdrl_dens_s     14.
@302		cd68_ptgs2p_dens_s     14.
@316		cd68_ptgs2n_dens_s     13.
@329		cd68_hpgdp_dens_s     13.
@342		cd68_hpgdn_dens_s     13.
@355		cd68_ptgs2hpgdrh_dens_s     14.
@369		cd68_ptgs2hpgdrl_dens_s     14.
@383		tryp_dens_a     14.
@397		cd68_dens_a     13.
@410		tryp_ptgs2p_dens_a     13.
@423		tryp_ptgs2n_dens_a     14.
@437		tryp_hpgdp_dens_a     14.
@451		tryp_hpgdn_dens_a     13.
@464		tryp_ptgs2hpgdrh_dens_a     13.
@477		tryp_ptgs2hpgdrl_dens_a     14.
@491		cd68_ptgs2p_dens_a     14.
@505		cd68_ptgs2n_dens_a     13.
@518		cd68_hpgdp_dens_a     13.
@531		cd68_hpgdn_dens_a     13.
@544		cd68_ptgs2hpgdrh_dens_a     14.
@558		cd68_ptgs2hpgdrl_dens_a     14.
@572		ptgs2_int_t	    11.
@583		ptgs2_int_cd68	    11.
@594		ptgs2_int_tryp     11.
@605		ptgs2_int_other	    11.
@616		hpgd_int_t	    11.
@627		hpgd_int_cd68	    10.
@637		hpgd_int_tryp     11.
@648		hpgd_int_other	    10.
@658		ptgs2hpgdr_t     12.
@670		ptgs2hpgdr_cd68     12.
@682		ptgs2hpgdr_tryp     12.
@694		ptgs2hpgdr_other     12.
;

proc sort data=PTGS2_HPGD; by TumorID; run;

/*NK IF*/

data NK; infile '/udd/nhogi/Survival/DATA/NK1NK2_patient_level_20200601.dat' lrecl=1055 recfm=d;

input
@1		TumorID		    4.
@5		cd56p_cd3n_dens_t     13.
@18		cd56p_cd3n_gzmbp_dens_t     13.
@31		cd56p_cd3n_gzmbn_dens_t     12.
@43		cd56p_cd3n_cd16p_dens_t     12.
@55		cd56p_cd3n_cd16n_dens_t     13.
@68		cd56p_cd3p_dens_t     12.
@80		cd56p_cd3p_gzmbp_dens_t     12.
@92		cd56p_cd3p_gzmbn_dens_t     12.
@104		cd56p_cd3p_cd16p_dens_t     11.
@115		cd56p_cd3p_cd16n_dens_t     12.
@127		cd56n_cd3p_dens_t     14.
@141		cd56n_cd3p_gzmbp_dens_t     14.
@155		cd56n_cd3p_gzmbn_dens_t     14.
@169		cd56n_cd3p_cd16p_dens_t     13.
@182		cd56n_cd3p_cd16n_dens_t     14.
@196		cd56n_cd3n_cd16p_dens_t     14.
@210		cd45p_cd56n_cd3n_cd16n_dens_t     14.
@224		cd45p_dens_t     14.
@238		cd45n_ckn_dens_t     13.
@251		cd56p_cd3n_dens_s     13.
@264		cd56p_cd3n_gzmbp_dens_s     13.
@277		cd56p_cd3n_gzmbn_dens_s     12.
@289		cd56p_cd3n_cd16p_dens_s     12.
@301		cd56p_cd3n_cd16n_dens_s     13.
@314		cd56p_cd3p_dens_s     13.
@327		cd56p_cd3p_gzmbp_dens_s     12.
@339		cd56p_cd3p_gzmbn_dens_s     12.
@351		cd56p_cd3p_cd16p_dens_s     12.
@363		cd56p_cd3p_cd16n_dens_s     13.
@376		cd56n_cd3p_dens_s     13.
@389		cd56n_cd3p_gzmbp_dens_s     14.
@403		cd56n_cd3p_gzmbn_dens_s     13.
@416		cd56n_cd3p_cd16p_dens_s     14.
@430		cd56n_cd3p_cd16n_dens_s     13.
@443		cd56n_cd3n_cd16p_dens_s     13.
@456		cd45p_cd56n_cd3n_cd16n_dens_s     13.
@469		cd45p_dens_s     13.
@482		cd45n_ckn_dens_s     12.
@494		cd56p_cd3n_dens_a     13.
@507		cd56p_cd3n_gzmbp_dens_a     13.
@520		cd56p_cd3n_gzmbn_dens_a     12.
@532		cd56p_cd3n_cd16p_dens_a     12.
@544		cd56p_cd3n_cd16n_dens_a     13.
@557		cd56p_cd3p_dens_a     12.
@569		cd56p_cd3p_gzmbp_dens_a     12.
@581		cd56p_cd3p_gzmbn_dens_a     12.
@593		cd56p_cd3p_cd16p_dens_a     12.
@605		cd56p_cd3p_cd16n_dens_a     12.
@617		cd56n_cd3p_dens_a     14.
@631		cd56n_cd3p_gzmbp_dens_a     14.
@645		cd56n_cd3p_gzmbn_dens_a     14.
@659		cd56n_cd3p_cd16p_dens_a     14.
@673		cd56n_cd3p_cd16n_dens_a     14.
@687		cd56n_cd3n_cd16p_dens_a     14.
@701		cd45p_cd56n_cd3n_cd16n_dens_a     14.
@715		cd45p_dens_a     13.
@728		cd45n_ckn_dens_a     12.
@740		b2m_int_t	    12.
@752		b2m_int_immune	    12.
@764		b2m_int_other	    12.
@776		b2m_int_log10_t     11.
@787		b2m_int_log10_immune     11.
@798		b2m_int_log10_other     11.
@809		b2m_sd_t	    11.
@820		b2m_sd_immune	    11.
@831		b2m_sd_other	    11.
@842		b2m_sd_log10_t     10.
@852		b2m_sd_log10_immune     10.
@862		b2m_sd_log10_other     10.
@872		b2m_t_zscore     12.
@884		b2m_t_zscore_log10     12.
@896		b2m_3cate	    1.
@897		hla_abc_int_t     12.
@909		hla_abc_int_immune     12.
@921		hla_abc_int_other     12.
@933		hla_abc_int_log10_t     11.
@944		hla_abc_int_log10_immune     11.
@955		hla_abc_int_log10_other     11.
@966		hla_abc_sd_t     11.
@977		hla_abc_sd_immune     12.
@989		hla_abc_sd_other     11.
@1000		hla_abc_sd_log10_t     10.
@1010		hla_abc_sd_log10_immune     10.
@1020		hla_abc_sd_log10_other     10.
@1030		hla_abc_t_zscore     12.
@1042		hla_abc_t_zscore_log10     12.
@1054		hla_abc_3cate	    1.
;

proc sort data=NK; by TumorID; run;

/*NK G cross*/
data NK_Gcross; infile '/udd/nhogi/Survival/DATA/gcross_NK1NK2_patient_level_20200525.dat' lrecl=1209 recfm=d;

input
@1		TumorID		    4.
@5		cd45p_ck_km10	    10.
@15		cd45p_ck_km20	    11.
@26		cd45p_ck_km30	    11.
@37		cd45p_ck_pois10	    10.
@47		cd45p_ck_pois20	    10.
@57		cd45p_ck_pois30	    11.
@68		ck_cd45p_km10	    10.
@78		ck_cd45p_km20	    10.
@88		ck_cd45p_km30	    11.
@99		ck_cd45p_pois10	    10.
@109		ck_cd45p_pois20	    10.
@119		ck_cd45p_pois30	    10.
@129		cd45p_ck_nnd	    13.
@142		ck_cd45p_nnd	    13.
@155		cd56n_cd3p_ck_km10     11.
@166		cd56n_cd3p_ck_km20     11.
@177		cd56n_cd3p_ck_km30     11.
@188		cd56n_cd3p_ck_pois10     10.
@198		cd56n_cd3p_ck_pois20     10.
@208		cd56n_cd3p_ck_pois30     11.
@219		ck_cd56n_cd3p_km10     10.
@229		ck_cd56n_cd3p_km20     10.
@239		ck_cd56n_cd3p_km30     10.
@249		ck_cd56n_cd3p_pois10     10.
@259		ck_cd56n_cd3p_pois20     10.
@269		ck_cd56n_cd3p_pois30     10.
@279		cd56n_cd3p_ck_nnd     13.
@292		ck_cd56n_cd3p_nnd     13.
@305		cd56n_cd3p_gzmbp_ck_km10     11.
@316		cd56n_cd3p_gzmbp_ck_km20     11.
@327		cd56n_cd3p_gzmbp_ck_km30     11.
@338		cd56n_cd3p_gzmbp_ck_pois10     10.
@348		cd56n_cd3p_gzmbp_ck_pois20     10.
@358		cd56n_cd3p_gzmbp_ck_pois30     11.
@369		ck_cd56n_cd3p_gzmbp_km10     11.
@380		ck_cd56n_cd3p_gzmbp_km20     10.
@390		ck_cd56n_cd3p_gzmbp_km30     10.
@400		ck_cd56n_cd3p_gzmbp_pois10     10.
@410		ck_cd56n_cd3p_gzmbp_pois20     10.
@420		ck_cd56n_cd3p_gzmbp_pois30     10.
@430		cd56n_cd3p_gzmbp_ck_nnd     13.
@443		ck_cd56n_cd3p_gzmbp_nnd     13.
@456		cd56n_cd3p_gzmbn_ck_km10     11.
@467		cd56n_cd3p_gzmbn_ck_km20     11.
@478		cd56n_cd3p_gzmbn_ck_km30     11.
@489		cd56n_cd3p_gzmbn_ck_pois10     10.
@499		cd56n_cd3p_gzmbn_ck_pois20     10.
@509		cd56n_cd3p_gzmbn_ck_pois30     11.
@520		ck_cd56n_cd3p_gzmbn_km10     10.
@530		ck_cd56n_cd3p_gzmbn_km20     10.
@540		ck_cd56n_cd3p_gzmbn_km30     10.
@550		ck_cd56n_cd3p_gzmbn_pois10     10.
@560		ck_cd56n_cd3p_gzmbn_pois20     10.
@570		ck_cd56n_cd3p_gzmbn_pois30     10.
@580		cd56n_cd3p_gzmbn_ck_nnd     13.
@593		ck_cd56n_cd3p_gzmbn_nnd     12.
@605		cd56p_cd3n_ck_km10     11.
@616		cd56p_cd3n_ck_km20     11.
@627		cd56p_cd3n_ck_km30     11.
@638		cd56p_cd3n_ck_pois10     10.
@648		cd56p_cd3n_ck_pois20     10.
@658		cd56p_cd3n_ck_pois30     11.
@669		ck_cd56p_cd3n_km10     11.
@680		ck_cd56p_cd3n_km20     11.
@691		ck_cd56p_cd3n_km30     11.
@702		ck_cd56p_cd3n_pois10     11.
@713		ck_cd56p_cd3n_pois20     10.
@723		ck_cd56p_cd3n_pois30     10.
@733		cd56p_cd3n_ck_nnd     13.
@746		ck_cd56p_cd3n_nnd     13.
@759		cd56p_cd3p_ck_km10     11.
@770		cd56p_cd3p_ck_km20     11.
@781		cd56p_cd3p_ck_km30     11.
@792		cd56p_cd3p_ck_pois10     10.
@802		cd56p_cd3p_ck_pois20     10.
@812		cd56p_cd3p_ck_pois30     11.
@823		ck_cd56p_cd3p_km10     11.
@834		ck_cd56p_cd3p_km20     10.
@844		ck_cd56p_cd3p_km30     11.
@855		ck_cd56p_cd3p_pois10     11.
@866		ck_cd56p_cd3p_pois20     10.
@876		ck_cd56p_cd3p_pois30     10.
@886		cd56p_cd3p_ck_nnd     13.
@899		ck_cd56p_cd3p_nnd     13.
@912		cd56n_cd3n_cd16p_ck_km10     10.
@922		cd56n_cd3n_cd16p_ck_km20     11.
@933		cd56n_cd3n_cd16p_ck_km30     11.
@944		cd56n_cd3n_cd16p_ck_pois10     10.
@954		cd56n_cd3n_cd16p_ck_pois20     10.
@964		cd56n_cd3n_cd16p_ck_pois30     11.
@975		ck_cd56n_cd3n_cd16p_km10     11.
@986		ck_cd56n_cd3n_cd16p_km20     10.
@996		ck_cd56n_cd3n_cd16p_km30     10.
@1006		ck_cd56n_cd3n_cd16p_pois10     10.
@1016		ck_cd56n_cd3n_cd16p_pois20     10.
@1026		ck_cd56n_cd3n_cd16p_pois30     10.
@1036		cd56n_cd3n_cd16p_ck_nnd     13.
@1049		ck_cd56n_cd3n_cd16p_nnd     12.
@1061		cd56n_cd3n_cd16n_cd45p_ck_km10     10.
@1071		cd56n_cd3n_cd16n_cd45p_ck_km20     11.
@1082		cd56n_cd3n_cd16n_cd45p_ck_km30     11.
@1093		cd56n_cd3n_cd16n_cd45p_ck_pois10     10.
@1103		cd56n_cd3n_cd16n_cd45p_ck_pois20     10.
@1113		cd56n_cd3n_cd16n_cd45p_ck_pois30     11.
@1124		ck_cd56n_cd3n_cd16n_cd45p_km10     10.
@1134		ck_cd56n_cd3n_cd16n_cd45p_km20     10.
@1144		ck_cd56n_cd3n_cd16n_cd45p_km30     10.
@1154		ck_cd56n_cd3n_cd16n_cd45p_pois10     10.
@1164		ck_cd56n_cd3n_cd16n_cd45p_pois20     10.
@1174		ck_cd56n_cd3n_cd16n_cd45p_pois30     10.
@1184		cd56n_cd3n_cd16n_cd45p_ck_nnd     13.
@1197		ck_cd56n_cd3n_cd16n_cd45p_nnd     12.
;

proc sort data=NK_Gcross; by TumorID; run;

/**************Reading Pathology data in the lab*************************/
data path2; infile '/udd/nhogi/Survival/DATA/path2_20171120.dat' lrecl=475 recfm=d;

input
@1		MGH_case2	    1.
@2		TumorID	    4.
@6		ysnColon	    1.
@7		ysnCancer	    1.
@8		ysnPolyp	    1.
@9		ysnPancreas	    1.
@10		Entered		$   10.
@20		ReturnChanning	    1.
@21		BackfromChanning     1.
@22		BWHcase		    1.
@23		Returned	$   10.
@33		Inadequate	    1.
@34		id		    6.
@40		intICD		    3.
@43		Cohort		$   2.
@45		intAge		    2.
@47		intProceduredate $   10.
@57		hospital	    2.
@59		doublecancer	    1.
@60		obstruction	    2.
@62		strSurgPath	$   10.
@72		strNLSurgPath	$   11.
@83		ysnBiopsy	    1.
@84		ysnPolypectomy	    1.
@85		ysnTMA		    1.
@86		ysnTMA_HE_unnecessary     1.
@87		ysn_DN_IHHE_unnecessary     1.
@88		strLocation	$   4.
@92		Tumor_location_cm     3.
@95		ysnSubtotal	    1.
@96		lengthcolon	    3.
@99		lengthincludeileum     1.
@100		circumferential	    3.
@103		ysnCircumferential     1.
@104		dblSize		    3.
@107		dblsamplesize	    3.
@110		dblSizefocusCa	    2.
@112		LVIpathreport	    1.
@113		PNIpathreport	    1.
@114		strGross	$   10.
@124		ysnHighblock	    1.
@125		ysnRecutblock	    1.
@126		intNoBlock	    2.
@128		ysnNeedBlockID	    1.
@129		intNoTumorblock	    1.
@130		strTblock1	$   10.
@140		ysnTblock1review     1.
@141		strTblockDNA	$   47.
@188		ysnTblockDNAreview     1.
@189		ysnTcellBlock	    1.
@190		strTblock2	$   29.
@219		strNblockTMA	$   10.
@229		ysnNblockTMAreview     1.
@230		strNblockDNA	$   25.
@255		ysnNblockDNAreview     1.
@256		strNblockLN	$   9.
@265		ysnNblockLNreview     1.
@266		intNoHEslide	    3.
@269		intNoHErecutslides     2.
@271		intNoTUnstainSlide     2.
@273		intNoNUnstainSlide     2.
@275		ysnMadeRecutBlock     1.
@276		ysnTissueRollsTube     1.
@277		ysnReadyTMA	    1.
@278		ysnTMAdone	    1.
@279		ysnTMATNsameblock     1.
@280		ysnTMATonly	    1.
@281		ysnNormalDNA	    1.
@282		ysnNormalDNALN	    1.
@283		strOtherNormalDNA $   27.
@310		ysnDNATNsameslide     1.
@311		ysnDNANslidewithT     1.
@312		ysnTumorLN	    1.
@313		dtmHErev	$   10.
@323		ysnNonHEslideReviewed     1.
@324		intNoSlidesReview     2.
@326		ysnMetastaticsite     1.
@327		ysnTreatmentChange     1.
@328		strTumortype	$   11.
@339		PatholDiff	    1.
@340		intWorstGrade	    1.
@341		intNucGrade	    1.
@342		intTumheterogeneity     1.
@343		intResidualAde	    2.
@345		intResidualAdeSerration     1.
@346		intTDNAperc	    2.
@348		ysnAdenoma	    1.
@349		strSerrated	    1.
@350		strSerrationGrade     1.
@351		intSerrationPerc     1.
@352		strMucinousAdenomaGrade     1.
@353		ysnMucinousAdenoma     1.
@354		ysnBackgroundAdenoma     1.
@355		ysnDysplasia	    1.
@356		ysnPseudoinvasion     1.
@357		ysnWithInvasivion     1.
@358		ysnFlatAdenoma	    1.
@359		tumorborder	    1.
@360		intTumorbudding	    1.
@361		sheetp		    3.
@364		Sheetysn	    1.
@365		intCellularityperc     2.
@367		intStromaperc	    2.
@369		intDirtynecrosis     1.
@370		intDirtNecroPerc     3.
@373		necrosisp	    2.
@375		crohn		    1.
@376		peritumoral	    1.
@377		perinest	    1.
@378		til		    1.
@379		mucinysn	    1.
@380		mucinp		    3.
@383		Signetysn	    1.
@384		signetp		    3.
@387		microglandp	    2.
@389		Microglandysn	    1.
@390		nestCribriformysn     1.
@391		nestCribp	    2.
@393		sarcomatoid	    1.
@394		Neuroendo	    3.
@397		Adenosq		    3.
@400		intSq		    2.
@402		intLymphaticinv	    1.
@403		intVenousinv	    1.
@404		intPerineuinv	    1.
@405		intPeritoneal	    1.
@406		intStageT	    1.
@407		intStageN	    1.
@408		stageM		    1.
@409		ysnmany_LNpos	    1.
@410		intNoLN		    2.
@412		intNoPLN	    2.
@414		intNoPLNmicromet     1.
@415		intLNcapsinv	    2.
@417		intsmooth_contoured     2.
@419		intirregular_contoured     2.
@421		intLNmatted	    1.
@422		ysnLN_met	    1.
@423		ysnLivermet	    1.
@424		ysnUC		    1.
@425		ysnCrohn	    1.
@426		intOthercancer	    1.
@427		ysnAriseAdenoma	    1.
@428		strAriseSerrated $   1.
@429		intOtherAdenoma	    1.
@430		intOtherHyperpolyp     1.
@431		ysnPolyposis	    1.
@432		ysnMultiplepolyp     1.
@433		intAdenomaType	    2.
@435		ysnRadiationTx	    1.
@436		ysnChemoTx	    1.
@437		ysnAutopsy	    1.
@438		ysnMultifocal	    1.
@439		strType		$   2.
@441		strTumorExAVtype $   1.
@442		intPancDiff	    1.
@443		intPancWorstGrade     1.
@444		ysnPanIN	    1.
@445		intPancTumorborder     1.
@446		inPanctSheet	    1.
@447		intPancpercSheet     1.
@448		intPancNecrosisperc     1.
@449		intPancPeritumoral     1.
@450		intPancPeritumornest     1.
@451		intPancTIL	    1.
@452		intPancPerinestPMN     1.
@453		intPancTIN	    1.
@454		intPancMucinous	    1.
@455		intPancpercmucinous     1.
@456		intPancpercMicrogland     1.
@457		intPancMicrogland     1.
@458		intPancSignet	    1.
@459		intPancpercsignet     1.
@460		intPancpercSarcomatoid     1.
@461		intPancpercNeuroendo     1.
@462		intPancpercSq	    1.
@463		intPancStageN	$   2.
@465		intPancStageM	$   2.
@467		ysnChPancreatitis     1.
@468		ysnChPancreatitisHistory     1.
@469		intPancOthercancer     1.
@470		ysnPeritoneal_implant     1.
@471		ysnInadequate_for_DNA     1.
@472		ysnHumanError	    1.
@473		Exclude1case1T	    1.
@474		MGH_Mari_checked     1.
;

if Exclude1case1T=1 then delete; /*delete 2nd 3rd tumor in the same case*/
if dtmHErev eq "" and TumorID gt 4000 then delete; /*If Shuji did not yet check some cases, this column is blanked*/
run;
proc sort data=path2; by TumorID; run; 

/*Bacteroideds fragilis toxin*/
data bft;
infile '/udd/nhhka/BFT/BFbft20221125.csv' dlm=',' firstobs=2;
input TumorID CtBF Ctbft Ctbft1	Ctbft2 Ctbft3 BF bft bft1 bft2 bft3	bftisotypecat;
proc sort data=bft; by TumorID; run;

/*vessel data*/
data vessel;
infile '/udd/nhkma/data/Vessel_data_mol_morph_20250125.csv' lrecl=30000 dlm=',' firstobs=2;
input TumorID density_stroma_Vessel density_stroma_LAMB1pVes density_stroma_KDRpVes density_stroma_CD36pVes density_stroma_ACKR1pVes density_stroma_MADCAM1pVes 
		density_stroma_microVes density_stroma_patentVes density_stroma_collapsedVes density_stroma_branchedVes
		prop_stroma_microVes prop_stroma_patentVes prop_stroma_collapsedVes prop_stroma_branchedVes prop_micro_collapsed
		MajorAxisLength	MajorAxisLength_Area	MinorAxisLength MinorAxisLength_Area Eccentricity ConvexArea Circularity FilledArea EquivDiameter Solidity 
		Perimeter Perimeter_Area Extent DistanceToCentroid DistanceToMeanOfBoundary MinDistance;
proc sort data=vessel; by TumorID; run;

data ves_Gcross;
infile '/udd/nhkma/data/Gcross_vessel_case.csv' lrecl=30000 dlm=',' firstobs=2;
input TumorID KDR_r5	KDR_r10	KDR_r20	KDR_r40	KDR_r50	KDR_r100	KDR_r200	KDR_r300	MADCAM1_r5	MADCAM1_r10	MADCAM1_r20	MADCAM1_r40	MADCAM1_r50	MADCAM1_r100	MADCAM1_r200	MADCAM1_r300	
ACKR1_r5	ACKR1_r10	ACKR1_r20	ACKR1_r40	ACKR1_r50	ACKR1_r100	ACKR1_r200	ACKR1_r300	CD36_r5	CD36_r10	CD36_r20	CD36_r40	CD36_r50	CD36_r100	CD36_r200	CD36_r300	
LAMB1_r5	LAMB1_r10	LAMB1_r20	LAMB1_r40	LAMB1_r50	LAMB1_r100	LAMB1_r200	LAMB1_r300	 Vessels_r5	 Vessels_r10	 Vessels_r20	 Vessels_r40	 Vessels_r50	 Vessels_r100	 Vessels_r200	 Vessels_r300	
micro_r5	micro_r10	micro_r20	micro_r40	micro_r50	micro_r100	micro_r200	micro_r300	patent_r5	patent_r10	patent_r20	patent_r40	patent_r50	patent_r100	patent_r200	patent_r300	
collapsed_r5	collapsed_r10	collapsed_r20	collapsed_r40	collapsed_r50	collapsed_r100	collapsed_r200	collapsed_r300	branched_r5	branched_r10	branched_r20	branched_r40	branched_r50	branched_r100	branched_r200	branched_r300
;
proc sort data=ves_Gcross; by TumorID; run;


/* Cancer-associated fibroblast (CAF) mIF data */
data cafmif;
infile '/udd/nhkma/data/CAF_data_case_v4.csv' lrecl=30000 dlm=',' firstobs=2;
input TumorID ACTA2p_prop FAPp_prop ACTA2FAPdp_prop ACTA2FAPdn_prop StromaPattern4cat FAP_ACTA2_ratio 
ACTA2pFB_density FAPpFB_density PDPNpFB_density ACTA2nFAPpFB_density ACTA2pFAPnFB_density ACTA2pFAPpFB_density ACTA2nFAPpPDPNnFB_density ACTA2pFAPnPDPNnFB_density 
ACTA2pFAPpPDPNnFB_density ACTA2nFAPpPDPNpFB_density ACTA2pFAPnPDPNpFB_density ACTA2pFAPpPDPNpFB_density
Vessel_density density_stroma_LV CovVes_density_04 NonCovVes_density_04 CovVes_prop_04;
proc sort data=cafmif; by TumorID; run;

data cafGcross;
infile '/udd/nhkma/data/Gcross_CAF_Case_km.csv' lrecl=30000 dlm=',' firstobs=2;
input TumorID ACTA2_ap_10FromT	FAP_ap_10FromT	DP_ap_10FromT	ACTA2_ap_20FromT	FAP_ap_20FromT	DP_ap_20FromT	ACTA2_ap_30FromT	FAP_ap_30FromT	DP_ap_30FromT	
ACTA2_ap_40FromT	FAP_ap_40FromT	DP_ap_40FromT	ACTA2_ap_50FromT	FAP_ap_50FromT	DP_ap_50FromT Gcross20_ACTA2_FB_km	Gcross20_DP_FB_km	Gcross20_FAP_FB_km
;
proc sort data=cafGcross; by TumorID; run;

data stroma_epi_ratio;
infile '/udd/nhkma/data/stroma_epi_ratio_202260408.csv' lrecl=30000 dlm=',' firstobs=2;
input TumorID	str_epi_a_ratio	caf_epi_a_ratio	acta2_epi_a_ratio	fap_epi_a_ratio	dp_epi_a_ratio	str_epi_c_ratio	caf_epi_c_ratio	acta2_epi_c_ratio	fap_epi_c_ratio	dp_epi_c_ratio;
proc sort data=stroma_epi_ratio; by TumorID; run;

/***************combine all data in the lab**********************************/
data nh_all_lab;
merge  cimp_high (in=incimp) braf (in=inbraf) msi (in=inmsi) kras (in=inkras) kras2 (in=inkras2)	fasn (in=infasn) 	cox2all (in=incox2all) 	
p53 (in=inp53) 	ctnnb1 (in=inctnnb1) line1 (in=inline) 	path2 (in=inpath2) 	p21 (in=inp21) 	p27 (in=inp27) 	
p16 (in=inp16) 	ccnd1 (in=inccnd1) ccnd1tma1314 (in=inccnd1tma1314) pik3ca (in=inpik3ca) dnmt3b (in=indnmt3b)
cdk8 (in=incdk8)  cdk8ks (in=incdk8ks) 	sirt1 (in=insirt1) sirt1sub1 (in=insirt1sub1) sirt1sub2 (in=insirt1sub2)  	stmn (in=instmn) pparg (in=inpparg) rps6 (in=inrps6) 
p53new (in=inp53new) p53tma121 (in=inp53tma121) p53tma122 (in=inp53tma122) 
fasnnew (in=infasnnew) fasntma121 (in=infasntma121) fasntma122 (in=infasntma122) 
cox2new (in=incox2new) cox2tma121 (in=incox2tma121) cox2tma122 (in=incox2tma122) ptgs2newtma1314 (in=inptgs2newtma1314) IGF2DMR0 ( in=inIGF2DMR0)
pakt (in=inpakt) paktTMA12sub1 (in=inpaktTMA12sub1) paktTMA12sub2 (in=inpaktTMA12sub2) pten (in=inpten)
CDH1TMA12sub1(in=inCDH1TMA12sub1)CDH1TMA12sub2(in=inCDH1TMA12sub2) CDH1(in=inCDH1)
KDM1(in=inKDM1) KDM1TMA12sub1(in=inKDM1TMA12sub1) KDM1TMA12sub2(in=inKDM1TMA12sub2)
STAT3TMA12sub1(in=inSTAT3TMA12sub1) STAT3TMA12sub2(in=inSTAT3TMA12sub2) stat3(in=instat3) cdx2 (in=incdx2)
PTGER2(in=inPTGER2) PTGER2TMA12sub1(in=inPTGER2TMA12sub1) PTGER2TMA12sub2(in=inPTGER2TMA12sub2) aurka (in=inaurka)
HIF1A(in=inHIF1A) HIF1ATMA12sub1(in=inHIF1ATMA12sub1) HIF1ATMA12sub2(in=inHIF1ATMA12sub2)
EPAS1TMA12sub1(in=inEPAS1TMA12sub1)EPAS1TMA12sub2(in=inEPAS1TMA12sub2) EPAS1(in=inEPAS1)
prkaa (in=inprkaa) MAPK(in=inMAPK) PRKAATMA12sub1(in=inPRKAATMA12sub1) PRKAATMA12sub2(in=inPRKAATMA12sub2)
MAPKTMA12sub1(in=inMAPKTMA12sub1)MAPKTMA12sub2(in=inMAPKTMA12sub2)
CTSB(in=inCTSB) CTSBTMA12sub1(in=inCTSBTMA12sub1) CTSBTMA12sub2(in=inCTSBTMA12sub2) 
MLH1IHC(in=inMLH1IHC) MSH2IHC(in=inMSH2IHC) MGMTIHC(in=inMGMTIHC) cd3(in=incd3) cd8(in=incd8) 
cd45ro(in=incd45ro) foxp3(in=infoxp3) vdrnew (in=invdrnew) vdrtma121 (in=invdrtma121) vdrtma122 (in=invdrtma122) jcvt(in=injcvt)
ctnnb1TMnon12 (in=inctnnb1TMnon12) ctnnb1TM121 (in=inctnnb1TM121) ctnnb1TM122 (in=inctnnb1TM122) ctnnb1TMfullsec (in=inctnnb1TMfullsec) ctnnb1so(in=inctnnb1so) ctnnb1tma1314(in=inctnnb1tma1314)
irs1 (in=inirs1) yap1 (in=inyap1) igf2bp3 (in=inigf2bp3) irs2ale (in=inirs2ale) irs2 (in=inirs2)
mageanon12(in=inmageanon12) mageatma121(in=inmageatma121) mageatma122(in=inmageatma122) 
cmet(in=incmet) hpgd(in=inhpgd) vdrnovo(in=invdrnovo) cd274tma121 (in=incd274tma121) 
cd274tma122 (in=incd274tma122) cd274non12 (in=incd274non12) cd274 (in=incd274) PDCD1LG2 (in=inPDCD1LG2) PDCD1LG2add (in=inPDCD1LG2add)
PDCD1 (in=inPDCD1) ctnnb1normal (in=inctnnb1normal) hgf (in=inhgf)
smo (in=insmo) smotm (in=insmotm) fuso (in=infuso) mir21155 (in=inmir21155) NFKB1 (in=inNFKB1) RELA (in=inRELA) CASR (in=inCASR) neoag (in=inneoag)
HS_LIBRARY_SIZE (in=inHS_LIBRARY_SIZE) Bifido (in=inBifido) 
LC3AB (in=inLC3AB) beclin (in=inbeclin) p62 (in=inp62) tcellif (in=intcellif) tcellnew (in=intcellnew) fusonuc2 (in=infusonuc2) HEcell (in=inHEcell)
MF (in=inMF) MF_index (in=inMF_index) MF_M1M2 (in=inMF_M1M2) HE_Gcross (in=inHE_Gcross) budding (in=inbudding) pks (in=inpks) 
Myeloid (in=inMyeloid) Myeloid_Gcross(in=inMyeloid_Gcross) PTGS2_HPGD (in=inPTGS2_HPGD) NK (in=inNK) NK_Gcross (in=inNK_Gcross) bft (in=inbft) 
vessel (in=invessel) ves_Gcross (in=inves_Gcross) cafmif (in=incafmif) cafGcross (in=incafGcross) stroma_epi_ratio (in=instroma_epi_ratio) drs (in=indrs) ;

by TumorID; if Cohort="N" and (incimp=1 OR inbraf=1 OR inmsi=1 OR inkras=1 OR inkras2=1
or infasn=1 or incox2all=1 or inp53=1 or inctnnb1=1 or inline=1 or inpath2=1 or insirt1=1 or insirt1sub1=1 or insirt1sub2=1 
or inp21=1 or inp27=1 or inp16=1 or inccnd1=1 or inccnd1tma1314=1 or inpik3ca=1 or instmn=1 or indnmt3b=1 or incdk8=1 or incdk8ks=1
or inpparg=1 or inrps6=1 or inp53new=1 or inp53tma121=1 or inp53tma122=1 or infasnnew=1 
or infasntma121=1 or infasntma122=1 or incox2new=1 or incox2tma121=1 or incox2tma122=1 or inptgs2newtma1314=1
or inIGF2DMR0=1 or inpakt=1 or inpaktTMA12sub1=1 or inpaktTMA12sub2=1 or inpten=1
or inCDH1=1 or inCDH1TMA12sub1=1 or inCDH1TMA12sub2=1
or inKDM1=1 or inKDM1TMA12sub1=1 or inKDM1TMA12sub2=1
or inSTAT3TMA12sub1=1 or inSTAT3TMA12sub2=1 or instat3=1 or incdx2=1
or inPTGER2=1 or inPTGER2TMA12sub1=1 or inPTGER2TMA12sub2=1 or inaurka=1
or inHIF1A=1 or inEPAS1=1 or inHIF1ATMA12sub1=1 or inHIF1ATMA12sub2=1 or inEPAS1TMA12sub1=1 or inEPAS1TMA12sub2=1
or inPRKAATMA12sub1=1 or inPRKAATMA12sub2=1 or inMAPKTMA12sub1=1 or inMAPKTMA12sub2=1 or inMAPK=1 or inprkaa=1
or inCTSB=1 or inCTSBTMA12sub1=1 or inCTSBTMA12sub2=1 or inMLH1IHC=1 or inMSH2IHC or inMGMTIHC
or incd3=1 or incd8=1 or incd45ro=1 or infoxp3=1 or injcvt=1 or invdrnew=1 
or invdrtma121=1 or invdrtma122=1 or inctnnb1TMnon12=1 or inctnnb1TM121=1  or inctnnb1TM122=1 
or inctnnb1TMfullsec=1 or inctnnb1so=1 or inctnnb1tma1314=1  or inirs1=1 or inyap1=1 or inigf2bp3=1 or inirs2ale=1 or inirs2=1 
 or inmageanon12=1 or inmageatma121=1 or inmageatma122=1 or incmet=1  or inhpgd=1 or invdrnovo=1
or incd274tma121=1 or incd274tma122=1 or incd274non12=1 or incd274=1 or inPDCD1LG2=1 or inPDCD1LG2add=1 or inPDCD1=1
or inctnnb1normal=1 or inhgf=1 or insmo=1 or insmotm=1 or infuso=1 or inmir21155=1 or inNFKB1=1 or inRELA=1 or inCASR=1 or inneoag=1
or inHS_LIBRARY_SIZE=1 or inBifido=1 
or inLC3AB=1 or inbeclin=1 or inp62=1 or intcellif=1
or intcellnew=1 or infusonuc2=1 or inHEcell=1 or inMF=1 or inMF_index=1 or inMF_M1M2=1 or inHE_Gcross=1 or inbudding=1 or inpks=1
or inMyeloid=1 or inMyeloid_Gcross=1 or inPTGS2_HPGD=1 or inNK=1 or inNK_Gcross=1 or inbft=1 or invessel=1 or inves_Gcross=1 or incafmif=1 or incafGcross=1 or indrs=1);
/**  Using the IN=variables to flag observations from each  lab result file.  We create these variable at this  
 point in the SAS program because the IN=variables are temporary and would not be available after the merge.  **/
if incimp=1 then cimp_rec=1; else cimp_rec=2;
if inmsi=1  then msi_rec=1;  else msi_rec=2;
if inbraf=1 then braf_rec=1; else braf_rec=2;
if inkras=1 then kras_rec=1; else kras_rec=2;
if inkras2=1 then kras2_rec=1; else kras2_rec=2;
if infasn=1 then fasn_rec=1; else fasn_rec=2;
if incox2all=1 then cox2_rec=1; else cox2_rec=2;
if inp53=1 then p53_rec=1; else p53_rec=2;
if inp53new =1 then p53new_rec =1; else p53new_rec =2; 
if inp53tma121=1 then p53tma121_rec=1; else p53tma121_rec=2; 
if inp53tma122=1 then p53tma122_rec=1; else p53tma122_rec=2; 
if infasnnew =1 then fasnnew_rec =1; else fasnnew_rec =2; 
if infasntma121=1 then fasntma121_rec=1; else fasntma121_rec=2; 
if infasntma122=1 then fasntma122_rec=1; else fasntma122_rec=2; 
if incox2new =1 then cox2new_rec =1; else cox2new_rec =2; 
if incox2tma121=1 then cox2tma121_rec=1; else cox2tma121_rec=2; 
if incox2tma122=1 then cox2tma122_rec=1; else cox2tma122_rec=2;
if inptgs2newtma1314=1 then ptgs2newtma1314_rec=1; else ptgs2newtma1314_rec=2; 
if inctnnb1=1 then ctnnb1_rec=1; else ctnnb1_rec=2; 
if inline=1 then line_rec=1; else line_rec=2;
if inpath2=1 then path2_rec=1; else path2_rec=2;  
if inp21=1 then p21_rec=1; else p21_rec=2; 
if inp27=1 then p27_rec=1; else p27_rec=2;
if inp16=1 then p16_rec=1; else p16_rec=2; 
if inccnd1=1 then ccnd1_rec=1; else ccnd1_rec=2; 
if inccnd1tma1314=1 then ccnd1tma1314_rec=1; else ccnd1tma1314_rec=2; 
if inpik3ca=1 then pik3ca_rec=1; else pik3ca_rec=2; 
if instmn=1 then stmn_rec=1; else stmn_rec=2; 
if indnmt3b=1 then dnmt3b_rec=1; else dnmt3b_rec=2;
if incdk8=1 then cdk8_rec=1; else cdk8_rec=2; 
if incdk8ks=1 then cdk8ks_rec=1; else cdk8ks_rec=2; 
if insirt1=1 then sirt1_rec=1; else sirt1_rec=2; 
if insirt1sub1=1 then sirt1sub1_rec=1; else sirt1sub1_rec=2; 
if insirt1sub2=1 then sirt1sub2_rec=1; else sirt1sub2_rec=2; 
if inpparg=1 then pparg_rec=1; else pparg_rec=2; 
if inrps6=1 then rps6_rec=1; else rps6_rec=2; 
if inIGF2DMR0=1 then IGF2DMR0_rec=1; else IGF2DMR0_rec=2;
if inpakt=1 then pakt_rec=1; else pakt_rec=2; 
if inpaktTMA12sub1=1 then paktTMA12sub1_rec=1; else paktTMA12sub1_rec=2; 
if inpaktTMA12sub2=1 then paktTMA12sub2_rec=1; else paktTMA12sub2_rec=2; 
if inpten=1 then pten_rec=1; else pten_rec=2;
if inCDH1TMA12sub1=1 then CDH1TMA12sub1_rec=1; else CDH1TMA12sub1_rec=2;
if inCDH1TMA12sub2=1 then CDH1TMA12sub2_rec=1; else CDH1TMA12sub2_rec=2;
if inCDH1=1 then CDH1_rec=1; else CDH1_rec=2;
if inKDM1=1 then KDM1_rec=1; else KDM1_rec=2;
if inKDM1TMA12sub1=1 then KDM1TMA12sub1_rec=1; else KDM1TMA12sub1_rec=2;
if inKDM1TMA12sub2=1 then KDM1TMA12sub2_rec=1; else KDM1TMA12sub2_rec=2;
if inSTAT3TMA12sub1=1 then STAT3TMA12sub1_rec=1; else STAT3TMA12sub1_rec=2;
if inSTAT3TMA12sub2=1 then STAT3TMA12sub2_rec=1; else STAT3TMA12sub2_rec=2;
if instat3=1 then pstat3_rec=1; else pstat3_rec=2;
if incdx2=1 then cdx2_rec=1; else cdx2_rec=2;
if inPTGER2=1 then PTGER2_rec=1; else PTGER2_rec=2;
if inPTGER2TMA12sub1=1 then PTGER2TMA12sub1_rec=1; else PTGER2TMA12sub1_rec=2;
if inPTGER2TMA12sub2=1 then PTGER2TMA12sub2_rec=1; else PTGER2TMA12sub2_rec=2;
if inaurka=1 then aurka_rec=1; else aurka_rec=2;
if inHIF1A=1 then HIF1A_rec=1; else HIF1A_rec=2;
if inEPAS1=1 then EPAS1_rec=1; else EPAS1_rec=2;
if inHIF1ATMA12sub1=1 then HIF1ATMA12sub1_rec=1; else HIF1ATMA12sub1_rec=2;
if inHIF1ATMA12sub2=1 then HIF1ATMA12sub2_rec=1; else HIF1ATMA12sub2_rec=2;
if inEPAS1TMA12sub1=1 then EPAS1TMA12sub1_rec=1; else EPAS1TMA12sub1_rec=2;
if inEPAS1TMA12sub2=1 then EPAS1TMA12sub2_rec=1; else EPAS1TMA12sub2_rec=2;
if inprkaa=1 then prkaa_rec=1; else prkaa_rec=2;
if inMAPK=1 then MAPK_rec=1; else MAPK_rec=2;
if inPRKAATMA12sub1=1 then PRKAATMA12sub1_rec=1; else PRKAATMA12sub1_rec=2;
if inPRKAATMA12sub2=1 then PRKAATMA12sub2_rec=1; else PRKAATMA12sub2_rec=2;
if inMAPKTMA12sub1=1 then MAPKTMA12sub1_rec=1; else MAPKTMA12sub1_rec=2;
if inMAPKTMA12sub2=1 then MAPKTMA12sub2_rec=1; else MAPKTMA12sub2_rec=2;
if inCTSB=1 then CTSB_rec=1; else CTSB_rec=2;
if inCTSBTMA12sub1=1 then CTSBTMA12sub1_rec=1; else CTSBTMA12sub1_rec=2;
if inCTSBTMA12sub2=1 then CTSBTMA12sub2_rec=1; else CTSBTMA12sub2_rec=2;
if inMLH1IHC=1 then MLH1IHC_rec=1; else MLH1IHC_rec=2;
if inMSH2IHC=1 then MSH2IHC_rec=1; else MSH2IHC_rec=2;
if inMGMTIHC=1 then MGMTIHC_rec=1; else MGMTIHC_rec=2;
if incd3=1 then cd3_rec=1; else cd3_rec=2; 
if incd8=1 then cd8_rec=1; else cd8_rec=2;
if incd45ro=1 then cd45ro_rec=1; else cd45ro_rec=2;
if infoxp3=1 then foxp3_rec=1; else foxp3_rec=2;
if injcvt=1 then jcvt_rec=1; else jcvt_rec=2;
if invdrnew =1 then vdrnew_rec =1; else vdrnew_rec =2; 
if invdrtma121=1 then vdrtma121_rec=1; else vdrtma121_rec=2; 
if invdrtma122=1 then vdrtma122_rec=1; else vdrtma122_rec=2;
if inctnnb1TMnon12=1 then ctnnb1TMnon12_rec=1; else ctnnb1TMnon12_rec=2;
if inctnnb1TM121=1 then ctnnb1TM121_rec=1; else ctnnb1TM121_rec=2;
if inctnnb1TM122=1 then ctnnb1TM122_rec=1; else ctnnb1TM122_rec=2;
if inctnnb1TMfullsec=1 then ctnnb1TMfullsec_rec=1; else ctnnb1TMfullsec_rec=2;
if inctnnb1so=1 then ctnnb1so_rec=1; else ctnnb1so_rec=2;
if inctnnb1tma1314=1 then ctnnb1tma1314_rec=1; else ctnnb1tma1314_rec=2;
if inirs1=1 then irs1_rec=1; else irs1_rec=2;
if inyap1=1 then yap1_rec=1; else yap1_rec=2;
if inigf2bp3=1 then igf2bp3_rec=1; else igf2bp3_rec=2;
if inirs2ale=1 then irs2ale_rec=1; else irs2ale_rec=2; 
if inirs2=1 then irs2_rec=1; else irs2_rec=2; 
if inmageanon12=1 then mageanon12_rec=1; else mageanon12_rec=2;
if inmageatma121=1 then mageatma121_rec=1; else mageatma121_rec=2;
if inmageatma122=1 then mageatma122_rec=1; else mageatma122_rec=2;
if incmet=1 then cmet_rec=1; else cmet_rec=2;
if inhpgd=1 then hpgd_rec=1; else hpgd_rec=2;
if invdrnovo=1 then vdrnovo_rec=1; else vdrnovo_rec=2;
if incd274tma121=1 then cd274tma121_rec=1; else cd274tma121_rec=2;
if incd274tma122=1 then cd274tma122_rec=1; else cd274tma122_rec=2;
if incd274non12=1 then cd274non12_rec=1; else cd274non12_rec=2;
if incd274=1 then cd274_rec=1; else cd274_rec=2;
if inPDCD1LG2=1 then PDCD1LG2_rec=1; else PDCD1LG2_rec=2;
if inPDCD1LG2add=1 then PDCD1LG2add_rec=1; else PDCD1LG2add_rec=2;
if inPDCD1=1 then PDCD1_rec=1; else PDCD1_rec=2;
if inctnnb1normal=1 then ctnnb1normal_rec=1; else ctnnb1normal_rec=2;
if inhgf=1 then hgf_rec=1; else hgf_rec=2;
if insmo=1 then smo_rec=1; else smo_rec=2;
if insmotm=1 then smotm_rec=1; else smotm_rec=2;
if infuso=1 then fuso_rec=1; else fuso_rec=2;
if inmir21155=1 then mir_rec=1; else mir_rec=2;
if inNFKB1=1 then NFKB1_rec=1; else NFKB1_rec=2;
if inRELA=1 then RELA_rec=1; else RELA_rec=2;
if inCASR=1 then CASR_rec=1; else CASR_rec=2;
if inneoag=1 then neoag_rec=1; else neoag_rec=2;
if inHS_LIBRARY_SIZE=1 then HS_LIBRARY_SIZE_rec=1; else HS_LIBRARY_SIZE_rec=2;
if inBifido=1 then Bifido_rec=1; else Bifido_rec=2;
if inLC3AB=1 then LC3AB_rec=1; else LC3AB_rec=2;
if inbeclin=1 then beclin_rec=1; else beclin_rec=2;
if inp62=1 then p62_rec=1; else p62_rec=2;
if intcellif=1 then tcellif_rec=1; else tcellif_rec=2;
if intcellnew=1 then tcellnew_rec=1; else tcellnew_rec=2;
if infusonuc2=1 then fusonuc2_rec=1; else fusonuc2_rec=2;
if inHEcell=1 then HEcell_rec=1; else HEcell_rec=2;
if inMF=1 then MF_rec=1; else MF_rec=2;
if inMF_index=1 then MF_index_rec=1; else MF_index_rec=2;
if inMF_M1M2=1 then MF_M1M2_rec=1; else MF_M1M2_rec=2;
if inHE_Gcross=1 then HE_Gcross_rec=1; else HE_Gcross_rec=2;
if inbudding=1 then budding_rec=1; else budding_rec=2;
if inpks=1 then pks_rec=1; else pks_rec=2;
if inMyeloid=1 then Myeloid_rec=1; else Myeloid_rec=2;
if inMyeloid_Gcross=1 then Myeloid_Gcross_rec=1; else Myeloid_Gcross_rec=2;
if inPTGS2_HPGD=1 then PTGS2_HPGD_rec=1; else PTGS2_HPGD_rec=2;
if inNK=1 then NK_rec=1; else NK_rec=2;
if inNK_Gcross=1 then NK_Gcross_rec=1; else NK_Gcross_rec=2;
if inbft=1 then bft_rec=1; else bft_rec=2;
if invessel=1 then vessel_rec=1; else vessel_rec=2;
if inves_Gcross=1 then ves_Gcross_rec=1; else ves_Gcross_rec=2;
if incafmif=1 then cafmif_rec=1; else cafmif_rec=2;
if incafGcross=1 then cafGcross_rec=1; else cafGcross_rec=2;
if instroma_epi_ratio=1 then stroma_epi_ratio_rec=1; else stroma_epi_ratio_rec=2;
if indrs=1 then drs_rec=1; else drs_rec=2;

proc sort data=nh_all_lab; by id; run;


/*Reading and combining NHS data files. Also creating any new analyses variables. Reading in NHS colorectal CA
disease file. This is done because many variables of interest are not loaded into the tissue tracking programs*/
data nh_colc1; infile nh_colc1 lrecl=147 recfm=d;

input
@1		id		    6.
@7		cd		$   1.
/*@10		cohort	$	    1.*/
@13		icda_qq		    5.
@20		qyr		    2.
@26		mdx1		    2.
@28		ydx1		    2.
@32		conf		    2.
@36		icda		    5.
@43		mdx		    2.
@45		ydx		    2.
@49		mdtdx		    4.
@55		rc_record_id	    6.
@63		recur		    1.
@66             src_backltr         1.
@69		firstdiag	    1.
@72		surgery		    1.
@75		chemo		    1.
@78		fluoru		    1.
@81		leva		    1.
@84		leuco		    1.
@87		irino		    1.
@90		oxal		    1.
@93		capec		    1.
@96		avastin		    1.
@99		erbitux		    1.
@102		vectib		    1.
@105		other		    1.
@108		unknown		    1.
@111		radtherapy	    1.
@114		site		    1.
/*1=ascending
	2=transverse
	3=descending 
	4=sigmoid
	5=rectum 
	6=cecum 
	7=unspecified;
	8=recto-sigmoid */
@117		type		    1.
@120		episub		    1.
@121		carcisub	    1.
@122		nonepisub	    1.
@123		histgr		    1.
@126		dukes		    1.
@129		tstage		    1.
@132		nstage		    1.
@135		mets		    1.
@138		mwork		    1.
@141		nposlym		    2.
@145		ntotlym		    2.
;

label
		id		= 'ID'
		cd		= 'Check Digit'
		/*cohort		= 'Cohort'*/
		icda_qq		= 'Reported ICDA' /*mising in many case of colc7616.013119.cases. therefore we use NHS confirmed case*/
		qyr		= 'Questionnaire cycle year when reported'
		mdx1		= 'Reported month of diagnosis'
		ydx1		= 'Reported year of diagnosis'
		conf		= 'Confirmation Code'
		icda	= 'NHS reviewed and confirmed ICDA code'
		mdx		= 'Confirmed Month of Diagnosis'
		ydx		= 'Confirmed Year of Diagnosis'
		mdtdx		= 'Date of dx months since 1900'
		rc_record_id	= 'REDCap Record ID'
		recur		= 'Possible recurrence'
		firstdiag	= 'Statement describing first diagnosis'
		fluoru		= '5-Fluorouracil (5-FU)'
		leva		= 'Levamisole'
		leuco		= 'Leucovorin'
		irino		= 'Irinotecan (Campostar)'
		oxal		= 'Oxaliplatin (Eloxatin)'
		capec		= 'Capectabine (Xeloda, a pill)'
		avastin		= 'Avastin (Bevacziumab)'
		erbitux		= 'Erbitux (Cetuximab)'
		vectib		= 'Vectibix (Pannitumumab)'
		other		= 'Other (yes/no)'
		unknown		= "Don't know"
		radtherapy	= 'Radiation Therapy'
	    site            = 'Site'
		type            = 'Type'
		episub          = 'Epithelial Subtype'
		carcisub        = 'Carcinoid Subtype'
		nonepisub       = 'Non-Epithelial Subtype'
		histgr		= 'Histologic Grade'
		tstage		= 'Extent of disease through bowel wall'
		nstage		= 'Number of lymph nodes involved'
		mets		= 'Distant metastases'
		mwork		= 'Metastatic Workup'
		nposlym		= 'Number of positive Lymph nodes'
		ntotlym		= 'Number of total lymph nodes examined'
;

/* making ydx 3-digit if >=2000 */
     if ydx in (00) then ydx = 100;
else if ydx in (01) then ydx = 101;
else if ydx in (02) then ydx = 102;
else if ydx in (03) then ydx = 103;
else if ydx in (04) then ydx = 104;
else if ydx in (05) then ydx = 105;
else if ydx in (06) then ydx = 106;
else if ydx in (07) then ydx = 107;
else if ydx in (08) then ydx = 108;
else if ydx in (09) then ydx = 109;
else if ydx in (10) then ydx = 110;
else if ydx in (11) then ydx = 111;
else if ydx in (12) then ydx = 112;
else if ydx in (13) then ydx = 113;
else if ydx in (14) then ydx = 114;
else if ydx in (15) then ydx = 115;
else if ydx in (16) then ydx = 116;
else if ydx in (17) then ydx = 117;
else if ydx in (18) then ydx = 118;
else if ydx in (19) then ydx = 119;
else if ydx in (20) then ydx = 120;

if 0<=ydx1<9 then ydx1=ydx1+100;

if mdx<1 or mdx>12 then mdx=6;
if mdx1<1 or mdx1>12 then mdx1=6;    


/**  Recoding TNM staging for NHS ID 119861 (TumorID=2647).  **/
/**  This ID was NHS coded as in-situ (tstage=5, nstage=1    **/
/**  and mets=1.  The specimen we received was tstage=2,     **/
/**  nstage=1, according to Shuji Ogino                      **/
if id=119861 then tstage=2;
if id=119861 then nstage=1;

/**  Creating site/location variables to match  **/
/**  variables in HPFS dx file.  The SAS code   **/
/**  here is based on Charlie Fuchs' program:   **/
/**  'colon.032805.sas' in '/nhclc0d/cfuchs/'.  **/
/**  See also 9/8/2006 email from Charlie.      **/
colorect = 0;
if icda in (153, 154) then colorect = 1; 

if site in (1, 2, 3, 4, 6) then colon = 1; 
if colon=.                 then colon = 0; 

if site in (5, 8) then rectum = 1; 
if rectum=.       then rectum = 0; 

if site in (1, 2, 6) then prox = 1; 
if prox=.            then prox = 0; 

if site in (3, 4) then distal = 1; 
if distal=.       then distal = 0; 

if (distal = 1 or rectum = 1) then distcr = 1; 
if distcr=.                   then distcr = 0; 

if icda=153  then coldirt = 1; 
if coldirt=. then coldirt = 0; 

if icda=154   then rectdirt = 1; 
if rectdirt=. then rectdirt = 0;

/**  Creating a dichotomous tumor location variable:  **/
/**  PROXIMAL (cecum, ascending, hepatic flexure,     **/
/**  transverse) vs. DISTAL (splenic flexure,         **/
/**  descending, sigmoid, rectosig, rectum).          **/
     if distal = 1 then tumor_location = 1;
else if rectum = 1 then tumor_location = 1;
else if prox   = 1 then tumor_location = 2;
format tumor_location tumlocf.;

proc sort data=nh_colc1 nodupkey; by id; run;

/*id=250502 and 328991 are missing in the file of "colc7616.013119.cases"*/
data nh_colc2; infile '/proj/nhdats/nh_dat_cdx/endpoints/colon/colc7620.021422.cases' lrecl=86 recfm=d;
input @1	id		    6.
@7	cd		$   1.
@8	icda		   5.
@15	mdx1		    2.
@17	ydx1		    2.
@28	qyr		    2.
@46	conf		    2.
@49	nhsdtdx		$   4.
@49	mdx		    2.
@51	ydx		    2.
@54	nhsicda_dx	$   4.
@59	site		    1.
/*1=ascending
	2=transverse
	3=descending 
	4=sigmoid
	5=rectum 
	6=cecum 
	7=unspecified;
	8=recto-sigmoid */
@60	celltype	    1.
@61	subtype		    1.
@62	histgr		    1.
@63	dukes		    1.
@64	tstage              1.
@65	nstage              1.
@66	mets                1.
@67	mwork               1.
@82	mdtdx		    4.;
label	cd		= 'Check digit'
	icda		= 'icda from qq by default 153'
	mdx1		= 'default month of diagnosis from qq bubble'
	ydx1		= 'default year of diagnosis from qq bubble'
	qyr		= 'questionnaire year'
	nhsdtdx		= 'NHS confirmed Mo-Yr dx'
	mdx		= 'NHS confirmed month dx'
	ydx		= 'NHS confirmed year dx'
	nhsicda_dx	= 'NHS confirmed icda'
	histgr		= 'Histologic Grade'
	mdtdx		= 'Date of dx in months since 1900';

/* making ydx 3-digit if >=2000 */
     if ydx in (00) then ydx = 100;
else if ydx in (01) then ydx = 101;
else if ydx in (02) then ydx = 102;
else if ydx in (03) then ydx = 103;
else if ydx in (04) then ydx = 104;
else if ydx in (05) then ydx = 105;
else if ydx in (06) then ydx = 106;
else if ydx in (07) then ydx = 107;
else if ydx in (08) then ydx = 108;
else if ydx in (09) then ydx = 109;
else if ydx in (10) then ydx = 110;
else if ydx in (11) then ydx = 111;
else if ydx in (12) then ydx = 112;
else if ydx in (13) then ydx = 113;
else if ydx in (14) then ydx = 114;
else if ydx in (15) then ydx = 115;
else if ydx in (16) then ydx = 116;
else if ydx in (17) then ydx = 117;
else if ydx in (18) then ydx = 118;
else if ydx in (19) then ydx = 119;
else if ydx in (20) then ydx = 120;

if 0<=ydx1<9 then ydx1=ydx1+100;

if mdx<1 or mdx>12 then mdx=6;
if mdx1<1 or mdx1>12 then mdx1=6;    


/**  Recoding TNM staging for NHS ID 119861 (TumorID=2647).  **/
/**  This ID was NHS coded as in-situ (tstage=5, nstage=1    **/
/**  and mets=1.  The specimen we received was tstage=2,     **/
/**  nstage=1, according to Shuji Ogino                      **/
if id=119861 then tstage=2;
if id=119861 then nstage=1;

/**  Creating site/location variables to match  **/
/**  variables in HPFS dx file.  The SAS code   **/
/**  here is based on Charlie Fuchs' program:   **/
/**  'colon.032805.sas' in '/nhclc0d/cfuchs/'.  **/
/**  See also 9/8/2006 email from Charlie.      **/
colorect = 0;
if icda in (153, 154) then colorect = 1; 

if site in (1, 2, 3, 4, 6) then colon = 1; 
if colon=.                 then colon = 0; 

if site in (5, 8) then rectum = 1; 
if rectum=.       then rectum = 0; 

if site in (1, 2, 6) then prox = 1; 
if prox=.            then prox = 0; 

if site in (3, 4) then distal = 1; 
if distal=.       then distal = 0; 

if (distal = 1 or rectum = 1) then distcr = 1; 
if distcr=.                   then distcr = 0; 

if icda=153  then coldirt = 1; 
if coldirt=. then coldirt = 0; 

if icda=154   then rectdirt = 1; 
if rectdirt=. then rectdirt = 0;

/**  Creating a dichotomous tumor location variable:  **/
/**  PROXIMAL (cecum, ascending, hepatic flexure,     **/
/**  transverse) vs. DISTAL (splenic flexure,         **/
/**  descending, sigmoid, rectosig, rectum).          **/
     if distal = 1 then tumor_location = 1;
else if rectum = 1 then tumor_location = 1;
else if prox   = 1 then tumor_location = 2;
format tumor_location tumlocf.;

if id ne 250502 and id ne 328991 then delete; /*missing in 'colc7616.013119.cases'*/
proc sort data=nh_colc2 nodupkey; by id; run;

data nh_colc3; merge nh_colc1 nh_colc2; by id; run;
proc sort data=nh_colc3 nodupkey; by id; run;

/****************************************************************/
/** Reading in NHS derived data.                               **/
/*including height, weight, year of birth, smoking and pck-year of smoking*/ 
/****************************************************************/

%der7620 (keep=mobf yobf bdt 
irt76 irt78 irt80 irt82 irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14
smkdr76 smkdr78  smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 
smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14
pkyr76 pkyr78 pkyr80 pkyr82 pkyr84 pkyr86 pkyr88 pkyr90 pkyr92 pkyr94 pkyr96 pkyr98 pkyr00 pkyr02 pkyr04 pkyr06 pkyr08 pkyr10 pkyr12 pkyr14);
if mobf<=0 or mobf>12 then mobf=6;
if yobf>0 then bdt=12*yobf+mobf;
if yobf=. then delete;
run; 

%n767880 (keep=ht76 wt76 wt78 wt80);
%nur82 (keep=wt82);
%nur84 (keep=wt84);
%nur86 (keep=wt86);
%nur88 (keep=wt88);
%nur90 (keep=wt90);
%nur92 (keep=wt92);
%nur94 (keep=wt94);
%nur96 (keep=wt96);
%nur98 (keep=wt98);
%nur00 (keep=wt00);
%nur02 (keep=wt02);
%nur04 (keep=wt04);
%nur06 (keep=wt06);
%nur08 (keep=wt08);
%nur10 (keep=wt10);
%nur12 (keep=wt12);
%nur14 (keep=wt14);

data nhwt;
merge n767880 nur82 nur84 nur86 nur88 nur90 nur92 nur94 nur96 nur98 
nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14;
by id;
run;
proc sort nodupkey; by id; run;

data der7620;
merge der7620 nhwt;
by id;
run;
proc sort nodupkey; by id; run;

proc datasets nolist;
delete n767880 nur82 nur84 nur86 nur88 nur90 nur92 nur94 nur96 nur98 
nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nhwt;
run;



/****************************************************************/
/** Reading in NHS death data file.                            **/
/****************************************************************/
%deadff(file=/proj/nhdats/nh_dat_cdx/deaths/deadff.current.nhs1,
            keep=dcicda yod mod yodx modx dtdeath dtdth deadmonth qyr nhsicda enhsicda); 
dtdeath=deadmonth;
dtdth=deadmonth;
run;

proc sort nodupkey; by id; run;


%act8614;                                                                                    
 /*no activity was asked in 1990 and 2002*/
 /*Mets was not calculated in 2006 because it was brief question on activity*/
 /*Mets was not calculated in 2010 because it was brief question on activity*/
       actc90 = .;
       act90m = .;
       actc02 = .;
       act02m = .;
	   actc06 = .;
	   act06m = .;
	   actc10 = .;
	   act10m = .;

if act86m<0 or act86m in (998,999) then act86m=.;        
if act88m<0 or act88m in (998,999) then act88m=.;
if act92m<0 or act92m in (998,999) then act92m=.;
if act94m<0 or act94m in (998,999) then act94m=.;
if act96m<0 or act96m in (998,999) then act96m=.;
if act98m<0 or act98m in (998,999) then act98m=.;
if act00m<0 or act00m in (998,999) then act00m=.;
if act04m<0 or act04m in (998,999) then act04m=.;
if act08m<0 or act08m in (998,999) then act08m=.;
if act12m<0 or act12m in (998,999) then act12m=.;
if act14m<0 or act14m in (998,999) then act14m=.;
       run;


/**************************************************************************/
/** Bringing in the NHS family history data.                             **/
/**************************************************************************/

/**NHS FH codes 1. Bringing in the NHS family history of first-degree relatives data from 1982 to 2012.  **/
/* hxclc-family history of colon cancer but not family history of colon */
/*cancer in fisrt-degree relatives was not asked in 1990, 1994, 1998, 2002, 2006, 2010, 2012 2014*/
%nur82(keep=id mclc82 fclc82 sclc82 bclc82);run;
%nur88(keep=id mclc88 fclc88 sclc88 bclc88);run;
%nur92(keep=id mcolc92 fcolc92 scolc92);run;
%nur96(keep=id pclc96 sclc196 sclc296 hxclc96); run;
%nur00(keep=id pclc00 sclc100 sclc200);run;
%nur04(keep=id pclc04 sclc104 sclc204);run;
%nur08(keep=id sclc108 sclc208);run;                                           

data nhfamily;
merge nur82 (in=fam82) nur88 nur92 nur96 nur00 nur04 nur08;
by id;
if fam82 then base_famhx = 1;

***NHS Family history of colorectal cancer, 1982***;
camom82 = 0;
if mclc82 = 1 then camom82 = 1;
cadad82 = 0;
if fclc82 = 1 then cadad82 = 1;
casis82 = 0;
if sclc82 = 1 then casis82 = 1;
cabro82 = 0;
if bclc82 = 1 then cabro82 = 1;
casib82 = 0;
if casis82 = 1 or cabro82 = 1 then casib82 = 1;

cafam82 = 0;
     if sum(camom82, cadad82, casis82, cabro82) ge 1 then cafam82 = 1;

cafam282 = 0;
     if sum(camom82, cadad82, casis82, cabro82) eq 1 then cafam282 = 1;
else if sum(camom82, cadad82, casis82, cabro82) gt 1 then cafam282 = 2;


***NHS Family history of colorectal cancer, 1988***;
cafam88 = 0;
if cafam82 = 1 or mclc88 = 1 or fclc88 = 1 or sclc88 = 1 or bclc88 = 1 then cafam88 = 1;

camom88 = 0;
if camom82 = 1 or mclc88 = 1 then camom88 = 1;
cadad88 = 0;
if cadad82 = 1 or fclc88 = 1 then cadad88 = 1;
casis88 = 0;
if casis82 = 1 or sclc88 = 1 then casis88 = 1;
cabro88 = 0;
if cabro82 = 1 or bclc88 = 1 then cabro88 = 1;
casib88 = 0;
if casis88 = 1 or cabro88 = 1 then casib88 = 1;

cafam288 = 0;
     if sum (camom88, cadad88, casis88, cabro88) gt 1 or cafam282 gt 1 then cafam288 = 2;
else if sum (camom88, cadad88, casis88, cabro88) eq 1 or cafam282 eq 1 then cafam288 = 1;



***NHS Family history of colorectal cancer, 1992***;

cafam92 = 0;
if cafam88 = 1 or mcolc92 = 1 or fcolc92 = 1 or scolc92 = 1 then cafam92 = 1;

camom92 = 0;
if camom88 = 1 or mcolc92 = 1 then camom92 = 1;
cadad92 = 0;
if cadad88 = 1 or fcolc92 = 1 then cadad92 = 1;
casib92 = 0;
if cabro88 = 1 or casis88 = 1  or scolc92 = 1 then casib92 = 1;

cafam292 = 0;
     if sum(camom92, cadad92, casib92) gt 1 or cafam288 gt 1 then cafam292 = 2;
else if sum(camom92, cadad92, casib92) eq 1 or cafam288 eq 1 then cafam292 = 1;



***NHS Family history of colorectal cancer, 1996***;
cafam96=0;
   if cafam92=1 or pclc96 = 1 or sclc196 = 1 or sclc296 = 1 then cafam96=1;

cafam296 = 0;
     if sum(pclc96, sclc196, sclc296) > 1 or cafam292 > 1 then cafam296 = 2;
else if sum(pclc96, sclc196, sclc296) = 1 or cafam292 = 1 then cafam296 = 1;



***NHS Family history of colorectal cancer, 2000***;
   clc00=0;
   if pclc00=1 or sclc100 =1 or sclc200=1 then clc00=1;
   if pclc00=1 then parent00=1; else parent00=0;
   if sclc100=1 then sib001=1; else sib001=0;
   if sclc200=1 then sib002=1; else sib002=0;
   relcount00= sum(parent00, sib001, sib002);
   cafam200a=0;
   if relcount00 eq 1 then cafam200a=1;
   if relcount00 ge 2 then cafam200a=2; 

   cafam00=0;
   if cafam96=1 or clc00=1 then cafam00=1;

   cafam200 = 0 ;
   if cafam200a=1 or (cafam296=1 and cafam200a ne 2) then cafam200=1;
   if cafam200a=2 or cafam296=2 then cafam200=2;


***NHS Family history of colorectal cancer, 2004***;
   clc04=0;
   if pclc04=1 or sclc104 =1 or sclc204=1 then clc04=1;
   if pclc04=1 then parent04=1; else parent04=0;
   if sclc104=1 then sib041=1; else sib041=0;
   if sclc204=1 then sib042=1; else sib042=0;
   relcount04= sum(parent04, sib041, sib042);
   cafam204a=0;
   if relcount04 eq 1 then cafam204a=1;
   if relcount04 ge 2 then cafam204a=2; 

   cafam04=0;
   if cafam00=1 or clc04=1 then cafam04=1;

   cafam204 = 0 ;
   if cafam204a=1 or (cafam200=1 and cafam204a ne 2) then cafam204=1;
   if cafam204a=2 or cafam200=2 then cafam204=2;

***NHS Family history of colorectal cancer, 2008***;        
  clc08=0;
   if sclc108 =1 or sclc208=1 then clc08=1;
   if sclc108=1 then sib081=1; else sib081=0;
   if sclc208=1 then sib082=1; else sib082=0;
   relcount08= sum(sib081, sib082);
   cafam208a=0;
   if relcount08 eq 1 then cafam208a=1;
   if relcount08 eq 2 then cafam208a=2; 

   cafam08=0;
   if cafam04=1 or clc08=1 then cafam08=1;

  cafam208 = 0 ;
   if cafam208a=1 or (cafam204=1 and cafam208a ne 2) then cafam208=1;
   if cafam208a=2 or cafam204=2 then cafam208=2;

keep id base_famhx cafam282 cafam288 cafam292 cafam296 cafam200 cafam204 cafam208;
run;

proc datasets nolist; delete nur82 nur88 nur92 nur96 nur00 nur04 nur08; run;



/**********************************************************************************************************
-Aspirin (no aspirin info in 1986 in NHS, no tablets/week info until 1992 in HPFS
          NHS 1980-2012, HPFS 1986-2012) 
-Prediagnosis
   predxanyasp: immediately before the time of diagnose, any use of aspirin, 1=non-user, 2=any user
                (regularly use any amount of aspirin)
              NHS predxanyasp
             HPFS predxanyasp (this is the same definition as predxregasp)
   predxaspwk: immediately before the time of diagnosis, aspirin itnake, tablets/week, continuous
              NHS predxaspwk
              HPFS predxaspwk
   predxaspwkav: immediately before the time of diagnosis, using cumulative average of intake tabs/wk
              NHS predxaspwkav
             HPFS predxaspwkav 
   predxregasp: immedeately before the time of diagnosis, regular use, 1=non-user, 2=regular user
                (Definition: at least 2 tabs/week in NHS, at least 2 times/week in HPFS)
              NHS predxregasp
             HPFS predxregasp 
   predxregaspav: immedeately before the time of diagnosis, using cumulative average of intake                
              NHS predxregaspav
             HPFS **cumulative average is not calculated for regular use in HPFS 
                  because regular use is defined as frequency**  

-Postdiagnosis
    postdxanyasp: immediately after the time of diagnose, any use of aspirin, 1=non-user, 2=any user
              NHS: postdxanyasp
             HPFS: postdxanyasp (this is the same definition as postdxregasp)
    postdxaspwk: immedeately after the time of diagnosis, aspirin intake, tablets/week, continuous 
              NHS postdxaspwk
             HPFS postdxaspwk 
    postdxregasp: immedeately after the time of diagnosis, regular use, 1=non-user, 2=regular user
              NHS postdxregasp
             HPFS postdxregasp 
    postmonth: Time until first aspirin assessment in month, continuous
              NHS postmonth
             HPFS postmonth 
 
-Duration                                                                                              
    regaspdur: years of regular use, continuous (Duration of 1986-88 was imputed by 1984-86 in NHS)
               NHS regaspdur80 regaspdur82 regaspdur84 regaspdur86 regaspdur88 regaspdur90 regaspdur92 
                   regaspdur94 regaspdur96 regaspdur98 regaspdur00 regaspdur02 regaspdur04 regaspdur06 regaspdur08 regaspdur10 
              HPFS regaspdur86 regaspdur88 regaspdur90 regaspdur92 regaspdur94 regaspdur96 
                   regaspdur98 regaspdur00 regaspdur02 regaspdur04 regaspdur06 regaspdur08 regaspdur10 

-NSAIDs (NHS 1990-2012, HPFS 1986-2012)
   -prediagnosis: immediately before the time of diagnose, any use of NSAIDs other than aspirin.
                  1=non-user, 2=any user (regularly use any amount of NSAIDs)
              NHS predxanyibu
             HPFS predxanyibu
   -Postdiagnosis: immediately after the time of diagnose, any use of NSAIDs other than aspirin.
                   1=non-user, 2=any user
              NHS postdxanyibu
             HPFS postdxanyibu

**********************************************************************************************************/


/****************/
/* Read aspirin */
/****************/


/*****************************************************
aspu80: 0=non-user, 1=current user, 9=unknown status
aspq80: status and quantity of aspirin use 80
   1.nonuser, never reported use;
   2.nonuser, past report of use;
   3.current user, 1-2 tablets/wk;
   4.current user, 3-5 tablets/wk;
   5.current user, 6-14 tablets/wk;
   6.current user, 15+ tablets/wk;
   7.current user, unknown qty;
   8.unknown if past or current user;
   9.unknown if ever use
aspqc80: cumulative average aspirin tablets/wk 80
   0.nonuser, never reported use;
   98.past or current user, unknown qty;
   99.missing status of use
aspy80: years of aspirin use, continuous data 80
   0.nonuser, never reported use;
   96.unknown 1980 years;
   97.unknown 1980 status;
   98.unknown years;
   99.unknown status
aspyg80: years of aspirin use, categorical data 80
    1.nonuser, never reported use;
    2.past user, < 5 yrs of use;
    3.past user, 5-9 yrs;
    4.past user, 10-14 yrs;
    5. past user, 15-19 yrs;
    6.past user, 20-24 yrs;
    7.past user, 25+ yrs;
    8.curr user, < 5 yrs of use;
    9.curr user, 5-9 yrs;
   10.curr user, 10-14 yrs;
   11.curr user, 15-19 yrs;
   12.curr user, 20-24 yrs;
   13.curr user, 25+ yrs;
   96.unknown 1980 years;
   97.unknown 1980 status;
   98.unknown years;
   99.unknown status
*******************************************************/

%meds8016(keep=aspu80 aspq80 aspqc80 aspy80 aspwk80 reguasp80 adur80 anyasp80);
aspwk80=aspqc80; /*1980 intake asp/week*/
if aspqc80 in (.,98,99) then aspwk80=.;  
if aspqc80=0  and  aspu80=1 then aspwk80=.;
if aspqc80>0  and  aspu80=0 then aspwk80=.;

/*1980 regurar use of asp*/
 if  0<=aspwk80<2 then reguasp80=1; /*nonuser*/
 else if aspwk80>=2 then reguasp80=2; /*user*/
 else if aspwk80=. then reguasp80=.;

/*set unknown duration to missing*/ 
 if aspy80 in (.,96,97,98,99) then adur80=.; 
 else adur80=aspy80;

 /*anyasp*/
 if  aspu80=1 then anyasp80=2;
 else anyasp80=1;   
 run;

 /**********************************************************
1982 data
asp82: currently taking aspirin at least once per week?
       1 = yes
uspr82: if so number of asp per week.
        1=1-3, 2=4-6, 3=7-14, 4=15 or more
        the only inconsistent information is that 1968 obs
        had asp82=1 but uspr=0, they were defined as missing
************************************************************/
%nur82(keep=asp82 uspr82 uspr82q uspr82m aspwk82 aspmo82 reguasp82 anyasp82);
 if asp82=0 and uspr82=0 then do; uspr82q=1; uspr82m=0; end;
 else if asp82=1 and uspr82=0 then do; uspr82q=.; uspr82m=.; end;
 else if asp82=1 and uspr82>0 then do;
 /**Categorizing number of asp/week into quintiles then setting = to median number
 of tablets per category*/
   uspr82q=uspr82+1;
       if uspr82q=2 then uspr82m=2;
       if uspr82q=3 then uspr82m=5;
       if uspr82q=4 then uspr82m=11;
       if uspr82q=5 then uspr82m=30;
    end;
 aspwk82=uspr82m; /*1982 intake asp/week*/;
 aspmo82 = uspr82m * 4.3; /*1982 intake asp/month*/

 /*1982 regurar use of asp*/
 if  0<=aspwk82<2 then reguasp82=1; /*nonuser*/
 else if aspwk82>=2 then reguasp82=2; /*user*/
 else if aspwk82=. then reguasp82=.;

   if asp82=1 then anyasp82=2;
   else anyasp82=1;

run;

/***********************************************************************
1984 data
aspd84: how many days/month do you take aspirin?
        0 = blank, 1=0, 2=1-4days, 3=5-14days, 4=15-21days, 5=22 or more
nasp84: How many aspirin/day?
        0=blank, 1=never, 2=1, 3=2, 4=3-4, 5=5-6, 6=7or more, 7=pt 
************************************************************************/
%nur84(keep=aspd84 nasp84 aspwk84 aspmo84 reguasp84 anyasp84);
 /*set inconsistent info to missing*/
 if 1<aspd84<6 and nasp84=1 then do; aspd84=0; nasp84=0; end;
 if aspd84=1 and 1<nasp84<7 then do; aspd84=0; nasp84=0; end;

 /*set each group to the median number of days of asp use**/
 if aspd84=1 then aspd=0;
 else if aspd84=2 then aspd=2.5;
 else if aspd84=3 then aspd=9.5;
 else if aspd84=4 then aspd=18;
 else if aspd84=5 then aspd=30;
 else if aspd84 in (.,0,6) then aspd=.;

 /**median number of asp consumed in each group**/
 if nasp84=1 then nasp=0;
 else if nasp84=2 then nasp=1;
 else if nasp84=3 then nasp=2;
 else if nasp84=4 then nasp=3.5;
 else if nasp84=5 then nasp=5.5;
 else if nasp84=6 then nasp =9;
 else if nasp84 in (.,0,7) then nasp=.;

 aspmo84=aspd*nasp; /*1984 intake asp/month*/

/** translate the continous intake from asp/month to asp/week **/
 aspwk84=aspmo84/4.3;  /*1984 intake asp/week*/

 /*1984 regural use of asp*/
 if  0<=aspwk84<2 then reguasp84=1;  /*nonuser*/
 else if aspwk84>=2 then reguasp84=2; /*user*/
 else if aspwk84=. then reguasp84=.;

   if aspd84=1 or nasp84=1 then anyasp84=1;
   else if aspd84 in (2,3,4,5) then anyasp84=2;
   else anyasp84=.;

run;

/***********************************************************************
1988 data
aspd88: how many days/month do you take aspirin?
        0 = blank, 1=0, 2=1-4days, 3=5-14days, 4=15-21days, 5=22 or more
nasp88: How many aspirin/day?
        0=blank, 1=never, 2=1, 3=2, 4=3-4, 5=5-6, 6=7or more, 7=pt 
************************************************************************/
%nur88(keep=aspd88 nasp88 aspwk88 aspmo88 reguasp88 anyasp88);
 /*set inconsistent info to missing*/
 if 1<aspd88<6 and nasp88=1 then do; aspd88=0; nasp88=0; end;
 if aspd88=1 and 1<nasp88<7 then do; aspd88=0; nasp88=0; end;
 
  if aspd88=1 or nasp88=1 then anyasp88=1;
   else if aspd88 in (2,3,4,5) then anyasp88=2;
   else anyasp88=.;

 /*set each group to the median number of days of asp use**/
 if aspd88=1 then aspd=0;
 else if aspd88=2 then aspd=2.5;
 else if aspd88=3 then aspd=9.5;
 else if aspd88=4 then aspd=18;
 else if aspd88=5 then aspd=30;
 else if aspd88 in (.,0,6) then aspd=.;

 /**median number of asp consumed in each group**/
 if nasp88=1 then nasp=0;
 else if nasp88=2 then nasp=1;
 else if nasp88=3 then nasp=2;
 else if nasp88=4 then nasp=3.5;
 else if nasp88=5 then nasp=5.5;
 else if nasp88=6 then nasp=9;
 else if nasp88 in (.,0,7) then nasp=.;
 aspmo88=aspd*nasp; /*1988 intake asp/month**/

 /** translate the continuous intake from asp/month to asp/week **/
 aspwk88=aspmo88/4.3; /*1988 intake asp/week*/

 /*1988 regural use of asp*/
 if  0<=aspwk88<2 then reguasp88=1; /*nonuser*/
 else if aspwk88>=2 then reguasp88=2; /*user*/
 else if aspwk88=. then reguasp88=.;
  
run;

/***********************************************************************
1990 data
asp90: Average number of days/month do you take aspirin?
       1=None, 2=1-4 days, 3=5-14 days, 4=15-21 days, 5=22 or more, 6=pt
ibu90: 1=None, 2=1-4 days, 3=5-14 days, 4=15-21 days, 5=22 or more, 6=pt
tyl90: 1=None, 2=1-4 days, 3=5-14 days, 4=15-21 days, 5=22 or more, 6=pt
************************************************************************/
/*Separately asked for acetaminophen and nsaids. 
Based on /proj/nhclcs/nhclc0d/achan/cvd/ NSAIDPT.sas, there very few participants 
who are truly missing -skipped all three analgesic classes.  Most answered one of 
the analgesic classes and skipped the others (96%) - thus, will assume that these 
are non-users*/
%nur90 (keep=asp90 aspmo90 aspwk90 aspdm90 aspdd90 allmiss90 reguasp90 anyasp90
             ibumo90 ibuwk90 tyl90 tylmo90 tylwk90 ibudm90 tyldm90 ibudd90 tyldd90
             batch90 regibu90 regtyl90);
 if asp90 in (1,2,3,4,5) and ibu90 in (1,2,3,4,5) and tyl90 in (1,2,3,4,5) then allmiss90=0; 
 else if asp90 in (1,2,3,4,5) and ibu90 in (1,2,3,4,5) and tyl90 in (.,0,6) then allmiss90=1;
 else if asp90 in (1,2,3,4,5) and ibu90 in (.,0,6) and tyl90 in (1,2,3,4,5) then allmiss90=1;
 else if asp90 in (.,0,6) and ibu90 in (1,2,3,4,5) and tyl90 in (1,2,3,4,5) then allmiss90=1;
 else if asp90 in (1,2,3,4,5) and ibu90 in (.,0,6) and tyl90 in (.,0,6) then allmiss90=2;
 else if asp90 in (.,0,6) and ibu90 in (1,2,3,4,5) and tyl90 in (.,0,6) then allmiss90=2;
 else if asp90 in (.,0,6) and ibu90 in (.,0,6) and tyl90 in (1,2,3,4,5) then allmiss90=2;   
 else if asp90 in (.,0,6) and ibu90 in (.,0,6) and tyl90 in (.,0,6) then allmiss90=3;

 /*Days per month in categories*/
 if asp90=1 then aspdm90=1;
 else if asp90=2 then aspdm90=2;
 else if asp90=3 then aspdm90=3;
 else if asp90=4 then aspdm90=4;
 else if asp90=5 then aspdm90=5;
 else if asp90 in (.,0,6) and allmiss90 in (1,2) then aspdm90=1; /*answered one of the analgesic classes, so assume non-user for this one*/
 else if asp90 in (.,0,6) and allmiss90=3 then aspdm90=.; /*if truly missing*/


  if ibu90=1 then ibudm90=1;
else if ibu90=2 then ibudm90=2;
else if ibu90=3 then ibudm90=3;
else if ibu90=4 then ibudm90=4;
else if ibu90=5 then ibudm90=5;
else if ibu90 in (.,0,6) and allmiss90 in (1,2) then ibudm90=1; /*answered one of the analgesic classes, so assume non-user for this one*/
else if ibu90 in (.,0,6) and allmiss90=3 then ibudm90=.; /*if truly missing*/


  if tyl90=1 then tyldm90=1;
else if tyl90=2 then tyldm90=2;
else if tyl90=3 then tyldm90=3;
else if tyl90=4 then tyldm90=4;
else if tyl90=5 then tyldm90=5;
else if tyl90 in (.,0,6) and allmiss90 in (1,2) then tyldm90=1; /*answered one of the analgesic classes, so assume non-user for this one*/
else if tyl90 in (.,0,6) and allmiss90=3 then tyldm90=.; /*if truly missing*/


 /**set each group to the median number of days of use**/
 if asp90=1 then aspdd90=0;
 else if asp90=2 then aspdd90=2.5;
 else if asp90=3 then aspdd90=9.5;
 else if asp90=4 then aspdd90=18;
 else if asp90=5 then aspdd90=22;
 else if asp90 in (.,0,6) and allmiss90 in (1,2) then aspdd90=0; /*answered one of the analgesic classes, so assume non-user for this one*/
 else if asp90 in (.,0,6) and allmiss90=3 then aspdd90=.; /*if truly missing*/


  if ibu90=1 then ibudd90=0;
else if ibu90=2 then ibudd90=2.5;
else if ibu90=3 then ibudd90=9.5;
else if ibu90=4 then ibudd90=18;
else if ibu90=5 then ibudd90=22;
else if ibu90 in (.,0,6) and allmiss90 in (1,2) then ibudd90=0; /*answered one of the analgesic classes, so assume non-user for this one*/
else if ibu90 in (.,0,6) and allmiss90=3 then ibudd90=.; /*if truly missing*/


  if tyl90=1 then tyldd90=0;
else if tyl90=2 then tyldd90=2.5;
else if tyl90=3 then tyldd90=9.5;
else if tyl90=4 then tyldd90=18;
else if tyl90=5 then tyldd90=22;
else if tyl90 in (.,0,6) and allmiss90 in (1,2) then tyldd90=0; /*answered one of the analgesic classes, so assume non-user for this one*/
else if tyl90 in (.,0,6) and allmiss90=3 then tyldd90=.; /*if truly missing*/


 /**Assume each day of use is at least 1 tablet/day for aspirin and 2 tablets/day 
 for NSAIDs/tylenol based on Curhan's supplementary questionnaire**/
 aspmo90=aspdd90*1; /*1990 intake asp/month**/
 ibumo90=ibudd90*2;
 tylmo90=tyldd90*2;


 /**translate asp/month to asp/week ***/
   aspwk90=aspmo90/4.3; /*1990 intake asp/week*/
   ibuwk90=ibumo90/4.3;
   tylwk90=tylmo90/4.3;

 /*1990 regural use of asp*/
 if  0<=aspwk90<2 then reguasp90=1; /*nonuser*/
 else if aspwk90>=2 then reguasp90=2; /*user*/
 else if aspwk90=. then reguasp90=.;
  
 if asp90 in (1) then anyasp90=1;
   else if asp90 in (2,3,4,5) then anyasp90=2;
else if asp90 in (.,0,6) and allmiss90 in (1,2) then anyasp90=1; /*answered one of the analgesic classes, so assume non-user for this one*/
   else anyasp90=.;

   if ibu90 in (1) then regibu90=1; 
   else if ibu90 in (2,3,4,5) then regibu90=2 /*regular user is 2 or more per week*/;
else if ibu90 in (.,0,6) and allmiss90 in (1,2) then regibu90=1; /*answered one of the analgesic classes, so assume non-user for this one*/   
   else regibu90=.;

if tyl90 in (1) then regtyl90=1;
   else if tyl90 in (2,3,4,5) then regtyl90=2; /*regular user is 2 or more per week*/
else if tyl90 in (.,0,6) and allmiss90 in (1,2) then regtyl90=1; /*answered one of the analgesic classes, so assume non-user for this one*/   
else regtyl90=.;

run;


/***********************************************************************
1992 data
asp92: Average number of days/month do you take aspirin? 
       Separately asked for acetaminophen and nsaids.  
       1=None, 2=1-4 days, 3=5-14 days, 4=15-21 days, 5=22 or more, 6=pt
ibu92: 1=None, 2=1-4 days, 3=5-14 days, 4=15-21 days, 5=22 or more, 6=pt
tyl92: 1=None, 2=1-4 days, 3=5-14 days, 4=15-21 days, 5=22 or more, 6=pt

************************************************************************/
/*According to 1990, we assume the nurses who answered at least one and skip
others, as non-users for those skipped analgesic classes */
%nur92 (keep=asp92 aspwk92 aspmo92 aspdm92 aspdd92 ibu92 tyl92 allmiss92 reguasp92 anyasp92
             ibumo92 ibuwk92 tylmo92 tylwk92
             ibudm92 tyldm92 ibudd92 tyldd92 regibu92 regtyl92);
 if asp92 in (1,2,3,4,5) and ibu92 in (1,2,3,4,5) and tyl92 in (1,2,3,4,5) then allmiss92=0; 
 else if asp92 in (1,2,3,4,5) and ibu92 in (1,2,3,4,5) and tyl92 in (.,0,6) then allmiss92=1;
 else if asp92 in (1,2,3,4,5) and ibu92 in (.,0,6) and tyl92 in (1,2,3,4,5) then allmiss92=1;
 else if asp92 in (.,0,6) and ibu92 in (1,2,3,4,5) and tyl92 in (1,2,3,4,5) then allmiss92=1;
 else if asp92 in (1,2,3,4,5) and ibu92 in (.,0,6) and tyl92 in (.,0,6) then allmiss92=2;
 else if asp92 in (.,0,6) and ibu92 in (1,2,3,4,5) and tyl92 in (.,0,6) then allmiss92=2;
 else if asp92 in (.,0,6) and ibu92 in (.,0,6) and tyl92 in (1,2,3,4,5) then allmiss92=2;   
 else if asp92 in (.,0,6) and ibu92 in (.,0,6) and tyl92 in (.,0,6) then allmiss92=3;

 /*Days per month in categories*/
 if asp92=1 then aspdm92=1;
 else if asp92=2 then aspdm92=2;
 else if asp92=3 then aspdm92=3;
 else if asp92=4 then aspdm92=4;
 else if asp92=5 then aspdm92=5;
 else if asp92 in (.,0,6) and allmiss92 in (1,2) then aspdm92=1; /*answered one of the analgesic classes, so assume non-user for this one*/
 else if asp92 in (.,0,6) and allmiss92=3 then aspdm92=.; /*if truly missing*/


  if ibu92=1 then ibudm92=1;
else if ibu92=2 then ibudm92=2;
else if ibu92=3 then ibudm92=3;
else if ibu92=4 then ibudm92=4;
else if ibu92=5 then ibudm92=5;
else if ibu92 in (.,0,6) and allmiss92 in (1,2) then ibudm92=1; /*answered one of the analgesic classes, so assume non-user for this one*/
else if ibu92 in (.,0,6) and allmiss92=3 then ibudm92=.; /*if truly missing*/


  if tyl92=1 then tyldm92=1;
else if tyl92=2 then tyldm92=2;
else if tyl92=3 then tyldm92=3;
else if tyl92=4 then tyldm92=4;
else if tyl92=5 then tyldm92=5;
else if tyl92 in (.,0,6) and allmiss92 in (1,2) then tyldm92=1; /*answered one of the analgesic classes, so assume non-user for this one*/
else if tyl92 in (.,0,6) and allmiss92=3 then tyldm92=.; /*if truly missing*/


 /**set each group to the median number of days of use**/
 if asp92=1 then aspdd92=0;
 else if asp92=2 then aspdd92=2.5;
 else if asp92=3 then aspdd92=9.5;
 else if asp92=4 then aspdd92=18;
 else if asp92=5 then aspdd92=22;
 else if asp92 in (.,0,6) and allmiss92 in (1,2) then aspdd92=0; /*answered one of the analgesic classes, so assume non-user for this one*/
 else if asp92 in (.,0,6) and allmiss92=3 then aspdd92=.; /*if truly missing*/


  if ibu92=1 then ibudd92=0;
else if ibu92=2 then ibudd92=2.5;
else if ibu92=3 then ibudd92=9.5;
else if ibu92=4 then ibudd92=18;
else if ibu92=5 then ibudd92=22;
else if ibu92 in (.,0,6) and allmiss92 in (1,2) then ibudd92=0; /*answered one of the analgesic classes, so assume non-user for this one*/
else if ibu92 in (.,0,6) and allmiss92=3 then ibudd92=.; /*if truly missing*/


  if tyl92=1 then tyldd92=0;
else if tyl92=2 then tyldd92=2.5;
else if tyl92=3 then tyldd92=9.5;
else if tyl92=4 then tyldd92=18;
else if tyl92=5 then tyldd92=22;
else if tyl92 in (.,0,6) and allmiss92 in (1,2) then tyldd92=0; /*answered one of the analgesic classes, so assume non-user for this one*/
else if tyl92 in (.,0,6) and allmiss92=3 then tyldd92=.; /*if truly missing*/


 /**Assume each day of use is at least 1 tablet/day**/
   aspmo92=aspdd92*1; /*1992 intake asp/month*/
   ibumo92=ibudd92*2;
   tylmo92=tyldd92*2;

 /**translate asp/month to asp/week ***/
   aspwk92=aspmo92/4.3; /*1992 intake asp/week*/
   ibuwk92=ibumo92/4.3;
   tylwk92=tylmo92/4.3;

 /*1992 regural use of asp*/
 if  0<=aspwk92<2 then reguasp92=1;  /*nonuser*/
 else if aspwk92>=2 then reguasp92=2; /*user*/
 else if aspwk92=. then reguasp92=.;

if asp92 in (1) then anyasp92=1;
   else if asp92 in (2,3,4,5) then anyasp92=2;
else if asp92 in (.,0,6) and allmiss92 in (1,2) then anyasp92=1; /*answered one of the analgesic classes, so assume non-user for this one*/
   else anyasp92=.;
  
if ibu92 in (1) then regibu92=1; 
   else if ibu92 in (2,3,4,5) then regibu92=2 /*regular user is 2 or more per week*/;
else if ibu92 in (.,0,6) and allmiss92 in (1,2) then regibu92=1; /*answered one of the analgesic classes, so assume non-user for this one*/   
   else regibu92=.;

if tyl92 in (1) then regtyl92=1;
   else if tyl92 in (2,3,4,5) then regtyl92=2; /*regular user is 2 or more per week*/
else if tyl92 in (.,0,6) and allmiss92 in (1,2) then regtyl92=1; /*answered one of the analgesic classes, so assume non-user for this one*/   
else regtyl92=.;


run;


/*******************************************************************************
1994 data
aspd94: How many days/month do you take aspirin?
        1= <1 d/month, 2=1-3d/mo, 3=1-2d/wk, 4=3-4d/wk, 5=5-6d/wk, 6=daily, 7=pt
nasp94: number of aspirin/week?
        1=0/week, 2=0.5-2/wk, 3=3-5/wk, 4=6-14/wk, 5=15 or more/wk
Regular medications in the past 2 years - 1=yes,  
tyl94:  acetaminophen 2+/week, 
ibu94:   Other antiinflammatory (note, tabs/week was not asked)
********************************************************************************/
%nur94 (keep=aspd94 aspdm94 aspdd94 nasp94 aspwk94 aspmo94 asp94 reguasp94 anyasp94
             ibu94 regibu94 tyl94 regtyl94 batch94 ibuwk94 tylwk94);
 /*set inconsistent info to missing*/
 if aspd94 in (1,2) and nasp94 >1  then do; aspd94=0; nasp94=0; end;
 if aspd94>1 and nasp94=1 then do; aspd94=0; nasp94=0; end;   
 else if aspd94 in (.,0,7) then aspd=.;

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if aspd94=1 then aspdm94=1; /*none*/
 else if aspd94=2 then aspdm94=2; /*1-3 d/month = 1-4 d/month from 90,92questionnaires*/
 else if aspd94=3 then aspdm94=3; /*1-2 d/wk = 5-14 d/month from 90,92 questionnaires*/
 else if aspd94=4 then aspdm94=4; /*3-4 d/wk =15-21 d/month from 90,92 questionnaires*/
 else if aspd94=5 then aspdm94=5; /*5-6 d/wk = >=22 d/month from 90,92 questionnaires*/
 else if aspd94=6 then aspdm94=5; /*daily= >=22 d/month from 90, 92 questionnaires*/
 else if aspd94 in (.,0,7) then aspdm94=.;

 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 if aspd94=1 then aspdd94=0; /*none*/
 else if aspd94=2 then aspdd94=2.5; /*1-3 d/month = 1-4 d/month from 90,92questionnaires*/
 else if aspd94=3 then aspdd94=9.5; /*1-2 d/wk = 5-14 d/month from 90,92 questionnaires*/
 else if aspd94=4 then aspdd94=18; /*3-4 d/wk =15-21 d/month from 90,92 questionnaires*/
 else if aspd94=5 then aspdd94=30; /*5-6 d/wk = >=22 d/month from 90,92 questionnaires*/
 else if aspd94=6 then aspdd94=30; /*daily= >=22 d/month from 90, 92 questionnaires*/
 else if aspd94 in (.,0,7) then aspdd94=.;

 /**set each group to the median number of asp consumed**/
 if nasp94=1 then nasp=0;
 else if nasp94=2 then nasp=1.25;
 else if nasp94=3 then nasp=4;
 else if nasp94=4 then nasp=10;
 else if nasp94=5 then nasp=20;
 else if nasp94 in(.,0,6) then nasp=.;
 aspwk94 = nasp; /*1994 intake asp/week*/
 aspmo94 = nasp * 4.3; /*1994 intake asp/month*/


 /*1994 regular use of aspirin*/
 if  0<=aspwk94<2 then reguasp94=1; /*nonuser*/
 else if aspwk94>=2 then reguasp94=2; /*user*/
 else if aspwk94=. then reguasp94=.;


      if .<aspd94<2 or nasp94=1 then anyasp94=1; /*non-user*/
      else if aspd94 in (2,3,4,5,6) or nasp94 in (2,3,4,5) then anyasp94=2; /* user*/
   else anyasp94=.; /*missing aspirin*/

 /*bring in 1994 nsaids*/
   if 0<batch94<800 then do; /*filled out long questionnaire*/
      if ibu94=1 then regibu94=2; /*regular ibuprofen user*/
      else regibu94=1; /*non user*/
      end;
   else regibu94=.; /*missing or non-user nsaid*/   

 /*bring in 1994 tylenol*/
   if 0<batch94<800 then do; /*filled out long questionnaire*/
      if tyl94=1 then regtyl94=2; /*regular tylenol   user*/
      else regtyl94=1; /*non user*/
      end;
   else regtyl94=.; /*missing or non-user tylenol*/

 /*bring in 1994 nsaids, tabs/week*/
if 0<batch94<800 then ibuwk94=0;/*missing or non-user nsaid - zero tablets/wk*/
if ibu94=1 then ibuwk94=2;/*Current user nsaid - at least 2 tablets/wk*/
 /*bring in 1994 acetaminophen*/
tylwk94=0;/*missing or non-user tyl - zero tablets*/
 if tyl94=1 then tylwk94=2;/*Current user tyl - at least 2 tablets/wk*/


run;

/*******************************************************************************
1996 data
aspd96: How many days/month do you take aspirin?
        1= <1 d/month, 2=1-3d/mo, 3=1-2d/wk, 4=3-4d/wk, 5=5-6d/wk, 6=daily, 7=pt
nasp96: number of aspirin/week?
        1=0/week, 2=0.5-2/wk, 3=3-5/wk, 4=6-14/wk, 5=15 or more/wk
Regular medications in the past 2 years - 1=yes, 0=no, 
tyl96:  acetaminophen 2+/week, 
ibu96:  Other antiinflammatory
********************************************************************************/
%nur96(keep= aspdd96 aspdm96 aspd96 nasp96 aspwk96 aspmo96 reguasp96 anyasp96
             ibu96 tyl96 regibu96 regtyl96 batch96  oa96 oad96 batch96
             ibuwk96 tylwk96);

 /*set inconsistent info to missing*/
 if aspd96 in (1,2) and nasp96 >1  then do; aspd96=0; nasp96=0; end;
 if aspd96>1 and nasp96=1 then do; aspd96=0; nasp96=0; end;   
 else if aspd96 in (.,0,7) then aspd96=.;

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if aspd96=1 then aspdm96=1; /*none*/
 else if aspd96=2 then aspdm96=2; /*1-3 d/month = 1-4 d/month from 90,92questionnaires*/
 else if aspd96=3 then aspdm96=3; /*1-2 d/wk = 5-14 d/month from 90,92 questionnaires*/
 else if aspd96=4 then aspdm96=4; /*3-4 d/wk =15-21 d/month from 90,92 questionnaires*/
 else if aspd96=5 then aspdm96=5; /*5-6 d/wk = >=22 d/month from 90,92 questionnaires*/
 else if aspd96=6 then aspdm96=5; /*daily= >=22 d/month from 90, 92 questionnaires*/
 else if aspd96 in (.,0,7) then aspdm96=.;

 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 if aspd96=1 then aspdd96=0; /*none*/
 else if aspd96=2 then aspdd96=2.5; /*1-3 d/month = 1-4 d/month from 90,92questionnaires*/
 else if aspd96=3 then aspdd96=9.5; /*1-2 d/wk = 5-14 d/month from 90,92 questionnaires*/
 else if aspd96=4 then aspdd96=18; /*3-4 d/wk =15-21 d/month from 90,92 questionnaires*/
 else if aspd96=5 then aspdd96=30; /*5-6 d/wk = >=22 d/month from 90,92 questionnaires*/
 else if aspd96=6 then aspdd96=30; /*daily= >=22 d/month from 90, 92 questionnaires*/
 else if aspd96 in (.,0,7) then aspdd96=.;

 /**set each group to the median number of asp consumed**/
 if nasp96=1 then nasp=0;
 else if nasp96=2 then nasp=1.25;
 else if nasp96=3 then nasp=4;
 else if nasp96=4 then nasp=10;
 else if nasp96=5 then nasp=20;
 else if nasp96 in(.,0,6) then nasp=.;
 aspwk96 = nasp; /*1996 intake asp/week*/ 
 aspmo96 = nasp * 4.3; /*1996 intake asp/month*/

 /*1996 regular use of aspirin*/
 if  0<=aspwk96<2 then reguasp96=1; /*nonuser*/
 else if aspwk96>=2 then reguasp96=2; /*user*/
 else if aspwk96=. then reguasp96=.;

      if .<aspd96<2 or nasp96=1 then anyasp96=1; /*non-user*/
      else if aspd96 in (2,3,4,5,6) or nasp96 in (2,3,4,5) then anyasp96=2; /* user*/
   else anyasp96=.; /*missing aspirin*/

 /*bring in 1996 nsaids*/
   if 0<batch96<800 then do; /*filled out long questionnaire*/
      if ibu96=1 then regibu96=2; /*regular ibuprofen user*/
      else regibu96=1; /*non user*/
      end;
   else regibu96=.; /*missing nsaid data*/

 /*bring in 1996 tylenol*/
   if 0<batch96<800 then do; /*filled out long questionnaire*/
      if tyl96=1 then regtyl96=2; /*regular tylenol user*/
      else regtyl96=1; /*non user of tylenol*/
      end;
   else regtyl96=.; /*missing tylenol data*/

/* bring in osteoarthritis from lifetime history question*/
   if oa96=1 then do;
    oa90f=.; oa92f=.; oa94f=.; oa96f=.;
    if oad96 in (1,2) then oa90f=1;
      else if oad96=3 then oa92f=1;
      else if oad96=4 then oa94f=1;
      else if oad96=5 then oa96f=1;
      end;
      else do;
       oa90f=2; oa92f=2; oa94f=2; oa96f=2; /*no OA*/
	 end;


 /*bring in 1996 nsaids*/
ibuwk96=0;/*missing or non-user nsaid - zero/tablets/wk*/
if ibu96=1 then ibuwk96=2;/*Current user nsaid - at least 2 tablets/wk*/
 /*bring in 1996 acetaminophen*/
tylwk96=0;/*missing or non-user tyl - zero tablets/wk*/
if tyl96=1 then tylwk96=2;/*Current user tyl - at least 2 tablets/wk*/

run;

/*******************************************************************************
1998 data
aspd98: How frequently do you take aspirin?
        1=0 d/month, 2=1-3d/mo, 3=1-2d/wk, 4=3-4d/wk, 5=5-6d/wk, 6=daily, 7=pt
nasp98: on average number of aspirin/week ?
        1=0/week, 2=0.5-2/wk, 3=3-5/wk, 4=6-14/wk, 5=15 or more/wk

Q18. Regular medication.  
tyl98, ibu98 - 1=use regularly
Tylenol tyld98 days /week 1=1 2=2-3 3=4-5 4=6+ 5=pt
                 tyln98 tabs /week 1=1-2 2=3-5 3=6-14 4=15+ 5=pt
NSAID   ibud98 days/week  1=1 2=2-3 3=4-5 4=6+ 5=pt
                 ibun98 tabs/week  1=1-2 2=3-5 3=6-14 4=15+ 5=pt
                 ibut98 type 1=ibu 2=othertype 3=pt
********************************************************************************/
%nur98(keep=aspd98 nasp98 aspwk98 aspdm98 aspdd98 reguasp98 anyasp98
            regtyl98 tyl98 tyld98 tyln98 tylwk98 tyldm98 tyldd98 
            regibu98 ibu98 ibud98 ibudm98 ibun98 ibuwk98 ibut98 
            q98 ibudd98 nondm98 nondd98 nonwk98);

 /*set inconsistent info to missing*/
 if aspd98 in (1,2) and nasp98 >1  then do; aspd98=0; nasp98=0; end;
 if aspd98>1 and nasp98=1 then do; aspd98=0; nasp98=0; end;   
 else if aspd98 in (.,0,7) then aspd98=.;

 /*regular users, irrespective of frequency or dose*/
 /*bring in 1998 nsaids*/
   if q98 in (1,2) then do; /*filled out long questionnaire*/
      if ibu98=1 then regibu98=2; /*regular ibuprofen user*/
      else regibu98=1; /*non user*/
      end;
   else regibu98=.; /*missing or nsaid*/

 /*bring in 1998 tylenol*/
   if q98 in (1,2) then do; /*filled out long questionnaire*/
      if tyl98=1 then regtyl98=2; /*regular tylenol user*/
      else regtyl98=1; /*non user*/
      end;
   else regtyl98=.; /*missing tylenol data*/

 /*anyasp*/
      if .<aspd98<2 or nasp98=1 then anyasp98=1; /*non-user*/
      else if aspd98 in (2,3,4,5,6) or nasp98 in (2,3,4,5) then anyasp98=2; /* user*/
   else anyasp98=.; /*missing aspirin*/


 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if aspd98=1 then aspdm98=1; /*none*/
 else if aspd98=2 then aspdm98=2; /*1-3 d/month = 1-4 d/month from 90,92questionnaires*/
 else if aspd98=3 then aspdm98=3; /*1-2 d/wk = 5-14 d/month from 90,92 questionnaires*/
 else if aspd98=4 then aspdm98=4; /*3-4 d/wk =15-21 d/month from 90,92 questionnaires*/
 else if aspd98=5 then aspdm98=5; /*5-6 d/wk = >=22 d/month from 90,92 questionnaires*/
 else if aspd98=6 then aspdm98=5; /*daily= >=22 d/month from 90, 92 questionnaires*/
 else if aspd98 in (.,0,7) then aspdm98=.;

   if regibu98=1 then ibudm98=1; /*non-user*/
   else if regibu98=2 then do;
  if ibud98=1 then ibudm98=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud98=2 then ibudm98=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud98=3 then ibudm98=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud98=4 then ibudm98=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud98 in (.,0,5) then ibudm98=.;
      end;
else ibudm98=.;
   
/*differentiate between non-ibuprofen brands)*/   
  
   if regibu98=1 then nondm98=1; /*non user of anykind*/
   else if regibu98=2 then do;
      if ibut98=1 then do; /*ibuprofen user*/
         if ibudm98=1 then nondm98=1; /*nonuser of any kind*/
         else if ibudm98=2 then nondm98=2; /*ibuprofen user*/
         else if ibudm98=3 then nondm98=3; /*ibuprofen user*/
         else if ibudm98=4 then nondm98=4; /*ibuprofen user*/
         else if ibudm98=5 then nondm98=5; /*ibuprofen user*/
      end;  
      else if ibut98=2 then do;
         if ibudm98=1 then nondm98=1; /*non user of any kind*/
         else if ibudm98=2 then nondm98=6; /*user of non ibu*/
         else if ibudm98=3 then nondm98=7; /*user of non-ibu*/
         else if ibudm98=4 then nondm98=8; /*users of non-ibu*/
         else if ibudm98=5 then nondm98=9; /*users of non-ibu*/
      end;
      else nondm98=10; /*user of unknown type*/ 
   end;
   else nondm98=.; /*missing nsaid data*/
  
   
if regtyl98=1 then tyldm98=1; /*non-user*/
   else if regtyl98=2 then do;
  if tyld98=1 then tyldm98=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld98=2 then tyldm98=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld98=3 then tyldm98=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld98=4 then tyldm98=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld98 in (.,0,5) then tyldm98=.;
      end;
else tyldm98=.;


 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 if aspd98=1 then aspdd98=0; /*none*/
 else if aspd98=2 then aspdd98=2.5; /*1-3 d/month = 1-4 d/month from 90,92questionnaires*/
 else if aspd98=3 then aspdd98=9.5; /*1-2 d/wk = 5-14 d/month from 90,92 questionnaires*/
 else if aspd98=4 then aspdd98=18; /*3-4 d/wk =15-21 d/month from 90,92 questionnaires*/
 else if aspd98=5 then aspdd98=22; /*5-6 d/wk = >=22 d/month from 90,92 questionnaires*/
 else if aspd98=6 then aspdd98=22; /*daily= >=22 d/month from 90, 92 questionnaires*/
 else if aspd98 in (.,0,7) then aspdd98=.;

   if regibu98=1 then ibudd98=0; /*non-user*/
   else if regibu98=2 then do;
  if ibud98=1 then ibudd98=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud98=2 then ibudd98=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud98=3 then ibudd98=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud98=4 then ibudd98=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud98 in (.,0,5) then ibudd98=.;
      end;
else ibudd98=.;

/*differentiate between non-ibuprofen brands)*/   
  
   if regibu98=1 then nondd98=0; /*non user of anykind*/
   else if regibu98=2 then do;
      if ibut98=1 then do; /*ibuprofen user*/
         if ibudm98=1 then nondd98=0; /*nonuser of any kind*/
         else if ibudm98=2 then nondd98=0; /*ibuprofen user*/
         else if ibudm98=3 then nondd98=0; /*ibuprofen user*/
         else if ibudm98=4 then nondd98=0; /*ibuprofen user*/
         else if ibudm98=5 then nondd98=0; /*ibuprofen user*/
      end;  
      else if ibut98=2 then do;
         if ibudm98=1 then nondd98=0; /*non user of any kind*/
         else if ibudm98=2 then nondd98=2.5; /*user of non ibu*/
         else if ibudm98=3 then nondd98=9.5; /*user of non-ibu*/
         else if ibudm98=4 then nondd98=18; /*users of non-ibu*/
         else if ibudm98=5 then nondd98=22; /*users of non-ibu*/
      end;
      else nondd98=.; /*user of unknown type*/ 
   end;
   else nondd98=.; /*missing nsaid data*/
 

if regtyl98=1 then tyldd98=0; /*non-user*/
   else if regtyl98=2 then do;
  if tyld98=1 then tyldd98=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld98=2 then tyldd98=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld98=3 then tyldd98=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld98=4 then tyldd98=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld98 in (.,0,5) then tyldd98=.;
      end;
else tyldd98=.;


 /**set each group to the median number of asp consumed**/
 if nasp98=1 then nasp=0;
 else if nasp98=2 then nasp=1.25;
 else if nasp98=3 then nasp=4;
 else if nasp98=4 then nasp=10;
 else if nasp98=5 then nasp=20;
 else if nasp98 in(.,0,6) then nasp=.;
 aspwk98 = nasp; /*1998 intake asp/week*/

/*set each group the median number of nsaids consumed*/
   if regibu98=1 then ibuwk98=0; /*non-user*/
   else if regibu98=2 then do;
  if ibun98=1 then ibuwk98=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibun98=2 then ibuwk98=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibun98=3 then ibuwk98=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibun98=4 then ibuwk98=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibun98 in (.,0,5) then ibuwk98=.;
      end;
else ibuwk98=.; /*did not report any nsaid data*/
   
/*differentiate between non-ibuprofen brands)*/   
  
   if regibu98=1 then nonwk98=0; /*non user of anykind*/
   else if regibu98=2 then do;
      if ibut98=1 then do; /*ibuprofen*/
         if ibuwk98=0 then nonwk98=0; /*nonuser of any kind*/
         else if ibuwk98=1.5 then nonwk98=0;
         else if ibuwk98=4 then nonwk98=0;
         else if ibuwk98=10 then nonwk98=0;
         else if ibuwk98=20 then nonwk98=0;
      end;  
      else if ibut98=2 then do; /*non-ibuprofen*/
         if ibuwk98=0 then nonwk98=0; /*non user of any kind*/
         else if ibuwk98=1.5 then nonwk98=1.5; /*user of non ibu*/
         else if ibuwk98=4 then nonwk98=4; /*user of non-ibu*/
         else if ibuwk98=10 then nonwk98=10; /*user of non-ibu*/ 
         else if ibuwk98=20 then nonwk98=20; /*user of non-ibu*/
      end;
      else nonwk98=.; /*user of unknown type*/ 
   end;
   else nonwk98=.; /*missing nsaid data*/
  
/*set each group the median number of tylenol consumed*/
   if regtyl98=1 then tylwk98=0; /*non-user*/
   else if regtyl98=2 then do;
  if tyln98=1 then tylwk98=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyln98=2 then tylwk98=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyln98=3 then tylwk98=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyln98=4 then tylwk98=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyln98 in (.,0,5) then tylwk98=.;
      end;
else tylwk98=.; /*did not report any tylenol data*/


 /*1998 regular use of aspirin*/
 if  0<=aspwk98<2 then reguasp98=1; /*nonuser*/
 else if aspwk98>=2 then reguasp98=2; /*user*/
 else if aspwk98=. then reguasp98=.;

run;


/**********************************************
2000 data 
bab00: Use regulary? Baby Aspirin, 1=Yes
babd00: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab00: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp00: Use regulary? Aspirin, 1=Yes
aspd00: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp00: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur00(keep=q00 asp00 aspd00 nasp00 aspwk00 aspdm00 aspdd00 regu00 reguasp00
            bab00 babd00 nbab00 babdm00 babdd00 regbab00 regaspb00
            regnsad00 
            regtyl00 tyl00 tyld00 tyln00 tylwk00 tyldm00 tyldd00 
            regibu00 ibu00 ibud00 ibudm00 ibun00 ibuwk00 ibut00 q00 
            ibudd00 regnon00 totadd00 totadm00
            celeb00 regcox00 oa00 oad00 oa96ff oa98f oa00f);

/*regular users, irrespective of frequency or dose*/
 /*bring in 2000 nsaids*/
   if q00 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-4,  questionnaire*/
      if ibu00=1 then regibu00=2; /*regular ibuprofen user*/
      else regibu00=1; /*non user*/
      end;
   else regibu00=.; /*missing or nsaid*/

 /*bring in 2000 tylenol*/
   if q00 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-4,  questionnaire*/
      if tyl00=1 then regtyl00=2; /*regular tylenol user*/
      else regtyl00=1; /*non user*/
      end;
   else regtyl00=.; /*missing tylenol data*/

 /*bring in 2000 other anti-inflamm*/
   if q00 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-4,  questionnaire*/
      if ibut00=1 then regnon00=2; /*regular naprosyn user*/
      else regnon00=1; /*non user of naprosyn*/
      end;
   else regnon00=.; /*missing naprosyn data*/

 /*bring in 2000 COX-2*/
   if q00 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-4,  questionnaire*/
      if celeb00=1 then regcox00=2; /*regular COX-2 user*/
      else regcox00=1; /*non user of COX-2*/
      end;
   else regcox00=.; /*missing COX-2 data*/

 /*bring in 2000 aspirin*/
 if q00 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-4,  questionnaire*/
 if asp00=1 then regu00=2; 
 else regu00=1; 
 end;
 else regu00=.; /*missing*/

/*bring in 2000 baby aspirin*/
 if q00 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-4,  questionnaire*/
 if bab00=1 then regbab00=2; /*regular baby aspirin user*/
 else regbab00=1; /*non user*/
 end;
 else regbab00=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu00=1 then aspdm00=1; /*non-user*/
 else if regu00=2 then do;
 if aspd00=1 then aspdm00=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd00=2 then aspdm00=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd00=3 then aspdm00=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd00=4 then aspdm00=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd00 in (.,0,5) then aspdm00=.;
 end;
 else aspdm00=.;

 if regbab00=1 then babdm00=1; /*non-user*/
 else if regbab00=2 then do;
 if babd00=1 then babdm00=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd00=2 then babdm00=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd00=3 then babdm00=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd00=4 then babdm00=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd00 in (.,0,5) then babdm00=.;
 end;
 else babdm00=.;


   if regibu00=1 then ibudm00=1; /*non-user*/
   else if regibu00=2 then do;
  if ibud00=1 then ibudm00=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud00=2 then ibudm00=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud00=3 then ibudm00=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud00=4 then ibudm00=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud00 in (.,0,5) then ibudm00=.;
      end;
else ibudm00=.;
      
if regtyl00=1 then tyldm00=1; /*non-user*/
   else if regtyl00=2 then do;
  if tyld00=1 then tyldm00=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld00=2 then tyldm00=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld00=3 then tyldm00=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld00=4 then tyldm00=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld00 in (.,0,5) then tyldm00=.;
      end;
else tyldm00=.;


 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu00=1 then aspdd00=0; /*non-user*/
 else if regu00=2 then do;
 if aspd00=1 then aspdd00=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd00=2 then aspdd00=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd00=3 then aspdd00=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd00=4 then aspdd00=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd00 in (.,0,5) then aspdd00=.;
 end;
 else aspdd00=.;
 /*baby aspirin*/
 if regbab00=1 then babdd00=0; /*non-user*/
 else if regbab00=2 then do;
 if babd00=1 then babdd00=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd00=2 then babdd00=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd00=3 then babdd00=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd00=4 then babdd00=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd00 in (.,0,5) then babdd00=.;
 end;
 else babdd00=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd00=sum (babdd00, aspdd00); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd00=0 then totadm00=1; /*lowest category of days per month*/
 else if 0< totadd00 <=4 then totadm00=2; /*1-4 d/month*/
 else if 4< totadd00 <=14 then totadm00=3; /*5-14 d/month*/
 else if 15< totadd00<=21 then totadm00=4; /*15-21 d/month*/
 else if totadd00>21 then totadm00=5; /*22+ days/month*/


   if regibu00=1 then ibudd00=0; /*non-user*/
   else if regibu00=2 then do;
  if ibud00=1 then ibudd00=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud00=2 then ibudd00=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud00=3 then ibudd00=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud00=4 then ibudd00=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud00 in (.,0,5) then ibudd00=.;
      end;
else ibudd00=.;

if regtyl00=1 then tyldd00=0; /*non-user*/
   else if regtyl00=2 then do;
  if tyld00=1 then tyldd00=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld00=2 then tyldd00=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld00=3 then tyldd00=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld00=4 then tyldd00=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld00 in (.,0,5) then tyldd00=.;
      end;
else tyldd00=.;
 


 /**set each aspirin group to the median number of asp consumed**/
 if regu00=1 then nasp=0;/*non-user*/
 else if regu00=2 then do; 
 if nasp00=1 then nasp=1.5;
 else if nasp00=2 then nasp=4;
 else if nasp00=3 then nasp=10;
 else if nasp00=4 then nasp=20;
 else if nasp00 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab00=1 then nbab=0;/*non-user*/
 else if regbab00=2 then do; 
 if nbab00=1 then nbab=1.5;
 else if nbab00=2 then nbab=4;
 else if nbab00=3 then nbab=10;
 else if nbab00=4 then nbab=20;
 else if nbab00 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2000 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2000 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk00=naspeq;
 else if nasp ne . and naspeq eq . then aspwk00=nasp;
 else  aspwk00 = nasp+ naspeq; 

 if regu00=2 and nasp in (0,.) and naspeq in (0,.) then aspwk00=.;  /*changed*/
 else if regbab00=2 and nasp in (0,.) and naspeq in (0,.) then aspwk00=.;
 /*2000 intake asp/month*/
 aspmo00 = aspwk00 * 4.3; 


/*set each group the median number of nsaids consumed*/
   if regibu00=1 then ibuwk00=0; /*non-user*/
   else if regibu00=2 then do;
  if ibun00=1 then ibuwk00=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibun00=2 then ibuwk00=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibun00=3 then ibuwk00=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibun00=4 then ibuwk00=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibun00 in (.,0,5) then ibuwk00=.;
      end;
else ibuwk00=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl00=1 then tylwk00=0; /*non-user*/
   else if regtyl00=2 then do;
  if tyln00=1 then tylwk00=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyln00=2 then tylwk00=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyln00=3 then tylwk00=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyln00=4 then tylwk00=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyln00 in (.,0,5) then tylwk00=.;
      end;
else tylwk00=.; /*did not report any tylenol data*/


/* bring in osteoarthritis from lifetime history question*/
   if oa00=1 then do;
    oa96ff=.; oa98f=.; oa00f=.; 
    if oad00 in (1) then oa96ff=1; /*differentiate this from the oa96f from nur96*/
      else if oad00=2 then oa98f=1;
      else if oad00 in (3,4) then oa00f=1;
      else if oad00=5 then oa02f=1;
      end;
      else do;
       oa96ff=2; oa98f=2; oa00f=2; oa02f=2;/*no OA*/
	 end;


 /*regular aspirin or baby aspirin*/
 if regu00=1 and regbab00 in (.,1) then regaspb00=1;
 else if regu00 in (.,1) and regbab00=1 then regaspb00=1;
 else if regu00=2 and regbab00 in (.,1,2) then regaspb00=2;
 else if regu00 in (.,1,2) and regbab00=2 then regaspb00=2;


 /*regular nsaid*/
if regibu00=1 and regnon00 in (.,1) and regcox00 in (.,1) then regnsad00=1;
else if regibu00 in (.,1) and regnon00=1 and regcox00 in (.,1) then regnsad00=1;
else if regibu00 in (.,1) and regnon00 in (.,1) and regcox00=1 then regnsad00=1;
else if regibu00=2 and regnon00 in (.,1,2) and regcox00 in (.,1,2) then regnsad00=2;
else if regibu00 in (.,1,2) and regnon00=2 and regcox00 in (.,1,2) then regnsad00=2;
else if regibu00 in (.,1,2) and regnon00 in (.,1,2) and regcox00=2 then regnsad00=2;


  /*2000 regular use of aspirin*/
 if  0<=aspwk00<2 then reguasp00=1; /*nonuser*/
 else if aspwk00>=2 then reguasp00=2; /*user*/
 else if aspwk00=. then reguasp00=.;

run;


/**********************************************
2002 data 
bab02: Use regulary? Baby Aspirin, 1=Yes
babd02: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab02: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp02: Use regulary? Aspirin, 1=Yes
aspd02: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp02: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur02(keep=q02 asp02 aspd02 nasp02 aspwk02 aspdm02 aspdd02 regu02 reguasp02
            bab02 babd02 nbab02 babdm02 babdd02 regbab02 regaspb02 
            regtyl02 tyl02 tyld02 tyln02 tylwk02 tyldm02 tyldd02 
            regibu02 ibu02 ibud02 ibudm02 nibu02 ibuwk02 ibut02 
            ibudd02 regnon02 totadd02 totadm02
            celeb02 regcox02  );

/*regular users, irrespective of frequency or dose*/ /*bring in 2002 nsaids*/
   if q02 in (1,2,3) then do; /*filled out long, booklet, page1,2, questionnaire*/
      if ibu02=1 then regibu02=2; /*regular ibuprofen user*/
      else regibu02=1; /*non user*/
      end;
   else regibu02=.; /*missing or nsaid*/

 /*bring in 2002 tylenol*/
   if q02 in (1,2,3) then do; /*filled out long, booklet, page1,2, questionnaire*/
      if tyl02=1 then regtyl02=2; /*regular tylenol user*/
      else regtyl02=1; /*non user*/
      end;
   else regtyl02=.; /*missing tylenol data*/

 /*bring in 2002 other anti-inflamm*/
   if q02 in (1,2,3) then do; /*filled out long, booklet, page1,2, questionnaire*/
      if ibut02=1 then regnon02=2; /*regular naprosyn user*/
      else regnon02=1; /*non user of naprosyn*/
      end;
   else regnon02=.; /*missing naprosyn data*/

 /*bring in 2002 COX-2*/
   if q02 in (1,2,3) then do; /*filled out long, booklet, page1,2, questionnaire*/
      if celeb02=1 then regcox02=2; /*regular COX-2 user*/
      else regcox02=1; /*non user of COX-2*/
      end;
   else regcox02=.; /*missing COX-2 data*/


 /*bring in 2002 aspirin*/
 if q02 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-2,  questionnaire*/
 if asp02=1 then regu02=2; 
 else regu02=1; 
 end;
 else regu02=.; /*missing*/

/*bring in 2002 baby aspirin*/
 if q02 in (1,2,3) then do; /*filled out long, booklet, or telephone pg1-2,  questionnaire*/
 if bab02=1 then regbab02=2; /*regular baby aspirin user*/
 else regbab02=1; /*non user*/
 end;
 else regbab02=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu02=1 then aspdm02=1; /*non-user*/
 else if regu02=2 then do;
 if aspd02=1 then aspdm02=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd02=2 then aspdm02=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd02=3 then aspdm02=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd02=4 then aspdm02=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd02 in (.,0,5) then aspdm02=.;
 end;
 else aspdm02=.;

 if regbab02=1 then babdm02=1; /*non-user*/
 else if regbab02=2 then do;
 if babd02=1 then babdm02=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd02=2 then babdm02=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd02=3 then babdm02=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd02=4 then babdm02=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd02 in (.,0,5) then babdm02=.;
 end;
 else babdm02=.;


   if regibu02=1 then ibudm02=1; /*non-user*/
   else if regibu02=2 then do;
  if ibud02=1 then ibudm02=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud02=2 then ibudm02=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud02=3 then ibudm02=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud02=4 then ibudm02=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud02 in (.,0,5) then ibudm02=.;
      end;
else ibudm02=.;
      
if regtyl02=1 then tyldm02=1; /*non-user*/
   else if regtyl02=2 then do;
  if tyld02=1 then tyldm02=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld02=2 then tyldm02=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld02=3 then tyldm02=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld02=4 then tyldm02=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld02 in (.,0,5) then tyldm02=.;
      end;
else tyldm02=.;


 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu02=1 then aspdd02=0; /*non-user*/
 else if regu02=2 then do;
 if aspd02=1 then aspdd02=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd02=2 then aspdd02=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd02=3 then aspdd02=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd02=4 then aspdd02=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd02 in (.,0,5) then aspdd02=.;
 end;
 else aspdd02=.;
 /*baby aspirin*/
 if regbab02=1 then babdd02=0; /*non-user*/
 else if regbab02=2 then do;
 if babd02=1 then babdd02=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd02=2 then babdd02=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd02=3 then babdd02=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd02=4 then babdd02=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd02 in (.,0,5) then babdd02=.;
 end;
 else babdd02=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd02=sum (babdd02, aspdd02); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd02=0 then totadm02=1; /*lowest category of days per month*/
 else if 0< totadd02 <=4 then totadm02=2; /*1-4 d/month*/
 else if 4< totadd02 <=14 then totadm02=3; /*5-14 d/month*/
 else if 15< totadd02<=21 then totadm02=4; /*15-21 d/month*/
 else if totadd02>21 then totadm02=5; /*22+ days/month*/


   if regibu02=1 then ibudd02=0; /*non-user*/
   else if regibu02=2 then do;
  if ibud02=1 then ibudd02=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud02=2 then ibudd02=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud02=3 then ibudd02=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud02=4 then ibudd02=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud02 in (.,0,5) then ibudd02=.;
      end;
else ibudd02=.;

if regtyl02=1 then tyldd02=0; /*non-user*/
   else if regtyl02=2 then do;
  if tyld02=1 then tyldd02=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld02=2 then tyldd02=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld02=3 then tyldd02=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld02=4 then tyldd02=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld02 in (.,0,5) then tyldd02=.;
      end;
else tyldd02=.;



 /**set each aspirin group to the median number of asp consumed**/
 if regu02=1 then nasp=0;/*non-user*/
 else if regu02=2 then do; 
 if nasp02=1 then nasp=1.5;
 else if nasp02=2 then nasp=4;
 else if nasp02=3 then nasp=10;
 else if nasp02=4 then nasp=20;
 else if nasp02 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab02=1 then nbab=0;/*non-user*/
 else if regbab02=2 then do; 
 if nbab02=1 then nbab=1.5;
 else if nbab02=2 then nbab=4;
 else if nbab02=3 then nbab=10;
 else if nbab02=4 then nbab=20;
 else if nbab02 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2002 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2002 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk02=naspeq;
 else if nasp ne . and naspeq eq . then aspwk02=nasp;
 else  aspwk02 = nasp+ naspeq; 

 if regu02=2 and nasp in (0,.) and naspeq in (0,.) then aspwk02=.; /*changed*/
 else if regbab02=2 and nasp in (0,.) and naspeq in (0,.) then aspwk02=.;

 /*2002 intake asp/month*/
 aspmo02 = aspwk02 * 4.3; 


/*set each group the median number of nsaids consumed*/
   if regibu02=1 then ibuwk02=0; /*non-user*/
   else if regibu02=2 then do;
  if nibu02=1 then ibuwk02=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if nibu02=2 then ibuwk02=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if nibu02=3 then ibuwk02=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if nibu02=4 then ibuwk02=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if nibu02 in (.,0,5) then ibuwk02=.;
      end;
else ibuwk02=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl02=1 then tylwk02=0; /*non-user*/
   else if regtyl02=2 then do;
  if tyln02=1 then tylwk02=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyln02=2 then tylwk02=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyln02=3 then tylwk02=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyln02=4 then tylwk02=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyln02 in (.,0,5) then tylwk02=.;
      end;
else tylwk02=.; /*did not report any tylenol data*/



 /*regular aspirin or baby aspirin*/
 if regu02=1 and regbab02 in (.,1) then regaspb02=1;
 else if regu02 in (.,1) and regbab02=1 then regaspb02=1;
 else if regu02=2 and regbab02 in (.,1,2) then regaspb02=2;
 else if regu02 in (.,1,2) and regbab02=2 then regaspb02=2;

 /*regular nsaid*/
if regibu02=1 and regnon02 in (.,1) and regcox02 in (.,1) then regnsad02=1;
else if regibu02 in (.,1) and regnon02=1 and regcox02 in (.,1) then regnsad02=1;
else if regibu02 in (.,1) and regnon02 in (.,1) and regcox02=1 then regnsad02=1;
else if regibu02=2 and regnon02 in (.,1,2) and regcox02 in (.,1,2) then regnsad02=2;
else if regibu02 in (.,1,2) and regnon02=2 and regcox02 in (.,1,2) then regnsad02=2;
else if regibu02 in (.,1,2) and regnon02 in (.,1,2) and regcox02=2 then regnsad02=2;


  /*2002 regular use of aspirin*/
 if  0<=aspwk02<2 then reguasp02=1; /*nonuser*/
 else if aspwk02>=2 then reguasp02=2; /*user*/
 else if aspwk02=. then reguasp02=.;

run;


/**********************************************
2004 data 
bab04: Use regulary? Baby Aspirin, 1=Yes
babd04: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab04: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp04: Use regulary? Aspirin, 1=Yes
aspd04: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp04: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur04(keep=q04 asp04 aspd04 nasp04 aspwk04 aspdm04 aspdd04 regu04 reguasp04
            bab04 babd04 nbab04 babdm04 babdd04 regbab04 regaspb04
			regnsad04
            regtyl04 tyl04 tyld04 tyln04 tylwk04 tyldm04 tyldd04 
            regibu04 ibu04 ibud04 ibudm04 nibu04 ibuwk04 ibut04 
            ibudd04  regnon04 totadd04 totadm04
            celeb04 regcox04 );

/*regular users, irrespective of frequency or dose*/
 /*bring in 2004 nsaids*/
   if q04 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if ibu04=1 then regibu04=2; /*regular ibuprofen user*/
      else regibu04=1; /*non user*/
      end;
   else regibu04=.; /*missing or nsaid*/

 /*bring in 2004 tylenol*/
   if q04 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if tyl04=1 then regtyl04=2; /*regular tylenol user*/
      else regtyl04=1; /*non user*/
      end;
   else regtyl04=.; /*missing tylenol data*/


 /*bring in 2004 other anti-inflamm*/
   if q04 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if ibut04=1 then regnon04=2; /*regular naprosyn user*/
      else regnon04=1; /*non user of naprosyn*/
      end;
   else regnon04=.; /*missing naprosyn data*/

 /*bring in 2004 COX-2*/
   if q04 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if celeb04=1 then regcox04=2; /*regular COX-2 user*/
      else regcox04=1; /*non user of COX-2*/
      end;
   else regcox04=.; /*missing COX-2 data*/



 /*bring in 2004 aspirin*/
 if q04 in (1,2) then do; /*filled out long or booklet questionnaire*/
 if asp04=1 then regu04=2; 
 else regu04=1; /*non user*/
 end;
 else regu04=.; /*missing*/


/*bring in 2004 baby aspirin*/
 if q04 in (1,2) then do; /*filled out long, booklet, or telephone pg1-2,  questionnaire*/
 if bab04=1 then regbab04=2; /*regular baby aspirin user*/
 else regbab04=1; /*non user*/
 end;
 else regbab04=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu04=1 then aspdm04=1; /*non-user*/
 else if regu04=2 then do;
 if aspd04=1 then aspdm04=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd04=2 then aspdm04=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd04=3 then aspdm04=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd04=4 then aspdm04=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd04 in (.,0,5) then aspdm04=.;
 end;
 else aspdm04=.;

 if regbab04=1 then babdm04=1; /*non-user*/
 else if regbab04=2 then do;
 if babd04=1 then babdm04=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd04=2 then babdm04=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd04=3 then babdm04=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd04=4 then babdm04=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd04 in (.,0,5) then babdm04=.;
 end;
 else babdm04=.;


   if regibu04=1 then ibudm04=1; /*non-user*/
   else if regibu04=2 then do;
  if ibud04=1 then ibudm04=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud04=2 then ibudm04=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud04=3 then ibudm04=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud04=4 then ibudm04=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud04 in (.,0,5) then ibudm04=.;
      end;
else ibudm04=.;
      
if regtyl04=1 then tyldm04=1; /*non-user*/
   else if regtyl04=2 then do;
  if tyld04=1 then tyldm04=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld04=2 then tyldm04=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld04=3 then tyldm04=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld04=4 then tyldm04=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld04 in (.,0,5) then tyldm04=.;
      end;
else tyldm04=.;


 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu04=1 then aspdd04=0; /*non-user*/
 else if regu04=2 then do;
 if aspd04=1 then aspdd04=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd04=2 then aspdd04=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd04=3 then aspdd04=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd04=4 then aspdd04=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd04 in (.,0,5) then aspdd04=.;
 end;
 else aspdd04=.;
 /*baby aspirin*/
 if regbab04=1 then babdd04=0; /*non-user*/
 else if regbab04=2 then do;
 if babd04=1 then babdd04=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd04=2 then babdd04=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd04=3 then babdd04=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd04=4 then babdd04=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd04 in (.,0,5) then babdd04=.;
 end;
 else babdd04=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd04=sum (babdd04, aspdd04); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd04=0 then totadm04=1; /*lowest category of days per month*/
 else if 0< totadd04 <=4 then totadm04=2; /*1-4 d/month*/
 else if 4< totadd04 <=14 then totadm04=3; /*5-14 d/month*/
 else if 15< totadd04<=21 then totadm04=4; /*15-21 d/month*/
 else if totadd04>21 then totadm04=5; /*22+ days/month*/


   if regibu04=1 then ibudd04=0; /*non-user*/
   else if regibu04=2 then do;
  if ibud04=1 then ibudd04=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud04=2 then ibudd04=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud04=3 then ibudd04=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud04=4 then ibudd04=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud04 in (.,0,5) then ibudd04=.;
      end;
else ibudd04=.;

if regtyl04=1 then tyldd04=0; /*non-user*/
   else if regtyl04=2 then do;
  if tyld04=1 then tyldd04=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld04=2 then tyldd04=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld04=3 then tyldd04=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld04=4 then tyldd04=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld04 in (.,0,5) then tyldd04=.;
      end;
else tyldd04=.;


 /**set each aspirin group to the median number of asp consumed**/
 if regu04=1 then nasp=0;/*non-user*/
 else if regu04=2 then do; 
 if nasp04=1 then nasp=1.5;
 else if nasp04=2 then nasp=4;
 else if nasp04=3 then nasp=10;
 else if nasp04=4 then nasp=20;
 else if nasp04 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab04=1 then nbab=0;/*non-user*/
 else if regbab04=2 then do; 
 if nbab04=1 then nbab=1.5;
 else if nbab04=2 then nbab=4;
 else if nbab04=3 then nbab=10;
 else if nbab04=4 then nbab=20;
 else if nbab04 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2004 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2004 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk04=naspeq;
 else if nasp ne . and naspeq eq . then aspwk04=nasp;
 else  aspwk04 = nasp+ naspeq; 

 if regu04=2 and nasp in (0,.) and naspeq in (0,.) then aspwk04=.;  /*changed*/
 else if regbab04=2 and nasp in (0,.) and naspeq in (0,.) then aspwk04=.;

 /*2004 intake asp/month*/
 aspmo04 = aspwk04 * 4.3; 

/*set each group the median number of nsaids consumed*/
   if regibu04=1 then ibuwk04=0; /*non-user*/
   else if regibu04=2 then do;
  if nibu04=1 then ibuwk04=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if nibu04=2 then ibuwk04=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if nibu04=3 then ibuwk04=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if nibu04=4 then ibuwk04=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if nibu04 in (.,0,5) then ibuwk04=.;
      end;
else ibuwk04=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl04=1 then tylwk04=0; /*non-user*/
   else if regtyl04=2 then do;
  if tyln04=1 then tylwk04=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyln04=2 then tylwk04=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyln04=3 then tylwk04=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyln04=4 then tylwk04=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyln04 in (.,0,5) then tylwk04=.;
      end;
else tylwk04=.; /*did not report any tylenol data*/


/*regular nsaid*/
if regibu04=1 and regnon04 in (.,1) and regcox04 in (.,1) then regnsad04=1;
else if regibu04 in (.,1) and regnon04=1 and regcox04 in (.,1) then regnsad04=1;
else if regibu04 in (.,1) and regnon04 in (.,1) and regcox04=1 then regnsad04=1;
else if regibu04=2 and regnon04 in (.,1,2) and regcox04 in (.,1,2) then regnsad04=2;
else if regibu04 in (.,1,2) and regnon04=2 and regcox04 in (.,1,2) then regnsad04=2;
else if regibu04 in (.,1,2) and regnon04 in (.,1,2) and regcox04=2 then regnsad04=2;



 /*regular aspirin or baby aspirin*/
 if regu04=1 and regbab04 in (.,1) then regaspb04=1;
 else if regu04 in (.,1) and regbab04=1 then regaspb04=1;
 else if regu04=2 and regbab04 in (.,1,2) then regaspb04=2;
 else if regu04 in (.,1,2) and regbab04=2 then regaspb04=2;

  /*2004 regular use of aspirin*/
 if  0<=aspwk04<2 then reguasp04=1; /*nonuser*/
 else if aspwk04>=2 then reguasp04=2; /*user*/
 else if aspwk04=. then reguasp04=.;

run;


/**********************************************
2006 data 
bab06: Use regulary? Baby Aspirin, 1=Yes
babd06: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab06: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp06: Use regulary? Aspirin, 1=Yes
aspd06: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp06: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur06(keep=q06 asp06 aspd06 nasp06 aspwk06 aspdm06 aspdd06 regu06 reguasp06
            bab06 babd06 nbab06 babdm06 babdd06 regbab06 regaspb06 
			regnsad06
            regtyl06 tyl06 tyld06 tyln06 tylwk06 tyldm06 tyldd06 
            regibu06 ibu06 ibud06 ibudm06 nibu06 ibuwk06 ibut06 
            ibudd06  regnon06 totadd06 totadm06
            celeb06 regcox06 );

/*regular users, irrespective of frequency or dose*/
 /*bring in 2006 nsaids*/
   if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
      if ibu06=1 then regibu06=2; /*regular ibuprofen user*/
      else regibu06=1; /*non user*/
      end;
   else regibu06=.; /*missing or nsaid*/

 /*bring in 2006 tylenol*/
   if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
      if tyl06=1 then regtyl06=2; /*regular tylenol user*/
      else regtyl06=1; /*non user*/
      end;
   else regtyl06=.; /*missing tylenol data*/

 /*bring in 2006 other anti-inflamm*/
   if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
      if ibut06=1 then regnon06=2; /*regular naprosyn user*/
      else regnon06=1; /*non user of naprosyn*/
      end;
   else regnon06=.; /*missing naprosyn data*/

 /*bring in 2006 COX-2*/
   if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
      if celeb06=1 then regcox06=2; /*regular COX-2 user*/
      else regcox06=1; /*non user of COX-2*/
      end;
   else regcox06=.; /*missing COX-2 data*/


 /*bring in 2006 aspirin*/
 if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
 if asp06=1 then regu06=2; 
 else regu06=1; /*non user*/
 end;
 else regu06=.; /*missing*/


/*bring in 2006 baby aspirin*/
 if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
 if bab06=1 then regbab06=2; /*regular baby aspirin user*/
 else regbab06=1; /*non user*/
 end;
 else regbab06=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu06=1 then aspdm06=1; /*non-user*/
 else if regu06=2 then do;
 if aspd06=1 then aspdm06=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd06=2 then aspdm06=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd06=3 then aspdm06=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd06=4 then aspdm06=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd06 in (.,0,5) then aspdm06=.;
 end;
 else aspdm06=.;

 if regbab06=1 then babdm06=1; /*non-user*/
 else if regbab06=2 then do;
 if babd06=1 then babdm06=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd06=2 then babdm06=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd06=3 then babdm06=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd06=4 then babdm06=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd06 in (.,0,5) then babdm06=.;
 end;
 else babdm06=.;

   if regibu06=1 then ibudm06=1; /*non-user*/
   else if regibu06=2 then do;
  if ibud06=1 then ibudm06=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud06=2 then ibudm06=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud06=3 then ibudm06=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud06=4 then ibudm06=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud06 in (.,0,5) then ibudm06=.;
      end;
else ibudm06=.;
      
if regtyl06=1 then tyldm06=1; /*non-user*/
   else if regtyl06=2 then do;
  if tyld06=1 then tyldm06=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld06=2 then tyldm06=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld06=3 then tyldm06=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld06=4 then tyldm06=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld06 in (.,0,5) then tyldm06=.;
      end;
else tyldm06=.;



 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu06=1 then aspdd06=0; /*non-user*/
 else if regu06=2 then do;
 if aspd06=1 then aspdd06=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd06=2 then aspdd06=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd06=3 then aspdd06=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd06=4 then aspdd06=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd06 in (.,0,5) then aspdd06=.;
 end;
 else aspdd06=.;
 /*baby aspirin*/
 if regbab06=1 then babdd06=0; /*non-user*/
 else if regbab06=2 then do;
 if babd06=1 then babdd06=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd06=2 then babdd06=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd06=3 then babdd06=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd06=4 then babdd06=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd06 in (.,0,5) then babdd06=.;
 end;
 else babdd06=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd06=sum (babdd06, aspdd06); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd06=0 then totadm06=1; /*lowest category of days per month*/
 else if 0< totadd06 <=4 then totadm06=2; /*1-4 d/month*/
 else if 4< totadd06 <=14 then totadm06=3; /*5-14 d/month*/
 else if 15< totadd06<=21 then totadm06=4; /*15-21 d/month*/
 else if totadd06>21 then totadm06=5; /*22+ days/month*/

   if regibu06=1 then ibudd06=0; /*non-user*/
   else if regibu06=2 then do;
  if ibud06=1 then ibudd06=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud06=2 then ibudd06=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud06=3 then ibudd06=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud06=4 then ibudd06=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud06 in (.,0,5) then ibudd06=.;
      end;
else ibudd06=.;

if regtyl06=1 then tyldd06=0; /*non-user*/
   else if regtyl06=2 then do;
  if tyld06=1 then tyldd06=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld06=2 then tyldd06=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld06=3 then tyldd06=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld06=4 then tyldd06=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld06 in (.,0,5) then tyldd06=.;
      end;
else tyldd06=.;


 /**set each aspirin group to the median number of asp consumed**/
 if regu06=1 then nasp=0;/*non-user*/
 else if regu06=2 then do; 
 if nasp06=1 then nasp=1.5;
 else if nasp06=2 then nasp=4;
 else if nasp06=3 then nasp=10;
 else if nasp06=4 then nasp=20;
 else if nasp06 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab06=1 then nbab=0;/*non-user*/
 else if regbab06=2 then do; 
 if nbab06=1 then nbab=1.5;
 else if nbab06=2 then nbab=4;
 else if nbab06=3 then nbab=10;
 else if nbab06=4 then nbab=20;
 else if nbab06 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2006 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2006 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk06=naspeq;
 else if nasp ne . and naspeq eq . then aspwk06=nasp;
 else  aspwk06 = nasp+ naspeq; 

 if regu06=2 and nasp in (0,.) and naspeq in (0,.) then aspwk06=.; /*changed*/
 else if regbab06=2 and nasp in (0,.) and naspeq in (0,.) then aspwk06=.;

 /*2006 intake asp/month*/
 aspmo06 = aspwk06 * 4.3; 

/*set each group the median number of nsaids consumed*/
   if regibu06=1 then ibuwk06=0; /*non-user*/
   else if regibu06=2 then do;
  if nibu06=1 then ibuwk06=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if nibu06=2 then ibuwk06=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if nibu06=3 then ibuwk06=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if nibu06=4 then ibuwk06=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if nibu06 in (.,0,5) then ibuwk06=.;
      end;
else ibuwk06=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl06=1 then tylwk06=0; /*non-user*/
   else if regtyl06=2 then do;
  if tyln06=1 then tylwk06=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyln06=2 then tylwk06=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyln06=3 then tylwk06=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyln06=4 then tylwk06=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyln06 in (.,0,5) then tylwk06=.;
      end;
else tylwk06=.; /*did not report any tylenol data*/


/*regular nsaid*/
if regibu06=1 and regnon06 in (.,1) and regcox06 in (.,1) then regnsad06=1;
else if regibu06 in (.,1) and regnon06=1 and regcox06 in (.,1) then regnsad06=1;
else if regibu06 in (.,1) and regnon06 in (.,1) and regcox06=1 then regnsad06=1;
else if regibu06=2 and regnon06 in (.,1,2) and regcox06 in (.,1,2) then regnsad06=2;
else if regibu06 in (.,1,2) and regnon06=2 and regcox06 in (.,1,2) then regnsad06=2;
else if regibu06 in (.,1,2) and regnon06 in (.,1,2) and regcox06=2 then regnsad06=2;


 /*regular aspirin or baby aspirin*/
 if regu06=1 and regbab06 in (.,1) then regaspb06=1;
 else if regu06 in (.,1) and regbab06=1 then regaspb06=1;
 else if regu06=2 and regbab06 in (.,1,2) then regaspb06=2;
 else if regu06 in (.,1,2) and regbab06=2 then regaspb06=2;

  /*2006 regular use of aspirin*/
 if  0<=aspwk06<2 then reguasp06=1; /*nonuser*/
 else if aspwk06>=2 then reguasp06=2; /*user*/
 else if aspwk06=. then reguasp06=.;

run;


/**********************************************
2008 data 
bab08: Use regulary? Baby Aspirin, 1=Yes
babd08: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab08: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp08: Use regulary? Aspirin, 1=Yes
aspd08: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp08: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur08(keep=q08 asp08 aspd08 nasp08 aspwk08 aspdm08 aspdd08 regu08 reguasp08
            bab08 babd08 nbab08 babdm08 babdd08 regbab08 regaspb08
			regnsad08
            regtyl08 tyl08 tyld08 tyln08 tylwk08 tyldm08 tyldd08 
            regibu08 ibu08 ibud08 ibudm08 nibu08 ibuwk08 ibut08 
            ibudd08  regnon08 totadd08 totadm08
            celeb08 regcox08 );

/*regular users, irrespective of frequency or dose*/
 /*bring in 2008 nsaids*/
   if q08 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if ibu08=1 then regibu08=2; /*regular ibuprofen user*/
      else regibu08=1; /*non user*/
      end;
   else regibu08=.; /*missing or nsaid*/

 /*bring in 2008 tylenol*/
   if q08 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if tyl08=1 then regtyl08=2; /*regular tylenol user*/
      else regtyl08=1; /*non user*/
      end;
   else regtyl08=.; /*missing tylenol data*/


 /*bring in 2008 other anti-inflamm*/
   if q08 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if ibut08=1 then regnon08=2; /*regular naprosyn user*/
      else regnon08=1; /*non user of naprosyn*/
      end;
   else regnon08=.; /*missing naprosyn data*/

 /*bring in 2008 COX-2*/
   if q08 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if celeb08=1 then regcox08=2; /*regular COX-2 user*/
      else regcox08=1; /*non user of COX-2*/
      end;
   else regcox08=.; /*missing COX-2 data*/


 /*bring in 2008 aspirin*/
 if q08 in (1,2) then do; /*filled out long or booklet questionnaire*/
 if asp08=1 then regu08=2; 
 else regu08=1; /*non user*/
 end;
 else regu08=.; /*missing*/


/*bring in 2008 baby aspirin*/
 if q08 in (1,2) then do; /*filled out long or booklet questionnaire*/
 if bab08=1 then regbab08=2; /*regular baby aspirin user*/
 else regbab08=1; /*non user*/
 end;
 else regbab08=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu08=1 then aspdm08=1; /*non-user*/
 else if regu08=2 then do;
 if aspd08=1 then aspdm08=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd08=2 then aspdm08=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd08=3 then aspdm08=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd08=4 then aspdm08=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd08 in (.,0,5) then aspdm08=.;
 end;
 else aspdm08=.;

 if regbab08=1 then babdm08=1; /*non-user*/
 else if regbab08=2 then do;
 if babd08=1 then babdm08=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd08=2 then babdm08=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd08=3 then babdm08=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd08=4 then babdm08=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd08 in (.,0,5) then babdm08=.;
 end;
 else babdm08=.;


   if regibu08=1 then ibudm08=1; /*non-user*/
   else if regibu08=2 then do;
  if ibud08=1 then ibudm08=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud08=2 then ibudm08=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud08=3 then ibudm08=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud08=4 then ibudm08=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud08 in (.,0,5) then ibudm08=.;
      end;
else ibudm08=.;
      
if regtyl08=1 then tyldm08=1; /*non-user*/
   else if regtyl08=2 then do;
  if tyld08=1 then tyldm08=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld08=2 then tyldm08=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld08=3 then tyldm08=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld08=4 then tyldm08=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld08 in (.,0,5) then tyldm08=.;
      end;
else tyldm08=.;



 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu08=1 then aspdd08=0; /*non-user*/
 else if regu08=2 then do;
 if aspd08=1 then aspdd08=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd08=2 then aspdd08=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd08=3 then aspdd08=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd08=4 then aspdd08=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd08 in (.,0,5) then aspdd08=.;
 end;
 else aspdd08=.;
 /*baby aspirin*/
 if regbab08=1 then babdd08=0; /*non-user*/
 else if regbab08=2 then do;
 if babd08=1 then babdd08=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd08=2 then babdd08=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd08=3 then babdd08=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd08=4 then babdd08=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd08 in (.,0,5) then babdd08=.;
 end;
 else babdd08=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd08=sum (babdd08, aspdd08); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd08=0 then totadm08=1; /*lowest category of days per month*/
 else if 0< totadd08 <=4 then totadm08=2; /*1-4 d/month*/
 else if 4< totadd08 <=14 then totadm08=3; /*5-14 d/month*/
 else if 15< totadd08<=21 then totadm08=4; /*15-21 d/month*/
 else if totadd08>21 then totadm08=5; /*22+ days/month*/


   if regibu08=1 then ibudd08=0; /*non-user*/
   else if regibu08=2 then do;
  if ibud08=1 then ibudd08=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud08=2 then ibudd08=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud08=3 then ibudd08=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud08=4 then ibudd08=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud08 in (.,0,5) then ibudd08=.;
      end;
else ibudd08=.;

if regtyl08=1 then tyldd08=0; /*non-user*/
   else if regtyl08=2 then do;
  if tyld08=1 then tyldd08=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld08=2 then tyldd08=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld08=3 then tyldd08=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld08=4 then tyldd08=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld08 in (.,0,5) then tyldd08=.;
      end;
else tyldd08=.;


 /**set each aspirin group to the median number of asp consumed**/
 if regu08=1 then nasp=0;/*non-user*/
 else if regu08=2 then do; 
 if nasp08=1 then nasp=1.5;
 else if nasp08=2 then nasp=4;
 else if nasp08=3 then nasp=10;
 else if nasp08=4 then nasp=20;
 else if nasp08 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab08=1 then nbab=0;/*non-user*/
 else if regbab08=2 then do; 
 if nbab08=1 then nbab=1.5;
 else if nbab08=2 then nbab=4;
 else if nbab08=3 then nbab=10;
 else if nbab08=4 then nbab=20;
 else if nbab08 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2008 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2008 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk08=naspeq;
 else if nasp ne . and naspeq eq . then aspwk08=nasp;
 else  aspwk08 = nasp+ naspeq; 

 if regu08=2 and nasp in (0,.) and naspeq in (0,.) then aspwk08=.; /*changed*/
 else if regbab08=2 and nasp in (0,.) and naspeq in (0,.) then aspwk08=.; /*changed*/

 /*2008 intake asp/month*/
 aspmo08 = aspwk08 * 4.3; 


/*set each group the median number of nsaids consumed*/
   if regibu08=1 then ibuwk08=0; /*non-user*/
   else if regibu08=2 then do;
  if nibu08=1 then ibuwk08=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if nibu08=2 then ibuwk08=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if nibu08=3 then ibuwk08=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if nibu08=4 then ibuwk08=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if nibu08 in (.,0,5) then ibuwk08=.;
      end;
else ibuwk08=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl08=1 then tylwk08=0; /*non-user*/
   else if regtyl08=2 then do;
  if tyln08=1 then tylwk08=1.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyln08=2 then tylwk08=4;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyln08=3 then tylwk08=10;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyln08=4 then tylwk08=20;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyln08 in (.,0,5) then tylwk08=.;
      end;
else tylwk08=.; /*did not report any tylenol data*/


/*regular nsaid*/
if regibu08=1 and regnon08 in (.,1) and regcox08 in (.,1) then regnsad08=1;
else if regibu08 in (.,1) and regnon08=1 and regcox08 in (.,1) then regnsad08=1;
else if regibu08 in (.,1) and regnon08 in (.,1) and regcox08=1 then regnsad08=1;
else if regibu08=2 and regnon08 in (.,1,2) and regcox08 in (.,1,2) then regnsad08=2;
else if regibu08 in (.,1,2) and regnon08=2 and regcox08 in (.,1,2) then regnsad08=2;
else if regibu08 in (.,1,2) and regnon08 in (.,1,2) and regcox08=2 then regnsad08=2;



 /*regular aspirin or baby aspirin*/
 if regu08=1 and regbab08 in (.,1) then regaspb08=1;
 else if regu08 in (.,1) and regbab08=1 then regaspb08=1;
 else if regu08=2 and regbab08 in (.,1,2) then regaspb08=2;
 else if regu08 in (.,1,2) and regbab08=2 then regaspb08=2;

  /*2008 regular use of aspirin*/
 if  0<=aspwk08<2 then reguasp08=1; /*nonuser*/
 else if aspwk08>=2 then reguasp08=2; /*user*/
 else if aspwk08=. then reguasp08=.;

run;

/**********************************************
2010 data 
bab10: Use regulary? Baby Aspirin, 1=Yes
babd10: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab10: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp0: Use regulary? Aspirin, 1=Yes
aspd10: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp10: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur10(keep=q10 asp10 aspd10 nasp10 aspwk10 aspdm10 aspdd10 regu10 reguasp10
            bab10 babd10 nbab10 babdm10 babdd10 regbab10 regaspb10 regnsad10
            regtyl10 tyl10 tyld10 tyln10 tylwk10 tyldm10 tyldd10 
            regibu10 ibu10 ibud10 ibudm10 nibu10 ibuwk10 ibut10 ibudd10
            regnon10 totadd10 totadm10
            celeb10 regcox10 );
/*q10 questionnaire type:  1 six page w/diet;
	                      2 bklet w/diet;
	                      3 two page;
	                      4 short;*          */
/**this year 2 page include aspirin questions*****/
/*regular users, irrespective of frequency or dose*/
 /*bring in 2010 nsaids*/
   if q10 in (1,2,3) then do; /*filled out long, booklet, pg1-2 questionnaire*/
      if ibu10=1 then regibu10=2; /*regular ibuprofen user*/
      else regibu10=1; /*non user*/
      end;
   else regibu10=.; /*missing nsaid*/

 /*bring in 2010 tylenol*/
   if q10 in (1,2,3) then do; /*filled out long, booklet, pg1-2 questionnaire*/
      if tyl10=1 then regtyl10=2; /*regular tylenol user*/
      else regtyl10=1; /*non user*/
      end;
   else regtyl10=.; /*missing tylenol data*/


 /*bring in 2010 other anti-inflamm*/
   if q10 in (1,2,3) then do; /*filled out long, booklet, pg1-2 questionnaire*/
      if ibut10=1 then regnon10=2; /*regular naprosyn user*/
      else regnon10=1; /*non user of naprosyn*/
      end;
   else regnon10=.; /*missing naprosyn data*/

 /*bring in 2010 COX-2*/
   if q10 in (1,2,3) then do; /*filled out long, booklet, pg1-2 questionnaire*/
      if celeb10=1 then regcox10=2; /*regular COX-2 user*/
      else regcox10=1; /*non user of COX-2*/
      end;
   else regcox10=.; /*missing COX-2 data*/


 /*bring in 2010 aspirin*/
 if q10 in (1,2,3) then do; /*filled out long, booklet, pg1-2 questionnaire*/
     if asp10=1 then regu10=2; 
     else regu10=1; /*non user*/
     end;
 else regu10=.; /*missing*/


/*bring in 2010 baby aspirin*/
 if q10 in (1,2,3) then do; /*filled out long, booklet, pg1-2 questionnaire*/
     if bab10=1 then regbab10=2; /*regular baby aspirin user*/
     else regbab10=1; /*non user*/
     end;
 else regbab10=.; /*missing baby aspirin data*/


 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu10=1 then aspdm10=1; /*non-user*/
 else if regu10=2 then do;
 if aspd10=1 then aspdm10=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd10=2 then aspdm10=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd10=3 then aspdm10=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd10=4 then aspdm10=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd10 in (.,0,5) then aspdm10=.;
 end;
 else aspdm10=.;

 if regbab10=1 then babdm10=1; /*non-user*/
 else if regbab10=2 then do;
 if babd10=1 then babdm10=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd10=2 then babdm10=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd10=3 then babdm10=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd10=4 then babdm10=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd10 in (.,0,5) then babdm10=.;
 end;
 else babdm10=.;

 if regibu10=1 then ibudm10=1; /*non-user*/
   else if regibu10=2 then do;
  if ibud10=1 then ibudm10=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud10=2 then ibudm10=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud10=3 then ibudm10=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud10=4 then ibudm10=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud10 in (.,0,5) then ibudm10=.;
      end;
else ibudm10=.;
      
if regtyl10=1 then tyldm10=1; /*non-user*/
   else if regtyl10=2 then do;
  if tyld10=1 then tyldm10=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld10=2 then tyldm10=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld10=3 then tyldm10=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld10=4 then tyldm10=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld10 in (.,0,5) then tyldm10=.;
      end;
else tyldm10=.;



 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu10=1 then aspdd10=0; /*non-user*/
 else if regu10=2 then do;
 if aspd10=1 then aspdd10=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd10=2 then aspdd10=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd10=3 then aspdd10=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd10=4 then aspdd10=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd10 in (.,0,5) then aspdd10=.;
 end;
 else aspdd10=.;

 /*baby aspirin*/
 if regbab10=1 then babdd10=0; /*non-user*/
 else if regbab10=2 then do;
 if babd10=1 then babdd10=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd10=2 then babdd10=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd10=3 then babdd10=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd10=4 then babdd10=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd10 in (.,0,5) then babdd10=.;
 end;
 else babdd10=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd10=sum (babdd10, aspdd10); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd10=0 then totadm10=1; /*lowest category of days per month*/
 else if 0< totadd10 <=4 then totadm10=2; /*1-4 d/month*/
 else if 4< totadd10 <=14 then totadm10=3; /*5-14 d/month*/
 else if 15< totadd10<=21 then totadm10=4; /*15-21 d/month*/
 else if totadd10>21 then totadm10=5; /*22+ days/month*/


   if regibu10=1 then ibudd10=0; /*non-user*/
   else if regibu10=2 then do;
  if ibud10=1 then ibudd10=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud10=2 then ibudd10=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud10=3 then ibudd10=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud10=4 then ibudd10=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud10 in (.,0,5) then ibudd10=.;
      end;
else ibudd10=.;

if regtyl10=1 then tyldd10=0; /*non-user*/
   else if regtyl10=2 then do;
  if tyld10=1 then tyldd10=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld10=2 then tyldd10=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld10=3 then tyldd10=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld10=4 then tyldd10=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld10 in (.,0,5) then tyldd10=.;
      end;
else tyldd10=.;


 /**set each aspirin group to the median number of asp consumed**/
 if regu10=1 then nasp=0;/*non-user*/
 else if regu10=2 then do; 
 if nasp10=1 then nasp=1.5;
 else if nasp10=2 then nasp=4;
 else if nasp10=3 then nasp=10;
 else if nasp10=4 then nasp=20;
 else if nasp10 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab10=1 then nbab=0;/*non-user*/
 else if regbab10=2 then do; 
 if nbab10=1 then nbab=1.5;
 else if nbab10=2 then nbab=4;
 else if nbab10=3 then nbab=10;
 else if nbab10=4 then nbab=20;
 else if nbab10 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2010 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2010 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk10=naspeq;
 else if nasp ne . and naspeq eq . then aspwk10=nasp;
 else  aspwk10 = nasp+ naspeq; 

 if regu10=2 and nasp in (0,.) and naspeq in (0,.) then aspwk10=.; /*changed*/
 else if regbab10=2 and nasp in (0,.) and naspeq in (0,.) then aspwk10=.; /*changed*/

 /*2010 intake asp/month*/
 aspmo10 = aspwk10 * 4.3; 


/*set each group the median number of nsaids consumed*/
   if regibu10=1 then ibuwk10=0; /*non-user*/
   else if regibu10=2 then do;
  if nibu10=1 then ibuwk10=1.5; /*1-2 Tabs/week*/
else if nibu10=2 then ibuwk10=4;/*3-5 Tabs/week*/
else if nibu10=3 then ibuwk10=10;/*6-14 Tabs/week*/
else if nibu10=4 then ibuwk10=20;/*15+ Tabs/week*/
else if nibu10 in (.,0,5) then ibuwk10=.;
      end;
else ibuwk10=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl10=1 then tylwk10=0; /*non-user*/
   else if regtyl10=2 then do;
  if tyln10=1 then tylwk10=1.5; /*1-2 Tabs/week*/
else if tyln10=2 then tylwk10=4;/*3-5 Tabs/week*/
else if tyln10=3 then tylwk10=10;/*6-14 Tabs/week*/
else if tyln10=4 then tylwk10=20;/*15+ Tabs/week*/
else if tyln10 in (.,0,5) then tylwk10=.;
      end;
else tylwk10=.; /*did not report any tylenol data*/


/*regular nsaid*/
if regibu10=1 and regnon10 in (.,1) and regcox10 in (.,1) then regnsad10=1;
else if regibu10 in (.,1) and regnon10=1 and regcox10 in (.,1) then regnsad10=1;
else if regibu10 in (.,1) and regnon10 in (.,1) and regcox10=1 then regnsad10=1;
else if regibu10=2 and regnon10 in (.,1,2) and regcox10 in (.,1,2) then regnsad10=2;
else if regibu10 in (.,1,2) and regnon10=2 and regcox10 in (.,1,2) then regnsad10=2;
else if regibu10 in (.,1,2) and regnon10 in (.,1,2) and regcox10=2 then regnsad10=2;



 /*regular aspirin or baby aspirin*/
 if regu10=1 and regbab10 in (.,1) then regaspb10=1;
 else if regu10 in (.,1) and regbab10=1 then regaspb10=1;
 else if regu10=2 and regbab10 in (.,1,2) then regaspb10=2;
 else if regu10 in (.,1,2) and regbab10=2 then regaspb10=2;

  /*2010 regular use of aspirin*/
 if  0<=aspwk10<2 then reguasp10=1; /*nonuser*/
 else if aspwk10>=2 then reguasp10=2; /*user*/
 else if aspwk10=. then reguasp10=.;

run;


/**********************************************
2012 data 
bab12: Use regulary? Baby Aspirin, 1=Yes
babd12: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab12: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp12: Use regulary? Aspirin, 1=Yes
aspd12: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp12: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur12(keep=q12 asp12 aspd12 nasp12 aspwk12 aspdm12 aspdd12 regu12 reguasp12
            bab12 babd12 nbab12 babdm12 babdd12 regbab12 regaspb12 regnsad12
            regtyl12 tyl12 tyld12 tyln12 tylwk12 tyldm12 tyldd12 
            regibu12 ibu12 ibud12 ibudm12 nibu12 ibuwk12 ibut12 ibudd12
            regnon12 totadd12 totadm12
            celeb12 regcox12 );

/*regular users, irrespective of frequency or dose*/
 /*bring in 2012 nsaids*/
   if q12 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if ibu12=1 then regibu12=2; /*regular ibuprofen user*/
      else regibu12=1; /*non user*/
      end;
   else regibu12=.; /*missing or nsaid*/

 /*bring in 2012 tylenol*/
   if q12 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if tyl12=1 then regtyl12=2; /*regular tylenol user*/
      else regtyl12=1; /*non user*/
      end;
   else regtyl12=.; /*missing tylenol data*/


 /*bring in 2012 other anti-inflamm*/
   if q12 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if ibut12=1 then regnon12=2; /*regular naprosyn user*/
      else regnon12=1; /*non user of naprosyn*/
      end;
   else regnon12=.; /*missing naprosyn data*/

 /*bring in 2012 COX-2*/
   if q12 in (1,2) then do; /*filled out long or booklet questionnaire*/
      if celeb12=1 then regcox12=2; /*regular COX-2 user*/
      else regcox12=1; /*non user of COX-2*/
      end;
   else regcox12=.; /*missing COX-2 data*/


 /*bring in 2012 aspirin*/
 if q12 in (1,2) then do; /*filled out long or booklet questionnaire*/
 if asp12=1 then regu12=2; 
 else regu12=1; /*non user*/
 end;
 else regu12=.; /*missing*/


/*bring in 2012 baby aspirin*/
 if q12 in (1,2) then do; /*filled out long or booklet questionnaire*/
 if bab12=1 then regbab12=2; /*regular baby aspirin user*/
 else regbab12=1; /*non user*/
 end;
 else regbab12=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu12=1 then aspdm12=1; /*non-user*/
 else if regu12=2 then do;
 if aspd12=1 then aspdm12=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd12=2 then aspdm12=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd12=3 then aspdm12=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd12=4 then aspdm12=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd12 in (.,0,5) then aspdm12=.;
 end;
 else aspdm12=.;

 if regbab12=1 then babdm12=1; /*non-user*/
 else if regbab12=2 then do;
 if babd12=1 then babdm12=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd12=2 then babdm12=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd12=3 then babdm12=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd12=4 then babdm12=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd12 in (.,0,5) then babdm12=.;
 end;
 else babdm12=.;


   if regibu12=1 then ibudm12=1; /*non-user*/
   else if regibu12=2 then do;
  if ibud12=1 then ibudm12=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud12=2 then ibudm12=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud12=3 then ibudm12=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud12=4 then ibudm12=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud12 in (.,0,5) then ibudm12=.;
      end;
else ibudm12=.;
      
if regtyl12=1 then tyldm12=1; /*non-user*/
   else if regtyl12=2 then do;
  if tyld12=1 then tyldm12=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld12=2 then tyldm12=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld12=3 then tyldm12=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld12=4 then tyldm12=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld12 in (.,0,5) then tyldm12=.;
      end;
else tyldm12=.;



 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu12=1 then aspdd12=0; /*non-user*/
 else if regu12=2 then do;
 if aspd12=1 then aspdd12=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd12=2 then aspdd12=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd12=3 then aspdd12=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd12=4 then aspdd12=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd12 in (.,0,5) then aspdd12=.;
 end;
 else aspdd12=.;
 /*baby aspirin*/
 if regbab12=1 then babdd12=0; /*non-user*/
 else if regbab12=2 then do;
 if babd12=1 then babdd12=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd12=2 then babdd12=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd12=3 then babdd12=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd12=4 then babdd12=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd12 in (.,0,5) then babdd12=.;
 end;
 else babdd12=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd12=sum (babdd12, aspdd12); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd12=0 then totadm12=1; /*lowest category of days per month*/
 else if 0< totadd12 <=4 then totadm12=2; /*1-4 d/month*/
 else if 4< totadd12 <=14 then totadm12=3; /*5-14 d/month*/
 else if 15< totadd12<=21 then totadm12=4; /*15-21 d/month*/
 else if totadd12>21 then totadm12=5; /*22+ days/month*/


   if regibu12=1 then ibudd12=0; /*non-user*/
   else if regibu12=2 then do;
  if ibud12=1 then ibudd12=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud12=2 then ibudd12=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud12=3 then ibudd12=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud12=4 then ibudd12=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud12 in (.,0,5) then ibudd12=.;
      end;
else ibudd12=.;

if regtyl12=1 then tyldd12=0; /*non-user*/
   else if regtyl12=2 then do;
  if tyld12=1 then tyldd12=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld12=2 then tyldd12=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld12=3 then tyldd12=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld12=4 then tyldd12=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld12 in (.,0,5) then tyldd12=.;
      end;
else tyldd12=.;


 /**set each aspirin group to the median number of asp consumed**/
 if regu12=1 then nasp=0;/*non-user*/
 else if regu12=2 then do; 
 if nasp12=1 then nasp=1.5;
 else if nasp12=2 then nasp=4;
 else if nasp12=3 then nasp=10;
 else if nasp12=4 then nasp=20;
 else if nasp12 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab12=1 then nbab=0;/*non-user*/
 else if regbab12=2 then do; 
 if nbab12=1 then nbab=1.5;
 else if nbab12=2 then nbab=4;
 else if nbab12=3 then nbab=10;
 else if nbab12=4 then nbab=20;
 else if nbab12 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2012 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2012 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk12=naspeq;
 else if nasp ne . and naspeq eq . then aspwk12=nasp;
 else  aspwk12 = nasp+ naspeq; 

 if regu12=2 and nasp in (0,.) and naspeq in (0,.) then aspwk12=.; /*changed*/
 else if regbab12=2 and nasp in (0,.) and naspeq in (0,.) then aspwk12=.; /*changed*/

 /*2012 intake asp/month*/
 aspmo12 = aspwk12 * 4.3; 


/*set each group the median number of nsaids consumed*/
   if regibu12=1 then ibuwk12=0; /*non-user*/
   else if regibu12=2 then do;
  if nibu12=1 then ibuwk12=1.5; 
else if nibu12=2 then ibuwk12=4;
else if nibu12=3 then ibuwk12=10;
else if nibu12=4 then ibuwk12=20;
else if nibu12 in (.,0,5) then ibuwk12=.;
      end;
else ibuwk12=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl12=1 then tylwk12=0; /*non-user*/
   else if regtyl12=2 then do;
  if tyln12=1 then tylwk12=1.5; 
else if tyln12=2 then tylwk12=4;
else if tyln12=3 then tylwk12=10;
else if tyln12=4 then tylwk12=20;
else if tyln12 in (.,0,5) then tylwk12=.;
      end;
else tylwk12=.; /*did not report any tylenol data*/


/*regular nsaid*/
if regibu12=1 and regnon12 in (.,1) and regcox12 in (.,1) then regnsad12=1;
else if regibu12 in (.,1) and regnon12=1 and regcox12 in (.,1) then regnsad12=1;
else if regibu12 in (.,1) and regnon12 in (.,1) and regcox12=1 then regnsad12=1;
else if regibu12=2 and regnon12 in (.,1,2) and regcox12 in (.,1,2) then regnsad12=2;
else if regibu12 in (.,1,2) and regnon12=2 and regcox12 in (.,1,2) then regnsad12=2;
else if regibu12 in (.,1,2) and regnon12 in (.,1,2) and regcox12=2 then regnsad12=2;


 /*regular aspirin or baby aspirin*/
 if regu12=1 and regbab12 in (.,1) then regaspb12=1;
 else if regu12 in (.,1) and regbab12=1 then regaspb12=1;
 else if regu12=2 and regbab12 in (.,1,2) then regaspb12=2;
 else if regu12 in (.,1,2) and regbab12=2 then regaspb12=2;

  /*2012 regular use of aspirin*/
 if  0<=aspwk12<2 then reguasp12=1; /*nonuser*/
 else if aspwk12>=2 then reguasp12=2; /*user*/
 else if aspwk12=. then reguasp12=.;

run;

/**********************************************
2014 data 
bab14: Use regulary? Baby Aspirin, 1=Yes
babd14: Baby Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nbab14: Baby Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
asp14: Use regulary? Aspirin, 1=Yes
aspd14: Aspirin Days/wk
        1=1, 2=2-3, 3=4-5, 4=6+, 5=pt
nasp14: Aspirin Tabs/wk
        1=1-2, 2=3-5, 3=6-14, 4=15+, 5=pt
***********************************************/
%nur14(keep=q14 asp14 aspd14 nasp14 aspwk14 aspdm14 aspdd14 regu14 reguasp14
            bab14 babd14 nbab14 babdm14 babdd14 regbab14 regaspb14 regnsad14
            regtyl14 tyl14 tyld14 tyln14 tylwk14 tyldm14 tyldd14 
            regibu14 ibu14 ibud14 ibudm14 nibu14 ibuwk14 ibut14 ibudd14
            regnon14 totadd14 totadm14
            celeb14 regcox14 );

/*regular users, irrespective of frequency or dose*/
 /*bring in 2014 nsaids*/
   if q14 in (1,2) then do; /*filled out long paper or web questionnaire*/
      if ibu14=1 then regibu14=2; /*regular ibuprofen user*/
      else regibu14=1; /*non user*/
      end;
   else regibu14=.; /*missing or nsaid*/

 /*bring in 2014 tylenol*/
   if q14 in (1,2) then do; /*filled out long paper or web questionnaire*/
      if tyl14=1 then regtyl14=2; /*regular tylenol user*/
      else regtyl14=1; /*non user*/
      end;
   else regtyl14=.; /*missing tylenol data*/


 /*bring in 2014 other anti-inflamm*/
   if q14 in (1,2) then do; /*filled out long paper or web questionnaire*/
      if ibut14=1 then regnon14=2; /*regular naprosyn user*/
      else regnon14=1; /*non user of naprosyn*/
      end;
   else regnon14=.; /*missing naprosyn data*/

 /*bring in 2014 COX-2*/
   if q14 in (1,2) then do; /*filled out long paper or web questionnaire*/
      if celeb14=1 then regcox14=2; /*regular COX-2 user*/
      else regcox14=1; /*non user of COX-2*/
      end;
   else regcox14=.; /*missing COX-2 data*/


 /*bring in 2014 aspirin*/
 if q14 in (1,2) then do; /*filled out long paper or web questionnaire*/
 if asp14=1 then regu14=2; 
 else regu14=1; /*non user*/
 end;
 else regu14=.; /*missing*/


/*bring in 2014 baby aspirin*/
 if q14 in (1,2) then do; /*filled out long paper or web questionnaire*/
 if bab14=1 then regbab14=2; /*regular baby aspirin user*/
 else regbab14=1; /*non user*/
 end;
 else regbab14=.; /*missing baby aspirin data*/

 /*Days per month in categories - using days/week and make
 consistent with days per month from 1990 and 1992 questionnaires */
 if regu14=1 then aspdm14=1; /*non-user*/
 else if regu14=2 then do;
 if aspd14=1 then aspdm14=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd14=2 then aspdm14=3;/*2-3 day/week= 5-14 d/month from 90,92 questionnaire*/
 else if aspd14=3 then aspdm14=4;/*4-5 day/week= 15-21 d/month from 90,92 questionnaire*/
 else if aspd14=4 then aspdm14=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd14 in (.,0,5) then aspdm14=.;
 end;
 else aspdm14=.;

 if regbab14=1 then babdm14=1; /*non-user*/
 else if regbab14=2 then do;
 if babd14=1 then babdm14=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd14=2 then babdm14=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd14=3 then babdm14=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd14=4 then babdm14=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd14 in (.,0,5) then babdm14=.;
 end;
 else babdm14=.;


   if regibu14=1 then ibudm14=1; /*non-user*/
   else if regibu14=2 then do;
  if ibud14=1 then ibudm14=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud14=2 then ibudm14=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud14=3 then ibudm14=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud14=4 then ibudm14=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud14 in (.,0,5) then ibudm14=.;
      end;
else ibudm14=.;
      
if regtyl14=1 then tyldm14=1; /*non-user*/
   else if regtyl14=2 then do;
  if tyld14=1 then tyldm14=2; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld14=2 then tyldm14=3;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld14=3 then tyldm14=4;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld14=4 then tyldm14=5;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld14 in (.,0,5) then tyldm14=.;
      end;
else tyldm14=.;



 /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
 /*aspirin*/
 if regu14=1 then aspdd14=0; /*non-user*/
 else if regu14=2 then do;
 if aspd14=1 then aspdd14=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if aspd14=2 then aspdd14=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if aspd14=3 then aspdd14=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if aspd14=4 then aspdd14=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if aspd14 in (.,0,5) then aspdd14=.;
 end;
 else aspdd14=.;
 /*baby aspirin*/
 if regbab14=1 then babdd14=0; /*non-user*/
 else if regbab14=2 then do;
 if babd14=1 then babdd14=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
 else if babd14=2 then babdd14=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
 else if babd14=3 then babdd14=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
 else if babd14=4 then babdd14=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
 else if babd14 in (.,0,5) then babdd14=.;
 end;
 else babdd14=.;

 /*create a composite category of aspirin frequency which includes baby and full aspirin*/
 totadd14=sum (babdd14, aspdd14); 
 /*sum of all aspirin days - this can also be used as a continous variable for trend*/
 if totadd14=0 then totadm14=1; /*lowest category of days per month*/
 else if 0< totadd14 <=4 then totadm14=2; /*1-4 d/month*/
 else if 4< totadd14 <=14 then totadm14=3; /*5-14 d/month*/
 else if 15< totadd14<=21 then totadm14=4; /*15-21 d/month*/
 else if totadd14>21 then totadm14=5; /*22+ days/month*/


   if regibu14=1 then ibudd14=0; /*non-user*/
   else if regibu14=2 then do;
  if ibud14=1 then ibudd14=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if ibud14=2 then ibudd14=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if ibud14=3 then ibudd14=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if ibud14=4 then ibudd14=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if ibud14 in (.,0,5) then ibudd14=.;
      end;
else ibudd14=.;

if regtyl14=1 then tyldd14=0; /*non-user*/
   else if regtyl14=2 then do;
  if tyld14=1 then tyldd14=2.5; /*1 day/week= 1-4 d/month from 90,92 questionnaire*/
else if tyld14=2 then tyldd14=9.5;/*2-3 day/week==5-14 d/month from 90,92 questionnaire*/
else if tyld14=3 then tyldd14=18;/*4-5 day/week=15-21 d/month from 90,92 questionnaire*/
else if tyld14=4 then tyldd14=22;/*6+ days/week = >=22 d/month from 90,92 questionnaire*/
else if tyld14 in (.,0,5) then tyldd14=.;
      end;
else tyldd14=.;


 /**set each aspirin group to the median number of asp consumed**/
 if regu14=1 then nasp=0;/*non-user*/
 else if regu14=2 then do; 
 if nasp14=1 then nasp=1.5;
 else if nasp14=2 then nasp=4;
 else if nasp14=3 then nasp=10;
 else if nasp14=4 then nasp=20;
 else if nasp14 in(.,0,5) then nasp=.;
 end;
 else nasp=.;

 /**set each baby aspirin group to the median number of asp consumed**/
 if regbab14=1 then nbab=0;/*non-user*/
 else if regbab14=2 then do; 
 if nbab14=1 then nbab=1.5;
 else if nbab14=2 then nbab=4;
 else if nbab14=3 then nbab=10;
 else if nbab14=4 then nbab=20;
 else if nbab14 in(.,0,5) then nbab=.;
 end;
 else nbab=.;

 /*2014 average asp per week*/
 naspeq=nbab/4; /*number of aspirin equivalents*/
 /*2014 intake asp/week*/
 if nasp eq . and naspeq ne . then aspwk14=naspeq;
 else if nasp ne . and naspeq eq . then aspwk14=nasp;
 else  aspwk14 = nasp+ naspeq; 

 if regu14=2 and nasp in (0,.) and naspeq in (0,.) then aspwk14=.; /*changed*/
 else if regbab14=2 and nasp in (0,.) and naspeq in (0,.) then aspwk14=.; /*changed*/

 /*2014 intake asp/month*/
 aspmo14 = aspwk14 * 4.3; 


/*set each group the median number of nsaids consumed*/
   if regibu14=1 then ibuwk14=0; /*non-user*/
   else if regibu14=2 then do;
  if nibu14=1 then ibuwk14=1.5; 
else if nibu14=2 then ibuwk14=4;
else if nibu14=3 then ibuwk14=10;
else if nibu14=4 then ibuwk14=20;
else if nibu14 in (.,0,5) then ibuwk14=.;
      end;
else ibuwk14=.; /*did not report any nsaid data*/
   
  
/*set each group the median number of tylenol consumed*/
   if regtyl14=1 then tylwk14=0; /*non-user*/
   else if regtyl14=2 then do;
  if tyln14=1 then tylwk14=1.5; 
else if tyln14=2 then tylwk14=4;
else if tyln14=3 then tylwk14=10;
else if tyln14=4 then tylwk14=20;
else if tyln14 in (.,0,5) then tylwk14=.;
      end;
else tylwk14=.; /*did not report any tylenol data*/


/*regular nsaid*/
if regibu14=1 and regnon14 in (.,1) and regcox14 in (.,1) then regnsad14=1;
else if regibu14 in (.,1) and regnon14=1 and regcox14 in (.,1) then regnsad14=1;
else if regibu14 in (.,1) and regnon14 in (.,1) and regcox14=1 then regnsad14=1;
else if regibu14=2 and regnon14 in (.,1,2) and regcox14 in (.,1,2) then regnsad14=2;
else if regibu14 in (.,1,2) and regnon14=2 and regcox14 in (.,1,2) then regnsad14=2;
else if regibu14 in (.,1,2) and regnon14 in (.,1,2) and regcox14=2 then regnsad14=2;


 /*regular aspirin or baby aspirin*/
 if regu14=1 and regbab14 in (.,1) then regaspb14=1;
 else if regu14 in (.,1) and regbab14=1 then regaspb14=1;
 else if regu14=2 and regbab14 in (.,1,2) then regaspb14=2;
 else if regu14 in (.,1,2) and regbab14=2 then regaspb14=2;

  /*2014 regular use of aspirin*/
 if  0<=aspwk14<2 then reguasp14=1; /*nonuser*/
 else if aspwk14>=2 then reguasp14=2; /*user*/
 else if aspwk14=. then reguasp14=.;

run;

/*merge aspirin files*/
data nhaspone;
merge meds8016 nur82 nur84 nur88 nur90 nur92 nur94 nur96 nur98 
      nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14;
by id;

***Aspirin array***;
/*Carry forward or backward if missing and creat new aspirin variables*/
/*1986 is not included in the array*/
/*any use of aspirin*/
array anyasp{*} anyasp80 anyasp82 anyasp84 anyasp88 anyasp90 anyasp92 anyasp94
                anyasp96 anyasp98 regaspb00 regaspb02 regaspb04 regaspb06 regaspb08
                regaspb10 regaspb12 regaspb14; /*regaspb include baby asp*/
array anyasppre{*} anyasppre80 anyasppre82 anyasppre84 anyasppre88 anyasppre90 anyasppre92 anyasppre94 
                   anyasppre96 anyasppre98 anyasppre00 anyasppre02 anyasppre04 anyasppre06 anyasppre08
                   anyasppre10 anyasppre12 anyasppre14;
array anyasppost{*} anyasppost80 anyasppost82 anyasppost84 anyasppost88 anyasppost90 anyasppost92 anyasppost94 
                    anyasppost96 anyasppost98 anyasppost00 anyasppost02 anyasppost04 anyasppost06 anyasppost08
                    anyasppost10 anyasppost12 anyasppost14;
array anyaspcarry{*} anyaspcarry80 anyaspcarry82 anyaspcarry84 anyaspcarry88 anyaspcarry90 anyaspcarry92 anyaspcarry94
                     anyaspcarry96 anyaspcarry98 anyaspcarry00 anyaspcarry02 anyaspcarry04 anyaspcarry06 anyaspcarry08
                     anyaspcarry10 anyaspcarry12 anyaspcarry14;

/*aspirin intake tabs/week*/
array aspwk{*} aspwk80 aspwk82 aspwk84 aspwk88 aspwk90 aspwk92 aspwk94 
               aspwk96 aspwk98 aspwk00 aspwk02 aspwk04 aspwk06 aspwk08
               aspwk10 aspwk12 aspwk14;
array aspwkpre{*} aspwkpre80 aspwkpre82 aspwkpre84 aspwkpre88 aspwkpre90 aspwkpre92 aspwkpre94 
                  aspwkpre96 aspwkpre98 aspwkpre00 aspwkpre02 aspwkpre04 aspwkpre06 aspwkpre08
                  aspwkpre10 aspwkpre12 aspwkpre14;			   
array aspwkpost{*} aspwkpost80 aspwkpost82 aspwkpost84 aspwkpost88 aspwkpost90 aspwkpost92 aspwkpost94 
                   aspwkpost96 aspwkpost98 aspwkpost00 aspwkpost02 aspwkpost04 aspwkpost06 aspwkpost08
                   aspwkpost10 aspwkpost12 aspwkpost14;
array avaspwkpre{*} avaspwkpre80 avaspwkpre82 avaspwkpre84 avaspwkpre88 avaspwkpre90 avaspwkpre92 avaspwkpre94 
                     avaspwkpre96 avaspwkpre98 avaspwkpre00 avaspwkpre02 avaspwkpre04 avaspwkpre06 avaspwkpre08
                     avaspwkpre10 avaspwkpre12 avaspwkpre14;
array aspwkcarry{*} aspwkcarry80 aspwkcarry82 aspwkcarry84 aspwkcarry88 aspwkcarry90 aspwkcarry92 aspwkcarry94 
                    aspwkcarry96 aspwkcarry98 aspwkcarry00 aspwkcarry02 aspwkcarry04 aspwkcarry06 aspwkcarry08
                    aspwkcarry10 aspwkcarry12 aspwkcarry14;
array avaspwkcarry{*} avaspwkcarry80 avaspwkcarry82 avaspwkcarry84 avaspwkcarry88 avaspwkcarry90 avaspwkcarry92 avaspwkcarry94 
                      avaspwkcarry96 avaspwkcarry98 avaspwkcarry00 avaspwkcarry02 avaspwkcarry04 avaspwkcarry06 avaspwkcarry08
                      avaspwkcarry10 avaspwkcarry12 avaspwkcarry14;


/*regular use of aspirin (2+ tabs/week)*/					 
array reguasp{*} reguasp80 reguasp82 reguasp84 reguasp88 reguasp90 reguasp92 reguasp94
                 reguasp96 reguasp98 reguasp00 reguasp02 reguasp04 reguasp06 reguasp08
                 reguasp10 reguasp12 reguasp14;
array regaspre{*} regaspre80 regaspre82 regaspre84 regaspre88 regaspre90 regaspre92 regaspre94
                  regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08
                  regaspre10 regaspre12 regaspre14;
array regaspost{*} regaspost80 regaspost82 regaspost84 regaspost88 regaspost90 regaspost92 regaspost94
                   regaspost96 regaspost98 regaspost00 regaspost02 regaspost04 regaspost06 regaspost08
                   regaspost10 regaspost12 regaspost14;
array avregaspre{*} avregaspre80 avregaspre82 avregaspre84 avregaspre88 avregaspre90 avregaspre92 avregaspre94
                    avregaspre96 avregaspre98 avregaspre00 avregaspre02 avregaspre04 avregaspre06 avregaspre08
                    avregaspre10 avregaspre12 avregaspre14;
array regascarry{*} regascarry80 regascarry82 regascarry84 regascarry88 regascarry90 regascarry92 regascarry94
                    regascarry96 regascarry98 regascarry00 regascarry02 regascarry04 regascarry06 regascarry08
                    regascarry10 regascarry12 regascarry14;
array avregcarry{*} avregcarry80 avregcarry82 avregcarry84 avregcarry88 avregcarry90 avregcarry92 avregcarry94
                    avregcarry96 avregcarry98 avregcarry00 avregcarry02 avregcarry04 avregcarry06 avregcarry08
                    avregcarry10 avregcarry12 avregcarry14;

/*duration of regular use of aspirin*/
array adur{*} adur8082 adur8284 adur8486 adur8890 adur9092 adur9294
              adur9496 adur9698 adur9800 adur0002 adur0204 adur0406 
              adur0608 adur0810 adur1012 adur1214 adur1416;
array adurarray{*} adur8082 adur8284 adur8486 adur8688 adur8890 adur9092 adur9294
                   adur9496 adur9698 adur9800 adur0002 adur0204 adur0406 adur0608
                   adur0810 adur1012 adur1214 adur1416; 

***NSAIDs array***;
/*any use of ibuprofen*/
array anyibu{*} regibu90 regibu92 regibu94 regibu96 regibu98 regibu00 regibu02 regibu04 regibu06 regibu08 regibu10 regibu12 regibu14;
array anyibupost{*} regibu90y regibu92y regibu94y regibu96y regibu98y regibu00y regibu02y regibu04y regibu06y regibu08y regibu10y regibu12y regibu14y;
array anyibucarry{*} anyibucarry90 anyibucarry92 anyibucarry94 anyibucarry96 anyibucarry98 anyibucarry00 anyibucarry02 anyibucarry04 anyibucarry06 anyibucarry08 anyibucarry10 anyibucarry12 anyibucarry14;


*****Aspirin*****;
/*make consistent with each variable, any asp, regular asp, tabls/week*/
do i=1 to dim(anyasp);
   if anyasp{i}=. and (0<aspwk{i} or reguasp{i}=2) then anyasp{i}=2;
   else if anyasp{i}=. and aspwk{i}=0 then anyasp{i}=1;

   if aspwk{i}=. and anyasp{i}=1 then aspwk{i}=0;

   if reguasp{i}=. and 0<=aspwk{i}<2 then reguasp{i}=1;
   else if reguasp{i}=. and 2<=aspwk{i} then reguasp{i}=2;
end;

/*cumulative average of aspirin variables before carrying forward*/
/*prediagnosis cumulative average of aspirin tabs/week*/
sumvar=0; n=0;
do j=1 to dim(aspwk);
 avaspwkpre{j} = aspwk{j};
 if (aspwk{j} ne .) then do;
  n=n+1;
  sumvar=sumvar+aspwk{j};
 end;

 if n=0 then avaspwkpre{j} = aspwk{j};
 else avaspwkpre{j} = sumvar/n;
end;

/*prediagnosis average of regular use of aspirin using cumulative of aspirin intake*/
do i=1 to dim(avaspwkpre);
 if 0<=avaspwkpre{i}<2 then avregaspre{i}=1; /* No regular use of aspirin */
 else if avaspwkpre{i}>=2 then avregaspre{i}=2; /* regular use of aspirin */
 else if avaspwkpre{i}=. then avregaspre{i}=.;
end;

/*Prediagnosis*/
/*carry aspirin variables forward ONE CYCLE if missing to use these as time-dependent variables*/
/*carry forward any use of aspirin one cycle*/
do i=1 to dim(anyasppre);
   anyasppre{i}=anyasp{i};
end;

do i=dim(anyasppre) to 2 by -1;
 if anyasppre{i} eq . and anyasppre{i-1} ne . then anyasppre{i}=anyasppre{i-1};
  if 0<aspwk{i} and anyasp{i}=. and anyasp{i-1}=1 then anyasppre{i}=.;     
 else if aspwk{i}=0 and anyasp{i}=. and anyasp{i-1}=2 then anyasppre{i}=.;
 else if anyasp{i}=. and reguasp{i}=2 and anyasp{i-1}=1 then anyasp{i}=1;
end;

/*carry forward aspirin tabs/week one cycle*/
do i=1 to dim(aspwk);
 aspwkpre{i}=aspwk{i};
end;

do i=dim(aspwkpre) to 2 by -1;
 if aspwkpre{i} eq . and aspwkpre{i-1} ne . then aspwkpre{i}=aspwkpre{i-1};
 if anyasp{i}=2 and aspwk{i}=. and aspwk{i-1}=0 then aspwkpre{i}=.;     
 else if anyasp{i}=1 and aspwk{i}=. and 0<aspwk{i-1} then aspwkpre{i}=.;

end;

/*carry forward cumulative average of aspirin tabs/week one cycle*/
do i=dim(avaspwkpre) to 2 by -1;
 if avaspwkpre{i} eq . and avaspwkpre{i-1} ne . then avaspwkpre{i}=avaspwkpre{i-1};
end;

/*carry forward regular use of aspirin one cycle*/
do i=1 to dim(reguasp);
 regaspre{i}=reguasp{i};
end;

do i=dim(regaspre) to 2 by -1;
 if regaspre{i} eq . and regaspre{i-1} ne . then regaspre{i}=regaspre{i-1};
 if anyasp{i}=1 and reguasp{i}=. and reguasp{i-1}=2 then regaspre{i}=.;    
end;

/*carry forward regular use of aspirin using cumulative average of aspirin tabs/week one cycle*/
do i=dim(avregaspre) to 2 by -1;
 if avregaspre{i} eq . and avregaspre{i-1} ne . then avregaspre{i}=avregaspre{i-1};
end;

/*impute missing aspirin by carrying forward all the cycle if missing 
to calculate immedeately before the diagnosis aspirin.*/
/*any use of asp*/
do i=1 to dim(anyaspcarry);
   anyaspcarry{i}=anyasp{i};
end;
do i=2 to dim(anyaspcarry);
 if anyaspcarry{i} eq . and anyaspcarry{i-1} ne . then anyaspcarry{i}=anyaspcarry{i-1};
end;

/*intake tabs/week*/
do i=1 to dim(aspwk);
 aspwkcarry{i}=aspwk{i};
end;
do i=2 to dim(aspwkcarry);
 if aspwkcarry{i} eq . and aspwkcarry{i-1} ne . then aspwkcarry{i}=aspwkcarry{i-1};
end;

/*cumulative average of intake tabs/week*/
do i=1 to dim(avaspwkpre);
 avaspwkcarry{i}=avaspwkpre{i};
end;
do i=2 to dim(avaspwkcarry);
 if avaspwkcarry{i} eq . and avaspwkcarry{i-1} ne . then avaspwkcarry{i}=avaspwkcarry{i-1};
end;

/*regular use*/
do i=1 to dim(reguasp);
 regascarry{i}=reguasp{i};
end;
do i=2 to dim(regascarry);
 if regascarry{i} eq . and regascarry{i-1} ne . then regascarry{i}=regascarry{i-1};
end;

/*regular use of aspirin using cumulative average of intake*/
do i=1 to dim(avregaspre);
 avregcarry{i}=avregaspre{i};
end;
do i=2 to dim(avregcarry);
 if avregcarry{i} eq . and avregcarry{i-1} ne . then avregcarry{i}=avregcarry{i-1};
end;

/*Postdiagnosis*/
/*impute missing aspirin by carrying backward all the cycle if missing
to calculate immedeately after diagnosis aspirin tabs/week*/
/*any use of asp*/
do i=1 to dim(anyasppost);
   anyasppost{i}=anyasp{i};
end;

do i=dim(anyasppost)-1 to 1 by -1;
 if anyasppost{i} ne . then anyasppost{i}=anyasppost{i};
 else if anyasppost{i} eq . and anyasppost{i+1} ne . then anyasppost{i}=anyasppost{i+1};
end;

/*intake tabs/week*/
do i=1 to dim(aspwk);
 aspwkpost{i}=aspwk{i};
end;

do i=dim(aspwkpost)-1 to 1 by -1;
 if aspwkpost{i} ne . then aspwkpost{i}=aspwkpost{i};
 else if aspwkpost{i} eq . and aspwkpost{i+1} ne . then aspwkpost{i}=aspwkpost{i+1};
end;

/*regular use of aspirin*/
do i=1 to dim(reguasp);
 regaspost{i}=reguasp{i};
end;

do i=dim(regaspost)-1 to 1 by -1;
 if regaspost{i} ne . then regaspost{i}=regaspost{i};
 else if regaspost{i} eq . and regaspost{i+1} ne . then regaspost{i}=regaspost{i+1};
end;

/*duration of regular aspirin use*/
/*1980 questionnaire asked duration in the past*/
if aspwkpre80>=2 then do;
 adur8080=adur80; adur8082=2;
end;
else if 0<=aspwkpre80<2 then do;
 adur8080=0; adur8082=0;
end;
else if aspwkpre80=. then do;
 adur8080=.; adur8082=.;
end;

/*1988-2012, if aspirin was regularly used, 2 years were added as the duration in the period*/
do i=2 to dim(adur);
 if aspwkpre{i}>=2 then adur{i}=2;
 else if 0<=aspwkpre{i}<2 then adur{i}=0;
 else if aspwkpre{i}=. then adur{i}=.;
end;
/*1986, no asprirn question*/
adur8688=adur8486;

/*fills in missing duration with one cycle prior questionnaire response*/ 
do i=2 to dim(adurarray);
 if adurarray{i}=. then adurarray{i}=adurarray{i-1};
 else;
end;

regaspdur80=sum(adur8080,adur8082);
regaspdur82=sum(adur8080,adur8082,adur8284);
regaspdur84=sum(adur8080,adur8082,adur8284,adur8486);
regaspdur86=sum(adur8080,adur8082,adur8284,adur8486,adur8688);
regaspdur88=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890);
regaspdur90=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092);
regaspdur92=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294);
regaspdur94=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496); 
regaspdur96=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698);
regaspdur98=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800);
regaspdur00=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002);
regaspdur02=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204);
regaspdur04=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406);
regaspdur06=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608);
regaspdur08=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810);
regaspdur10=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012);
regaspdur12=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214);
regaspdur14=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,
                adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214,adur1416);

*****NSAIDs*****;
/*Prediagnosis, Carry forward all the cycle*/
/*any use of ibu*/
do i=1 to dim(anyibucarry);
anyibucarry{i}=anyibu{i};
end;
do i = 2 to dim(anyibucarry);  
if anyibucarry{i} in (.) then anyibucarry{i} = anyibucarry{i-1}; 
end;

/*Postdiagnosis, impute missing ibu by carrying backward all the cycle if missing
to calculate immedeately after diagnosis ibu tabs/week*/
/*any use of ibu*/
do i=1 to dim(anyibupost);
   anyibupost{i}=anyibu{i};
end;
do i=dim(anyibupost)-1 to 1 by -1;
 if anyibupost{i} ne . then anyibupost{i}=anyibupost{i};
 else if anyibupost{i} eq . and anyibupost{i+1} ne . then anyibupost{i}=anyibupost{i+1};
end;

run;
proc datasets nolist; 
delete meds8016 nur82 nur84 nur88 nur90 nur92 nur94 nur96 nur98 
       nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14;
run;


/****************/
/* Read Alcohol */
/****************/
/*raw neutrient intake, continuous*/
/*predxalc postdxalc
  0= 0, 1= <15, 2= 15+ g/d*/
%n80_nts(keep=alco80n);
%n84_nts(keep=alco84n);
%n86_nts(keep=alco86n);
%n90_nts(keep=alco90n);
%n94_nts(keep=alco94n);
%n98_nts(keep=alco98n);
%n02_nts(keep=alco02n);  
%n06_nts(keep=alco06n);
%n10_nts(keep=alco10n);    
data nhalcohol;
merge n80_nts n84_nts n86_nts n90_nts n94_nts n98_nts n02_nts n06_nts n10_nts;
by id;
run;
proc sort nodupkey; by id; run;
proc datasets nolist;
delete n80_nts n84_nts n86_nts n90_nts n94_nts n98_nts n02_nts n06_nts n10_nts;
run;

/************************/
/* Read Vitamin D score */
/************************/
/***************************************************************
 Vitamin D Score
prevtds: Pre-diagnosis vitamin D score
prevtdsav: Cumulative average of pre-diagnosis vitamin D socre 
postvtds: Post-diagnosis vitamin D score
****************************************************************/
data nhvtdscore;
infile "/proj/nhnhls/nhnhl0b/UV/vitD/VitD_predictor_score_NHS1_09.12.dat";
input id vdp86 vdp88 vdp90 vdp92 vdp94 vdp96 vdp98 vdp00 vdp02 vdp04 vdp06 vdp08
vdp86v vdp88v vdp90v vdp92v vdp94v vdp96v vdp98v vdp00v vdp02v vdp04v vdp06v vdp08v; 
run;
proc sort nodupkey data=nhvtdscore; by id; run;

data nhvtdscore;
 set nhvtdscore;
array raw[*] vdp86 vdp88 vdp90 vdp92 vdp94 vdp96 vdp98 vdp00 vdp02 vdp04 vdp06 vdp08;
array avg[*] vdp86a vdp88a vdp90a vdp92a vdp94a vdp96a vdp98a vdp00a vdp02a vdp04a vdp06a vdp08a;
sumvar=0; n=0;
do j=1 to dim(raw);
   avg{j}=raw{j};
   if (raw{j} ne .) then do;
      n=n+1;
      sumvar=sumvar+raw{j};
   end;
   if n=0 then avg{j}=raw{j};
   else avg{j}=sumvar/n;
end;
run;

/*****************************************************/
/*            Read in endoscopy data                */
/****************************************************/     
data ageirt;
set der7620;
/*merge fa7684 fa8694 fa9604 fa0608 fa10; by id;*/
/*setting irt array*/
array irtset {*}  irt80 irt82 irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 cutoff;
/* If participant did not return questionnaire, or irtXX date is before */
/* June of that questionnaire year, or is after or equal to June of the */
/* next questionniare year, then it is incorrect, and the return date   */
/* should  be set to the mailing date (June of that years).             */
do i=1 to DIM(irtset)-1;         /*DIM returns the number of elements in that array*/
if irtset{i}<942+(24*i) or irtset{i}>=966+(24*i) then irtset{i}=942+(24*i);
end;
if irt80>0 and bdt>0 then age80=round((irt80-bdt)/12,1);  
if irt82>0 and bdt>0 then age82=round((irt82-bdt)/12,1);  
if irt84>0 and bdt>0 then age84=round((irt84-bdt)/12,1);  
if irt86>0 and bdt>0 then age86=round((irt86-bdt)/12,1);  
if irt88>0 and bdt>0 then age88=round((irt88-bdt)/12,1);  
if irt90>0 and bdt>0 then age90=round((irt90-bdt)/12,1);  
if irt92>0 and bdt>0 then age92=round((irt92-bdt)/12,1);  
if irt94>0 and bdt>0 then age94=round((irt94-bdt)/12,1);  
if irt96>0 and bdt>0 then age96=round((irt96-bdt)/12,1); 
if irt98>0 and bdt>0 then age98=round((irt98-bdt)/12,1); 
if irt00>0 and bdt>0 then age00=round((irt00-bdt)/12,1);  
if irt02>0 and bdt>0 then age02=round((irt02-bdt)/12,1);  
if irt04>0 and bdt>0 then age04=round((irt04-bdt)/12,1);  
if irt06>0 and bdt>0 then age06=round((irt06-bdt)/12,1); 
if irt08>0 and bdt>0 then age08=round((irt08-bdt)/12,1);
if irt10>0 and bdt>0 then age10=round((irt10-bdt)/12,1);
if irt12>0 and bdt>0 then age12=round((irt12-bdt)/12,1);
if irt14>0 and bdt>0 then age14=round((irt14-bdt)/12,1);
run;

proc sort nodupkey;
by id;
run;

/*             Read CASE DATA FILE               */
data nhcase;
infile '/proj/hppols/hppol0c/nhs/periodbased/active/nhs_colpol_8610_per.dat';
input 
id 	 	    1-6    /*nhs identification number*/  
poldtdth 		7-10   /*death date in months since 1900*/
poldtdx 		11-14  /*date of diagnosis in onths since 1900*/
;
run;

proc sort nodupkey; by id; run;

data nhcase;
 set nhcase;
 if poldtdx=9999 then poldtdx=.;
run;



/********************************/
/*Read Colonoscopy/Sigmoidoscopy*/
/********************************/
/***********************************************
1988
   In past two years have you had sigmoidoscopy?
   1 = no
   2 = yes for symptoms
   3 = yes for screening
   4 = pass thru
1990, 2000
   Colonoscopy or Sigmoidoscopy
   1 = YES         26977
   2 = NO          58347
   3 = PASS THR      333
   BLANK           19585
1992
   Colonoscopy or Sigmoidoscopy
    1=no
    2=yes/screening
    3=yes/symptoms
    4=Passthrough
1994, 96, 98, 2002
    1=no
    2=yes
    3=pt
2004
   Virtual CT Colonoscopy (virtc04)
       1.no; 2.yes; 3.pt
    Colonoscopy (colsc04)
	   1.no; 2.yes; 3.pt
    Sigmoidoscopy (sigsc04)
	   1.no; 2.yes; 3.pt
    Colonoscopy/Sigmoidoscopy BOOKLET ONLY (sigm04)
	   1.no; 2.yes; 3.pt
    signo04 Sigmoidoscopy: Never (L19)--Colonoscopy is the same as this
    sig9304 Sigmoidoscopy: 1993/Earlier (L19)
    sig9404 Sigmoidoscopy: 1994-1995 (L19)
    sig9604 Sigmoidoscopy: 1996-1997 (L19)
    sig9804 Sigmoidoscopy: 1998-1999 (L19)
    sig0004 Sigmoidoscopy: 2000-2001 (L19)
    sig0204 Sigmoidoscopy: 2002/Later (L19)
    sigpt04 Sigmoidoscopy PT (L19)
    q19pt04 yrs Procedures PT (L19) range 1
2006 2010
    Virtual CT Colonoscopy (virtc06, virtc08,virtc10)
	   1.no; 2.yes; 3.pt
	Colonoscopy (colsc06 colsc08 colsc10)
       1.no; 2.yes; 3.pt
    Sigmoidoscopy (sigsc06 sigsc08 sigsc10)
       1.no; 2.yes; 3.pt

***********************************************/
/*
sigm190 i1        94      When First Colon. or Sigm. (L8a)
                              $range 0-9
 			   LABEL         COUNT 
	            1 = BEFORE 1980      10842
                    2 = 1980-83           3935
                    3 = 1984-85           2641
                    4 = 1986              1639
                    5 = 1987              1920
                    6 = 1988              2347
                    7 = 1989              2209
                    8 = 1990 OR LATER     1234
                    9 = PASS THR           210
                    BLANK                78265

sigmr90         i1        102     Most Recent Colon. or Sigm. (L8c)
                              $range 0-9
 			   LABEL         COUNT 
	            1 = BEFORE 1980       5930
                    2 = 1980-83           2472
                    3 = 1984-85           2141
                    4 = 1986              1538
                    5 = 1987              2168
                    6 = 1988              3670
                    7 = 1989              4646
                    8 = 1990 OR LATER     3299
                    9 = PASS THR          1113
                    BLANK                78265
*/
/********************************************************************
Reasons
1988 In past two years have you had sigmoidoscopy?
   1 = no, 2 = yes for symptoms, 3 = yes for screening, 4 = pass thru
1992 Colonoscopy or Sigmoidoscopy (L15)
    1=no, 2=yes/screening, 3=yes/symptoms, 4=Passthrough
1990,1994,1996
vbld90 Bleeding in Stool  1=yes
hxclc90 Family History-Colon Cancer  1=yes
fecal90 Pos. Test-Occult Fecal Blood  1=yes
abdpn90 Abdominal Pain  1=yes
diarr90 Diarrhea or Constipation  1=yes
rout90 Routine Screening 1=yes
q8b88pt Why First Colon. or Sigm. PT 1=q8b pt (1990)
q11ap94 Q11A PT why Colonoscopy/Sigm 1=pt (1994)
q11ap96 Q11A PT why Colonoscopy/Sigm 1=pt (1996)

1998-2004
[same above] and
bariu98 Barium Enema (L13) $range 1
q13ap98 Q11A PT why Colonoscopy/Sigm 1=pt (1998)
q15ap00 reason pass thr (2000)
q16apt02 reason pass thr (2002)
q18apt04 reason pass through (2004)

2006-2010
[same above] and
cpolp06		i1		245		Q15a: Prior Polyps
virt06		i1		248		Q15a: Follow-up Virtual CT Colonoscopy
q15apt06	i1		251		Q15aPT: Reasons PT
cpolp08     i1      256     Q16a: Prior Polyps
virt08      i1      259     Q16a: Follow-up of Virtual CT Colonoscopy
q16apt08    i1      262     Q16aPT: Reasons PT
cpolp10     i1      229     Q16a: Prior Polyps
virt10      i1      232     Q16a: Virtual CT Colonoscopy follow up
q16apt10    i1      235     Q16aPT: Reasons PT
********************************************************************/
/*In 1988-1996, 800<=batch@@ is short qx. long qx inlcude endoscopy.
q98 1.booklet 2.long 3.short
q00 1.bklet 2.long 3.telephone p1-4(include endonoscoyp)  4.page1-2only(include endonoscoyp)	5.short
q02 1.booklet;2.long;3.telephone (p1&2)(include endonoscoyp);4.short
q04	1.long;2.booklet;3.tel (page1&2)(include endonoscoyp) ;4.short
q06	1.long 6page;2.booklet;3.page1-2 (include endonoscoyp);4.telephone page1-2 (include endonoscoyp);5.short
q08 1.long;2.booklet;3.page 1and2 (include endonoscoyp) ;4.short
*/
%nur88(keep=batch88 sigm88, noformat=T);
%nur90(keep=batch90 sigm90 sigmr90 sigm190 vbld90 diarr90 fecal90 
       hxclc90 abdpn90 rout90 q8b88pt, noformat=T);
%nur92(keep=batch92 sigm92, noformat=T);
%nur94(keep=batch94 sigm94 vbld94 hxclc94 fecal94 abdpn94 diarr94 rout94 q11ap94, noformat=T);
%nur96(keep=batch96 sigm96 vbld96 hxclc96 fecal96 abdpn96 diarr96 rout96 q11ap96 , noformat=T);
%nur98(keep=q98 sigm98 vbld98 hxclc98 fecal98 abdpn98 diarr98 rout98 bariu98 q13ap98, noformat=T);
%nur00(keep=q00 sigm00 vbld00 hxclc00 fecal00 abdpn00 diarr00 rout00 bariu00 q15ap00, noformat=T);
%nur02(keep=q02 sigm02 vbld02 hxclc02 fecal02 abdpn02 diarr02 rout02 bariu02 q16apt02, noformat=T);
%nur04(keep=q04 virtc04 colsc04 sigsc04 sigm04
            vbld04 diarr04 bariu04 cpolp04 fecal04 hxclc04 virt04 rout04 abdpn04 
            q18apt04 q19pt04
            signo04 sig9304 sig9404 sig9604 sig9804 sig0004 sig0204 sigpt04
            colno04 col9304 col9404 col9604 col9804 col0004 col0204 colpt04, noformat=T);
%nur06(keep=q06	virtc06 colsc06 sigsc06  
       vbld06 diarr06 bariu06 cpolp06 fecal06 hxclc06 virt06 rout06 abdpn06 q15apt06 , noformat=T);
%nur08 (keep=q08 virtc08 colsc08 sigsc08  
        vbld08 diarr08 bariu08 cpolp08 fecal08 hxclc08 virt08 rout08 abdpn08 q16apt08, noformat=T );
%nur10 (keep=q10 virtc10 colsc10 sigsc10
        vbld10 diarr10 bariu10 cpolp10 fecal10 hxclc10 virt10 rout10 abdpn10 q16apt10, noformat=T );
%nur12 (keep=q12 virtc12 colsc12 sigsc12
        vbld12 diarr12 bariu12 cpolp12 fecal12 hxclc12 virt12 rout12 abdpn12 colrsnpt12, noformat=T );
%nur14 (keep=q14 virtc14 colsc14 sigsc14
        vbld14 diarr14 bariu14 cpolp14 fecal14 hxclc14 virt14 rout14 abdpn14 colrsnpt14, noformat=T );

data nhsigmo;
   merge nur88 (in=a88) nur90 (in=a90) nur92 (in=a92) nur94 (in=a94) nur96 (in=a96)
         nur98 (in=a98) nur00 (in=a00) nur02 (in=a02) nur04 (in=a04) nur06 (in=a06) nur08 (in=a08) nur10 (in=a10) nur12 (in=a12) nur14 (in=a14)
         nhcase nh_colc3 ageirt deadff;
   by id;

innur88=a88;
innur90=a90;
innur92=a92;
innur94=a94;
innur96=a96;
innur98=a98;
innur00=a00;
innur02=a02;
innur04=a04;
innur06=a06;
innur08=a08;
innur10=a10;
innur12=a12;
innur14=a14;

/*Those answered long (or short with endoscopy) longq@@=1 yes, other=0*/
if .<batch88<800 then longq88=1; else longq88=0; 
if .<batch90<800 then longq90=1; else longq90=0;
if .<batch92<800 then longq92=1; else longq92=0;
if .<batch94<800 then longq94=1; else longq94=0;
if .<batch96<800 then longq96=1; else longq96=0;
if q98 in (1,2)   then longq98=1; else longq98=0;
if q00 in (1,2,3,4) then longq00=1; else longq00=0;
if q02 in (1,2,3) then longq02=1; else longq02=0;
if q04 in (1,2,3) then longq04=1; else longq04=0;
if q06 in (1,2,3,4) then longq06=1; else longq06=0;
if q08 in (1,2,3) then longq08=1; else longq08=0;
if q10 in (1,2,3) then longq10=1; else longq10=0;
if q12 in (1,2,3) then longq12=1; else longq12=0;
if q14 in (1,2,3) then longq14=1; else longq14=0;



/***********/
/*endoscopy*/
/***********/
if sigm88=1 then endo88=1; /*endo no*/
else if sigm88 in (2,3) then endo88=2; /*endo yes*/

if sigm90=1 then endo90=2; /*endo yes*/
else if sigm90=2 then endo90=1; /*endo no*/

if sigm00=1 then endo00=2; /*endo yes*/
else if sigm00=2 then endo00=1; /*endo no*/

if sigm92=1 then endo92=1; /*endo no*/ 
else if sigm92 in (2,3) then endo92=2; /*endo yes*/

if sigm94=1 then endo94=1; /*endo no*/
else if sigm94=2 then endo94=2; /*endo yes*/

if sigm96=1 then endo96=1; /*endo no*/
else if sigm96=2 then endo96=2; /*endo yes*/

if sigm98=1 then endo98=1; /*endo no*/
else if sigm98=2 then endo98=2; /*endo yes*/

if sigm02=1 then endo02=1; /*endo no*/
else if sigm02=2 then endo02=2; /*endo yes*/

if colsc04=2 or sigsc04=2 or sigm04=2 or sig0204=1 or col0204=1 then endo04=2; /*endo yes*/
else if colsc04=1 or sigsc04=1 then endo04=1; /*endo no*/

if colsc06=2 or sigsc06=2 then endo06=2; /*endo yes*/
else if colsc06=1 or sigsc06=1 then endo06=1; /*endo no*/

if colsc08=2 or sigsc08=2 then endo08=2; /*endo yes*/
else if colsc08=1 or sigsc08=1 then endo08=1; /*endo no*/

if colsc10=2 or sigsc10=2 then endo10=2; /*endo yes*/
else if colsc10=1 or sigsc10=1 then endo10=1; /*endo no*/

if colsc12=2 or sigsc12=2 then endo12=2; /*endo yes*/
else if colsc12=1 or sigsc12=1 then endo12=1; /*endo no*/

if colsc14=2 or sigsc14=2 then endo14=2; /*endo yes*/
else if colsc14=1 or sigsc14=1 then endo14=1; /*endo no*/

 
*-----------*
 Use 1990 Qx
*-----------*;
/*endo76-endo86 derived from 1990 info.*/
/*endo76-endo86 indicate experience of endoscopy before 1980 (1=BEFORE 1980)*/
if sigm190 in (1) or sigmr90 in (1) then do; endo80=2; endo78=2; endo76=2; end; 
else if sigm190 in (2,3,4,5,6,7,8) then do;  endo80=1; endo78=1; endo76=1; end; 

if sigm190 in (2) or sigmr90 in (2) then do; endo82=2; endo84=2; end; /*we'll clean successive endo later*/
else if sigm190 in (3,4,5,6,7,8) or sigmr90 in (3) then do; endo82=1; endo84=1; end; /*if recent endo is 1984-85*/

if sigm190 in (3) or sigmr90 in (3) then endo86=2;
else if (sigm190 in (4,5,6,7,8) or sigmr90 in (4,5,6)) then endo86=1; /*if recent endo is within 5 years*/

/*when endo88-endo90 were missing, 1990 info was used to fill the answer.
 We don't impute endo88 if endo90=yes becase person shouldn't take
 endoscopy twice within 4 years. Same for endo90*/
if ((endo90 ne 2) and (sigm190 in (4,5) or sigmr90 in (4,5)) and endo88=. ) 
   then endo88=2;
else if (endo88=. and sigm190 in (6,7,8)) then endo88=1;
else if (endo88=. and sigmr90 in (3,6,7,8)) then endo88=1; 

if ((endo88 ne 2) and (sigm190 in (6,7,8) or sigmr90 in (6,7,8)) and endo90=. ) 
   then endo90=2;
else if (endo90=. and sigmr90 in (2,3,4,5)) then endo90=1; 

*-----------*
 Use 2004 Qx
*-----------*;
/*For only missing variables of the past Qx, we use 2004 info*/
/*We don't impute endo[i] if person already endo[i-1]=yes or endo[i+1]=yes*/
/*never*/
if (endo76=2 or endo78=2 or endo80=2 or endo82=2 or endo84=2 or 
    endo86=2 or endo88=2 or endo90=2 or endo92=2 or endo94=2 or 
    endo96=2 or endo98=2 or endo00=2 or endo02=2 or endo04=2 )
   then atleast=1; /*yes edo at least once in some year. They cannot be "Never endo"*/
array arendo[*] endo76 endo78 endo80 endo82 endo84 endo86 endo88 endo90 
                endo92 endo94 endo96 endo98 endo00 endo02 endo04;
if (atleast ne 1 and signo04=1 and colno04=1) then do; /*never in 2004 qx*/
   do i=1 to dim(arendo);
      if arendo[i]=. then arendo[i]=1; /*no*/
   end;
end;

/*we fill from the latest information*/
/*2002/Later endo can fill endo04*/
if (endo02 ne 2 and endo04=. and (sig0204=1 or col0204=1))
   then endo04=2; /*yes*/
else if (endo04=. and sig0204 ne 1 and col0204 ne 1 and q04 in (1,2,3)/*all04miss ne 1 and q19pt04 ne 1*/) 
   then endo04=1; /*no*/                               /*q04=1,2,3 includes endoscopy question*/

/*2000-2001 endo can fill endo02*/
if (endo00 ne 2 and endo04 ne 2 and endo02=. and (sig0004=1 or col0004=1))
   then endo02=2; /*yes*/
else if (endo02=. and sig0004 ne 1 and col0004 ne 1 and q04 in (1,2,3)/*all04miss ne 1 and q19pt04 ne 1*/) 
   then endo02=1; /*no*/

/*1998-1999 endo can fill endo00*/
if (endo98 ne 2 and endo02 ne 2 and endo00=. and (sig9804=1 or col9804=1))
   then endo00=2; /*yes*/
else if (endo00=. and sig9804 ne 1 and col9804 ne 1 and q04 in (1,2,3)/*all04miss ne 1 and q19pt04 ne 1*/) 
   then endo00=1; /*no*/

/*1996-1997 endo can fill endo98*/
if (endo96 ne 2 and endo00 ne 2 and endo98=. and (sig9604=1 or col9604=1))
   then endo98=2; /*yes*/
else if (endo98=. and sig9604 ne 1 and col9604 ne 1 and q04 in (1,2,3)/*all04miss ne 1 and q19pt04 ne 1*/) 
   then endo98=1; /*no*/

/*1994-1995 endo can fill endo96*/
if (endo94 ne 2 and endo98 ne 2 and endo96=. and (sig9404=1 or col9404=1))
   then endo96=2; /*yes*/
else if (endo96=. and sig9404 ne 1 and col9404 ne 1 and q04 in (1,2,3)/*all04miss ne 1 and q19pt04 ne 1*/) 
   then endo96=1; /*no*/

/*1993/Earlier, we just don't know exact year. but can fill no-endo*/
*if (endo92 ne 2 and endo96 ne 2 and endo94=. and (sig9304=1 or col9304=1)) 
   then endo94=2; /*yes*/                                     /*q19pt04=1 is all path throu*/
if (endo94=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)/*all04miss ne 1 and q19pt04 ne 1*/) 
   then endo94=1; /*no*/
else if (endo92=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo92=1; /*no*/
else if (endo90=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo90=1; /*no*/
else if (endo88=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo88=1; /*no*/
else if (endo86=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo86=1; /*no*/
else if (endo84=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo84=1; /*no*/
else if (endo82=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo82=1; /*no*/
else if (endo80=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo80=1; /*no*/
else if (endo78=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo78=1; /*no*/
else if (endo76=. and sig9304 ne 1 and col9304 ne 1 and q04 in (1,2,3)) then endo76=1; /*no*/



*****fill in if missing*******;
if endo88=. and .<batch88<800 then endo88=1; /*one answered long qx but missing, we assume no endo*/

if endo90=. and .<batch90<800 then endo90=1; /*one answered long qx but missing, we assume no endo*/

if endo00=. and q00 in (1,2,3,4) then endo00=1; /*one answered long qx but missing, we assume no endo*/

if endo92=. and .<batch92<800 then endo92=1; /*one answered long qx but missing, we assume no endo*/

if endo94=. and .<batch94<800 then endo94=1; /*one answered long qx but missing, we assume no endo*/

if endo96=. and .<batch96<800 then endo96=1; /*one answered long qx but missing, we assume no endo*/

if endo98=. and q98 in (1,2) then endo98=1;  /*one answered long qx but missing, we assume no endo*/

if endo02=. and q02 in (1,2,3) then endo02=1; /*one answered long qx but missing, we assume no endo*/

if endo04=. and q04 in (1,2,3) then endo04=1; /*one answered long qx but missing, we assume no endo*/

if endo06=. and q06 in (1,2,3,4) then endo06=1; /*one answered long qx but missing, we assume no endo*/

if endo08=. and q08 in (1,2,3) then endo08=1; /*one answered long qx but missing, we assume no endo*/

if endo10=. and q10 in (1,2,3) then endo10=1; /*one answered long qx but missing, we assume no endo*/

if endo12=. and q12 in (1,2,3) then endo12=1; /*one answered long qx but missing, we assume no endo*/

if endo14=. and q14 in (1,2,3) then endo14=1; /*one answered long qx but missing, we assume no endo*/


*-----------*
 Use 1990 Qx
*-----------*;
if endo80=. and endo78=. and endo76=. and .<batch90<800 and sigm190 in (9,.) and sigmr90 in (9,.) then do; endo80=1 ; endo78=1 ; endo76=1 ; end; 
       /*when she answered long Qx, impute pass thr to no endo*/

if endo82=. and endo84=. and .<batch90<800 and sigm190 in (9,.) and sigmr90 in (9,.) then do; endo82=1; endo84=1; end;
       /*when she answered long Qx, impute pass thr to no endo*/

if endo86=. and .<batch90<800 and sigm190 in (9,.) and sigmr90 in (9,.) then endo86=1;

/*when endo88-endo90 were missing, 1990 info was used to fill the answer.
 We don't impute endo88 if endo90=yes becase person shouldn't take
 endoscopy twice within 4 years. Same for endo90*/
if endo88=. and .<batch90<800 then endo88=1; /*long qx*/

if endo90=. and .<batch90<800 then endo90=1; /*long qx*/


*--------------------------*
 Clean consecutive endoscopy
*--------------------------*;
/*People are unlikely to undergo next endoscopy within 4 years.
If person reported endoscopy in the successive Qx cycle (or miss endo status),
we assume endo in the second report was the same one already reported in the last Qx.
We assign endo=yes later if people was diagnosed adenoma/polyp in the qx cycle.*/
/*1988-2010*/
if endo88=2 then endo90=1;
if endo90=2 then endo92=1;
if endo92=2 then endo94=1;
if endo94=2 then endo96=1;
if endo96=2 then endo98=1;
if endo98=2 then endo00=1;
if endo00=2 then endo02=1;
if endo02=2 then endo04=1;
if endo04=2 then endo06=1;
if endo06=2 then endo08=1;
if endo08=2 then endo10=1;
if endo10=2 then endo12=1;
if endo12=2 then endo14=1;

/*1982-1986, the years retrospectively asked about endo.
we assume the report for the more recent year is more accurate.
Before 1980, we don't know the exact year of endo.*/
if endo88=2 then endo86=1;
if endo86=2 then endo84=1;
if endo84=2 then endo82=1;  


*-------------------------------------------------------*
 After clean successive endoscopy,
 Endoscopy just before dtdx of polyp
*-------------------------------------------------------*;
/* For person who did not report endo but polyp was diagnosed.*/
array arrendo [*] endo80 endo82 endo84 endo86 endo88 endo90 endo92 
                  endo94 endo96 endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14; /*1=no endo, 2=yes endo*/
array endos[*] endos80 endos82 endos84 endos86 endos88 endos90 endos92  
               endos94 endos96 endos98 endos00 endos02 endos04 endos06 endos08 endos10 endos12 endos14; /*0=no end, 1=yes endo*/
array arirt [*] irt80 irt82 irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14;
array hendo [*] hendo80 hendo82 hendo84 hendo86 hendo88 hendo90 hendo92 hendo94 hendo96 hendo98 hendo00
                hendo02 hendo04 hendo06 hendo08 hendo10 hendo12 hendo14;

				/*when person diagnosed as adenoma (poldtdx exists) but they did not report endoscopy*/
do i=2 to dim(arirt);
   if (arirt[i-1]<=poldtdx<arirt[i] and arrendo[i] ne 2) then do;
      arrendo[i]=2; /*yes endo*/
   end;
end;

/*missing endoscopy status immediately after/before the Q-cycle with endoscopy 
will be no endoscopy as people is less likely to take endoscopy within 5 years*/
do i=2 to dim(arrendo);
   if arrendo[i]=. and arrendo[i-1]=2 then arrendo[i]=1; /*no endo*/
end;

do i=1 to dim(arrendo)-1;
   if arrendo[i]=. and arrendo[i+1]=2 then arrendo[i]=1; /*no endo*/
end;


*-------------------------------------*
 person who all miss endo status
*-------------------------------------*;
do i=1 to dim(arrendo);
   if arrendo[i]=1 then endos[i]=0; /*no endo*/
   else if arrendo[i]=2 then endos[i]=1; /*yes endo*/
end;

endosum=0;
do i=1 to dim(endos);
   endosum= sum (endosum,endos[i]); /*sum of endoscopy experience*/
end;

if endos80=. and endos82=. and endos84=. and endos86=. and endos88=. and endos90=. and endos92=. and 
   endos94=. and endos96=. and endos98=. and endos00=. and endos02=. and endos04=. and endos06=. and endos08=. and endos10=. and endos12=. and endos14=. then
   endosum=.;  /*Because sum function returns 0 if the value is missing*/

if endosum=0 then neverendo=1; 


*-------------------------------------*
 history of endoscopy
*-------------------------------------*;

hendo80=endos80;

do i=2 to dim(hendo);

if hendo[i-1]=. and endos[i]=. then hendo[i]=.;     /*missing*/
else if hendo[i-1]=1 or endos[i]=1 then hendo[i]=1;   /*with history of endoscopy*/
else hendo[i]=0;                                      /*without history of endoscopy*/
end;
run;

data nhsigmo;
 set nhsigmo;
keep
id poldtdx endo: endos: hendo: neverendo endosum;
run;

proc sort nodupkey; by id; run;

proc datasets nolist;
delete nur88 nur90  nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nhcase ageirt;
run;

/* Read in appendectomy data in NHS
app92: Appendectomy for appendicitis; 1=yes
appd92: year of appendectomy for appenicitis; 1=<1976, 2=1976-80, 3=1981-84, 4=1985-89, 5=1990+, 6=Passthrough
appi92: Appendectomy for ncidental; 0=no, 1=yes
appid92: year of appendectomy for incidental; 1=<1976, 2=1976-80, 3=1981-84, 4=1985-89, 5=1990+, 6=Passthrough */

%nur92(keep=id app92 appd92 appi92 appid92, noformat=T);
/* data nuapp;
set nur92;
run

proc univariate data=nuapp;
var id app92 appd92 appi92 appid92;
run;

proc print data=nuapp;
var id app92 appd92 appi92 appid92;
run; */

data nuapp;
set nur92;
napptotal=0; 
napp76=0;
napp78=0;
napp82=0;
napp86=0;
napp90=0;
nappthrough=0;
nappi76=0;
nappi78=0;
nappi82=0;
nappi86=0;
nappi90=0;
nappithrough=0;
if app92=. then app92=0; /* missing=0 */
if app92=0 then appd92=0; /* missing=0 */
if appi92=. then appi92=0; /* missing=0 */
if appi92=0 then appid92=0; /* missing=0 */
if app92=1 or appi92=1 then napptotal=1;
if appd92=1 then napp76=1; /* 1=<1976 */
if appd92=2 then napp78=1; /* 1=1976-80 */
if appd92=3 then napp82=1; /* 1=1981-84 */
if appd92=4 then napp86=1; /* 1=1985-89 */
if appd92=5 then napp90=1; /* 1=1990+ */
if appd92=6 then nappthrough=1; /* 1=passthrough */
if appid92=1 then nappi76=1; /* 1=<1976 */
if appid92=2 then nappi78=1; /* 1=1976-80 */
if appid92=3 then nappi82=1; /* 1=1981-84 */
if appid92=4 then nappi86=1; /* 1=1985-89 */
if appid92=5 then nappi90=1; /* 1=1990+ */
if appid92=6 then nappithrough=1; /* 1=passthrough */
run;

proc sort nodupkey data=nuapp;
by id;
run;

proc freq data=nuapp;
     tables app92 appd92 appi92 appid92; 
     run;
/**************************************************************************/
/*****************Create NHS data combined with lab data*******************/
/**************************************************************************/
/*BMI from 1976 through 2002 and Physical Activity data from 1986 through 2008 are included in NHS.*/

data nh_alldata; 
  merge nh_all_lab (in=inlab where=(patholdiff in (1,2,3,4))) 
        nh_colc3 (in=mstr) deadff (in=a) act8614 nhfamily /*fa7684  fa8694 fa9604 fa0608 fa10*/ der7620
        nhaspone (in=nhas) nhalcohol nhvtdscore nhsigmo nuapp end=_end_; 
  by id;
  colc1=mstr; if colc1=. then colc1=0; 
  lab =inlab; if lab=. then lab=0; 
  nhasin=nhas;
  sex=1;  
if yobf=. then delete; 
cutoff = 1440; /** Cutoff: Dec 2019 **/
exrec=1;
if first.id and mstr then exrec=0;
nhs = 1;

/*setting irt array*/
array irt {*}  irt76 irt78 irt80 irt82 irt84 irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 cutoff;
array irtr {*} irtr76 irtr78 irtr80 irtr82 irtr84 irtr86 irtr88 irtr90 irtr92 irtr94 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 irtr12 irtr14 cutoff;
               do i = 1 to dim(irt);
                       if irt{i} eq 0 or irt{i} eq . then irtr{i} = (894 + 24*i);
                       else irtr{i} = irt {i};
               end;

/*availability of postdx questionnaire*/
array irtyn {*}  irtyn76 irtyn78 irtyn80 irtyn82 irtyn84 irtyn86 irtyn88 irtyn90 irtyn92 irtyn94 irtyn96 irtyn98 irtyn00 irtyn02 irtyn04 irtyn06 irtyn08 irtyn10 irtyn12 irtyn14 cutoff;

				 do i = 1 to dim(irt)-1;
                       if irt{i} eq 0 or irt{i} eq . then irtyn{i} = 0;
                       else irtyn{i} = 1;
                 end;

qqyes=0;
do i = 2 to dim(irt)-1; 
                       if irtr {i-1} lt mdtdx le irtr {i} then 
                       do; irtsum = 0;
                          do j = i to dim(irt)-1; 
                              irtsum = irtsum + irtyn{j};
                          end;
					      if irtsum ^=0 then qqyes=1; else qqyes=0; 
                       end;
end;
 
/* determining predx weight,BMI,smoking status, pack-year smoking, family history of cancer and endscope status */
array wtar{*} wt76 wt78 wt80 wt82 wt84 wt86 wt88 wt90 wt92 wt94 wt96 wt98 wt00 wt02 wt04 wt06 wt08 wt10 wt12 wt14;
array wtarrpre{*} wt76x wt78x wt80x wt82x wt84x wt86x wt88x wt90x wt92x wt94x wt96x wt98x wt00x wt02x wt04x wt06x wt08x wt10x wt12x wt14x;
array wtarpost{*} wt76y wt78y wt80y wt82y wt84y wt86y wt88y wt90y wt92y wt94y wt96y wt98y wt00y wt02y wt04y wt06y wt08y wt10y wt12y wt14y;
array smoke{*} smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14;
array pkyr{*} pkyr76 pkyr78 pkyr80 pkyr82 pkyr84 pkyr86 pkyr88 pkyr90 pkyr92 pkyr94 pkyr96 pkyr98 pkyr00 pkyr02 pkyr04 pkyr06 pkyr08 pkyr10 pkyr12 pkyr14;   
array cafam2{*} cafam282 cafam282 cafam282 cafam282 cafam282 cafam282 cafam288 cafam288 cafam292 cafam292 cafam296 cafam296 cafam200 cafam200 cafam204 cafam204 cafam208 cafam208 cafam208 cafam208;


 /*impute weights forward if missing or 0 - will be used only for predx values*/
                  do i = 1 to dim(irt)-1;                         
                    if wtar{i} gt 0 and wtar{i} ne . then wtarrpre{i} = wtar{i};
                    else if wtar{i} in (0,.) and i ne 1 then wtarrpre{i} = wtarrpre{i-1};
                    else wtarrpre{i} = .;
                  end;

/*impute weights backwards if missing or 0 - only for postdx values
               do i = 1 to dim(irt)-1; 
                       if wtar{dim(irt)-i} gt 0 and wtar {dim(irt)-i} ne . then wtarpost{dim(irt)-i} = wtar{dim(irt)-i};
                       else if wtar{dim(irt)-i} in (0,.) and i ne 1 then wtarpost{dim(irt)-i} = wtarpost{dim(irt)+1-i};
                       else wtarpost{dim(irt)-i} = .;
               end;
*/
              do i = 1 to dim(irt)-1; 
                       if wtar{i} gt 0 and wtar{i} ne . then wtarpost{i} = wtar{i};
                                                        else wtarpost{dim(irt)-i} = .;
              end;
/*
 if irtr{dim(irt)-1}<mdtdx then do;
                               predxwt = wtarrpre{dim(irt)-1};
                               presmoking = smoke {dim(irt)-1};
                               predxdt = irtr {dim(irt)-1};
							     end;*/
 do i = 2 to dim(irt)-1; /*a do-end loop to determine pre and post diagnosis variables*/
                      if irtr {i-1} lt mdtdx le irtr {i} then 
                       do; /*dt of dx between 2 questionnaires*/
                               predxwt = wtarrpre{i-1};                        /*prediagnosis weight*/
                               presmoking = smoke {i-1};                       /*prediagnosis of smoking*/
							   prepkyr=pkyr {i-1};                             /*prediagnosis pack-year of smoking*/
                               predxdt = irtr {i-1};                           
							   prefh2 = cafam2{i-1};                           /*prediagnosis family history of cancer*/
                               if ((irtr{i}-6) ge mdtdx) and ((irtr{i}-48) lt mdtdx) then 
                                 do; /*for postdx wt - need to be at least 6 m and no more than 48m(4 year) after dx*/
                                       postdxwt = wtarpost{i};  /*postdiagnosis weight. NOT USE IMPUTED*/
                                       postdxdt = irtr{i};      /*Keeps the date of survey for post date measure.*/
                                       postsmoking = smoke {i}; /*postdiagnosis smoking. NOT USE IMPUTED*/
									   postpkyr= pkyr{i};       /*postdiagnosis pack-year of smoking. NOT USE IMPUTED*/
                                 end;
                               else if (irtr{i}-6) lt mdtdx and i ne dim(irt)-1 then 
                                     do;
									   if ((irtr{i+1}-48) lt mdtdx) then 
                                        do;
                                         postdxwt = wtarpost{i+1};    /*postdiagnosis weight. NOT USE IMPUTED*/
                                         postdxdt = irtr{i+1};
                                         postsmoking = smoke {i+1};   /*postdiagnosis smoking. NOT USE IMPUTED*/
										 postpkyr=pkyr {i+1};         /*postdiagnosis pack-year of smoking. NOT USE IMPUTED*/
										end;
                                     end;
                               else do;
                                       postdxwt = .;
                                       postdxdt = .;
                                       postsmoking = .;
									   postpkyr=.;                     
                                       end;
                       end;
  end;

  
/*setting irt array for physical activity and vitamin D score*/
	array irtr_pa {*} irtr86 irtr88 irtr90 irtr92 irtr94 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 irtr12 irtr14 cutoff;
	array irtr_vd {*} irtr86 irtr88 irtr90 irtr92 irtr94 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 cutoff;		  
                     
       if act86m ge 998 then act86m = .;
       if act88m ge 998 then act88m = .;
       if act92m ge 998 then act92m = .;
       if act94m ge 998 then act94m = .;
       if act96m ge 998 then act96m = .;
       if act98m ge 998 then act98m = .;
       if act00m ge 998 then act00m = .;
       if act04m ge 998 then act04m = .;
	   if act06m ge 998 then act06m = .;
	   if act08m ge 998 then act08m = .;
	   if act12m ge 998 then act12m = .;
	   if act14m ge 998 then act14m = .;

	   noinfovdp=.;      /*postdiagnstic VD score in 2010 were set as blank since we can not impute them based on previous reports*/

               array ciactivity{*} act86m act88m act90m act92m act94m act96m act98m act00m act02m act04m act06m act08m act10m act12m act14m;
               array ciactivitypre{*} act86x act88x act90x act92x act94x act96x act98x act00x act02x act04x act06x act08x act10x act12x act14x;
               array ciactivitypost {*} act86y act88y act90y act92y act94y act96y act98y act00y act02y act04y act06y act08y act10y act12y act14y;
			   array vtdar{*} vdp86 vdp88 vdp90 vdp92 vdp94 vdp96 vdp98 vdp00 vdp02 vdp04 vdp06 vdp08 vdp08;   
			   array vtdarave{*} vdp86a vdp88a vdp90a vdp92a vdp94a vdp96a vdp98a vdp00a vdp02a vdp04a vdp06a vdp08a vdp08a;
			   array vtdarpre{*} vdp86x vdp88x vdp90x vdp92x vdp94x vdp96x vdp98x vdp00x vdp02x vdp04x vdp06x vdp08x vdp10x;
			   array vtdarpost{*} vdp86y vdp88y vdp90y vdp92y vdp94y vdp96y vdp98y vdp00y vdp02y vdp04y vdp06y vdp08y noinfovdp;

/*impute CI physical activity forward if missing or 0 - will be used only for predx values*/  
               do i = 1 to dim(irtr_pa)-1;  
                       if ciactivity{i} ne . then ciactivitypre{i} = ciactivity{i};
                       else if ciactivity{i} = . and i ne 1 then ciactivitypre{i}=ciactivitypre{i-1};
                       else ciactivitypre{i} = .;
               end;
/*impute vitamin D score forward if missing - will be used only for predx values*/  
               do i = 1 to dim(irtr_vd)-1;  
					   if vtdar{i} ne . then vtdarpre{i} = vtdar{i};
					   else if vtdar{i} = . and i ne 1 then vtdarpre{i} = vtdarpre{i-1};
					   else vtdarpre{i} =.;
               end;
    /*impute PA backwards if missing or 0 - only for postdx values */     
               do i = 1 to dim(irtr_pa)-1; 
                       if ciactivity {dim(irtr_pa)-i} ne . then ciactivitypost{dim(irtr_pa)-i} = ciactivity{dim(irtr_pa)-i};
                       else if ciactivity{dim(irtr_pa)-i} = . and i ne 1 then ciactivitypost{dim(irtr_pa)-i} = ciactivitypost{dim(irtr_pa)+1-i};
                       else ciactivitypost{dim(irtr_pa)-i} = .;
                       end;
    
 do i = 1 to dim(irtr_pa)-2; 
                       ciactivitypost{i} = ciactivity{i};
                       end;

 do i = 1 to dim(irtr_vd)-2;
 					   vtdarpost{i} = vtdar{i};
                       end;
/*
 if irtr_pa{dim(irtr_pa)-1}<mdtdx then do;
                              predxphact = ciactivitypre {dim(irtr_pa)-1};
							     end;*/
               do i = 2 to dim(irtr_pa)-1; /*a do-end loop to determine pre and post diagnosis variables*/
                      if irtr_pa {i-1} lt mdtdx le irtr_pa {i} then do; /*dt of dx between 2 questionnaires*/
                               predxphact = ciactivitypre {i-1};        /*prediagnosis physical activity*/
							   if (irtr_pa{i}-6) ge mdtdx and ((irtr_pa{i}-48) lt mdtdx) then do; /*for postdx wt - need to be at least 6 m no more than 48m(4 year)after dx*/
                                       postdxphact = ciactivitypost {i}; /*postdiagnosis physical acitivity, NOT USE IMPUTED*/
									   end;
                               else if (irtr_pa{i}-6) lt mdtdx and i ne dim(irtr_pa)-1 then do;
							          if ((irtr_pa{i+1}-48) lt mdtdx) then do;
                                       postdxphact = ciactivitypost{i+1}; /*postdiagnosis physical acitivity,NOT USE IMPUTED*/ 
									   end;
									   end;
                               else do;
                                       postdxphact = .;
									   end;
				     end;
					 
              end;
               do i = 2 to dim(irtr_vd)-1; /*a do-end loop to determine pre and post diagnosis variables*/
                      if irtr_vd {i-1} lt mdtdx le irtr_vd {i} then do; /*dt of dx between 2 questionnaires*/
                               prevtds = vtdarpre{i-1};                 /*prediagnosis raw vitamin D score*/
							   prevtdsav=vtdarave{i-1};                 /*prediagnosis cumulative average of vitamin D score*/
                               if (irtr_vd{i}-6) ge mdtdx and ((irtr_vd{i}-48) lt mdtdx) then do; /*for postdx wt - need to be at least 6 m no more than 48m(4 year)after dx*/
                                       postvtds = vtdarpost{i};          /*postdiagnosis raw vitamin D score, NOT USE IMPUTED*/
                                       end;
                               else if (irtr_vd{i}-6) lt mdtdx and i ne dim(irtr_vd)-1 then do;
							          if ((irtr_vd{i+1}-48) lt mdtdx) then do;
                                       postvtds = vtdarpost{i+1};         /*postdiagnosis raw vitamin D score, NOT USE IMPUTED*/
                                       end;
									   end;
                               else do;
                                       postvtds = .;
                                       end;
					 end;
					 
              end;

/*setting array for endoscopy*/
array irtr_ed {*} irtr88 irtr90 irtr92 irtr94 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 irtr12 irtr14 cutoff;
array endosc{*}   endos88 endos90 endos92 endos94 endos96 endos98 endos00 endos02 endos04 endos06 endos08 endos10 endos12 endos14; 
array hendos{*}   hendo88 hendo90 hendo92 hendo94 hendo96 hendo98 hendo00 hendo02 hendo04 hendo06 hendo08 hendo10 hendo12 hendo14;
                
do i = 2 to dim(irtr_ed)-1; /*a do-end loop to determine pre diagnosis variables*/
                      if irtr_ed {i-1} lt mdtdx le irtr_ed {i} then 
                       do; /*dt of dx between 2 questionnaires*/
                               preendo= endosc{i-1};    /*endoscopy, 2 years before daiagnosis, just once, 0=no, 1=yes*/                        
							   prehendo=hendos{i-1};    /*history of endoscopy, 0=no, 1=yes*/                        
                       end;
  end;


/*predx coding for the cases with irtr14<=date of diagnosis*/
if predxwt = . and irtr14<=mdtdx then predxwt=wt14x;
if predxphact = . and irtr14<=mdtdx then predxphact=act14x;
if presmoking = . and irtr14<=mdtdx then presmoking=smkdr14;
if prepkyr = . and irtr14<=mdtdx then prepkyr=pkyr14;
if prevtds = . and irtr14<=mdtdx then prevtds = vdp10x;
if prevtdsav =. and irtr14<=mdtdx then prevtdsav = vdp08a;
if prefh2 =. and irtr14<=mdtdx then prefh2=cafam208;
if preendo=. and irtr14<=mdtdx then preendo=endos14;
if prehendo=. and irtr14<=mdtdx then prehendo=hendo14;
if irtr14<=mdtdx then predxdt=irtr14;

if prepkyr=998 then prepkyr=0;
if prepkyr=999 then prepkyr=.;
if postpkyr=998 then postpkyr=0;
if postpkyr=999 then postpkyr=.;

/* NHS FH codes 2 */ 
if 1<=prefh2 then prefh=1; 
else if prefh2=0 then prefh=0;
*pre-post-dx FH. FH status at immideately after the dx*;
array postcafam2{*} cafam282 cafam288 cafam292 cafam296 cafam200 cafam204 cafam208;
array postfhirt{*}  irtr82   irtr88   irtr92   irtr96   irtr00   irtr04 irtr08;
prepostfh2=prefh2;
do i=1 to dim(postcafam2)-1;
   if postfhirt{i}<mdtdx<=postfhirt{i+1} then prepostfh2=postcafam2{i+1};
end;
if 1<=prepostfh2 then prepostfh=1;
else if prepostfh2=0 then prepostfh=0;
/* NHS FH codes 2 end*/

       /*convert to kg*/
       predxkg = predxwt / 2.2;
       postdxkg = postdxwt / 2.2;
       
       /*create a date variable for timeframe from postdxweight date to either death or cutoff*/
       if dtdth = . then postdate = cutoff - postdxdt;
       else postdate = dtdth - postdxdt;
       
       /*will exclude patients who had a physical activity measurement less than 6 months from
       death - to reduce bias of decreased activity due to disease*/
      if postdate lt 6 then activityexcl = 1;
      else activityexcl = 0;

       /*create a time from date of prediagnosis activity to diagnosis*/
       if predxdt ne 0 or predxdt ne . then timepredx = mdtdx - predxdt;
       else timepredx = .;
       
       /*create a time from date of diagnosis to postdiagnosis activity */
       if postdate ne 0 or postdate ne . then timepostdx = postdxdt - mdtdx;
       else timepostdx = .;
       
       /*convert to bmi*/
       if ht76 > 0 then predxbmi = (predxwt/2.2)/((ht76*0.0254)*(ht76*0.0254));
       if ht76 > 0 then postdxbmi = (postdxwt/2.2)/((ht76*0.0254)*(ht76*0.0254));
      
      /*change in BMI and KG pre and post dx*/
       bmichange= postdxbmi - predxbmi;
       kgchange = postdxkg - predxkg;
if predxphact = . then predxactivity = 9;
       else if predxphact ge 0 and predxphact le 3 then predxactivity = 1;
       else if predxphact gt 3 and predxphact le 9 then predxactivity = 2;
       else if predxphact gt 9 and predxphact le 18 then predxactivity = 3;
       else if predxphact gt 18 then predxactivity = 4;
       
      if postdxphact = . then postdxactivity = 9;
      else if postdxphact ge 0 and postdxphact le 3 then postdxactivity = 1;
      else if postdxphact gt 3 and postdxphact le 9 then postdxactivity = 2;
      else if postdxphact gt 9 and postdxphact le 18 then postdxactivity = 3;
      else if postdxphact gt 18 then postdxactivity = 4;

/**  Age at Diagnosis: AGEDX      **/
agedx=(mdtdx-bdt)/12;
ageyr=agedx;

        if       agedx < 50 then agegrp=1;
   else if 50 <= agedx < 60 then agegrp=2;
   else if 60 <= agedx < 70 then agegrp=3;
   else if       agedx >= 70 then agegrp=4;
 
%indic3(vbl=agegrp,prefix=agegrp,min=2,max=4,reflev=1, missing=.,usemiss = 0);

/**  Creating a new TNM stage variable.  To do this, I'm  **/
/**  replicating the code Charlie used in his program:    **/
/**  /proj/nhclcs/nhclc0d/cfuchs/colon.032805.sas         **/
newstage = 99;
     if  tstage =5 and nstage =1 and mets =1               then newstage = 0;
else if (tstage =1 or tstage =2) and nstage =1 and mets =1 then newstage = 1;
else if (tstage =3 or tstage =4) and nstage =1 and mets =1 then newstage = 2;
else if  nstage ge 2 and nstage le 4 and mets=1            then newstage = 3;
else if  mets = 2                                          then newstage = 4;

	 if newstage = 1 then stageall=1; 
else if newstage = 2 then stageall=2;
else if newstage = 3 then stageall=3; 
else if newstage = 4 then stageall=4; 
else stageall =5;  
%indic3(vbl=stageall,prefix=stageall,min=2,max=5,reflev=1,usemiss=0); 

/** There is another definition of TNM**/
/**Kana imputed 127 missing stage into stage I and stage II in HPFS**/
/**finalstage is the variable with imputated stages**/
/**To keep consistent with HPFS, we added finalstage into NHS**/
/**5 means missing or in situ**/
/*Compared with stageall, finalstage has less missing stage*/
finalstage=stageall; 
%indic3(vbl=finalstage,prefix=finalstage,min=2,max=5,reflev=1,usemiss=0);    

       
       /*smoker will be the variable to describe smoking status at time of diagnosis*/
       select (presmoking);
       when ('0') presmoker = 5; /*missing*/
       when ('1') presmoker = 1; /*never smoker*/
       when ('2', '3', '4', '5','6','7','8') presmoker = 2; /*past smoker*/
       when ('9', '10', '11', '12', '13', '14', '15') presmoker = 4; /*current smoker*/
       otherwise presmoker = 5; /*missing*/
       end;
       
       select (postsmoking);
       when ('0') postsmoker = 5; /*missing*/
       when ('1') postsmoker = 1; /*never smoker*/
       when ('2', '3', '4', '5','6','7','8') postsmoker = 2; /*past smoker*/
       when ('9', '10', '11', '12', '13', '14', '15') postsmoker = 4; /*current smoker*/
       otherwise postsmoker = 5; /*missing*/
       end;

	   /*pack-year smoking categories*/       
       if (prepkyr=0 or prepkyr=998 or presmoker=1) then prepkyrc=1;       /*never smoking*/     
	else if 0<prepkyr<20 then prepkyrc=2;
	else if 20<=prepkyr<40 then prepkyrc=3;
	else if 40<=prepkyr<998 then prepkyrc=4;
	else prepkyrc=5;     /*missing*/
    
	   if (postpkyr=0 or postpkyr=998 or postsmoker=1) then postpkyrc=1;       /*never smoking*/  
	else if 0<postpkyr<20 then postpkyrc=2;
	else if 20<=postpkyr<40 then postpkyrc=3;
	else if 40<=postpkyr<998 then postpkyrc=4;
	else postpkyrc=5;     /*missing*/
       
/** BELOW ARE THE SURVIVAL TIME CALCULATIONS.  JEFF USED SURVEY DATE IN SOME  **/
/** OF HIS SURVIVAL TIME CALCULATIONS, SO WE WILL NEED TO MODIFY THIS TO USE  **/
/** DATE OF DX FOR OUR ANALYSES.                                              **/
if a and (nhsicda=:'153' or nhsicda=:'154' or dcicda=:'153' or
   dcicda=:'154') & enhsicda ne 'E' then case11=1;
   else case11=0;

   if a and mstr then case19=1;
   else case19=0;

   if a and case11 ne 1 then do;
      if 0<deadmonth<=cutoff then do;
      crccens=0;
      crcsurv=(deadmonth-mdtdx)/12;
      end;
      else if cutoff<deadmonth then do;
      crccens=0;
      crcsurv=(cutoff-mdtdx)/12;
	  end;
      end;

   else if case11 ne 1 then do;
      crccens=0;
      crcsurv=(cutoff-mdtdx)/12; 
      end;

   else if case11 eq 1 then do;
      if 0<deadmonth<=cutoff then do;
      crcsurv=(deadmonth-mdtdx)/12;
      crccens=1;
	  end;
      else if cutoff<deadmonth then do;
      crcsurv=(cutoff-mdtdx)/12;
      crccens=0;
      end;
      end;

   if crcsurv > 120 then do;
      crcsurv = 120;
      crccens = 0;
   end;

   if case19 ne 1 then do;
      oscens=0;
      osurv=(cutoff-mdtdx)/12;
      end;

   else if case19 eq 1 then do;
       if 0<deadmonth<=cutoff then do;
       osurv=(deadmonth-mdtdx)/12;
       oscens=1;
	   end;
       else if cutoff<deadmonth then do;
       osurv=(cutoff-mdtdx)/12;
       oscens=0;
	   end;
       end;

   if osurv > 120 then do;
      osurv = 120;
      oscens = 0;
   end;

/*for postdx activity, the time is from date of postdx activity questionnaire to death or cutoff
         for predx activity, the time is from date of diagnosis to death or cutoff*/
   if case11 eq 1 and case19 eq 1 then do;
		crccens = 1;
		oscens = 1;
		crcsurvpost=(dtdth-postdxdt)/12;
		ospost=(dtdth-postdxdt)/12;		           
		crcsurvpost2 =(dtdth-mdtdx)/12;
		end;
	  else if case11 ne 1 and case19 eq 1 then do;
		crccens = 0;
		oscens = 1;
		crcsurvpost=(dtdth-postdxdt)/12;
                crcsurvpost2 =(dtdth-mdtdx)/12;
		ospost=(dtdth-postdxdt)/12;
		end;
	  else if case11 ne 1 and case19 ne 1 then do;
		crccens = 0;
		oscens = 0;
             	crcsurvpost=(cutoff-postdxdt)/12;
                crcsurvpost2 =(cutoff-mdtdx)/12;
		ospost=(cutoff-postdxdt)/12;
              	end;



/*************************/
/*Aspirin and NSAIDs code*/
/*************************/

*****Aspirin array*****; 
array irt_asp{*} irtr80 irtr82 irtr84 irtr86 irtr88 irtr90 irtr92 irtr94 
                 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 irtr12 irtr14 cutoff;
/*prediagnosis aspirin -impute 86 to 84-*/
array anyaspcarryII{*} anyaspcarry80 anyaspcarry82 anyaspcarry84 anyaspcarry84 anyaspcarry88 anyaspcarry90 anyaspcarry92 
                       anyaspcarry94 anyaspcarry96 anyaspcarry98 anyaspcarry00 anyaspcarry02 anyaspcarry04 anyaspcarry06
                       anyaspcarry08 anyaspcarry10 anyaspcarry12 anyaspcarry14;
array aspwkcarryII{*} aspwkcarry80 aspwkcarry82 aspwkcarry84 aspwkcarry84 aspwkcarry88 aspwkcarry90 aspwkcarry92 
                      aspwkcarry94 aspwkcarry96 aspwkcarry98 aspwkcarry00 aspwkcarry02 aspwkcarry04 aspwkcarry06
                      aspwkcarry08 aspwkcarry10 aspwkcarry12 aspwkcarry14;
array avaspwkcarryII{*} avaspwkcarry80 avaspwkcarry82 avaspwkcarry84 avaspwkcarry84 avaspwkcarry88 avaspwkcarry90 
                        avaspwkcarry92 avaspwkcarry94 avaspwkcarry96 avaspwkcarry98 avaspwkcarry00 avaspwkcarry02 
                        avaspwkcarry04 avaspwkcarry06 avaspwkcarry08 avaspwkcarry10 avaspwkcarry12 avaspwkcarry14;
array regascarryII{*} regascarry80 regascarry82 regascarry84 regascarry84 regascarry88 regascarry90 regascarry92 
                      regascarry94 regascarry96 regascarry98 regascarry00 regascarry02 regascarry04 regascarry06
                      regascarry08 regascarry10 regascarry12 regascarry14;
array avregcarryII{*} avregcarry80 avregcarry82 avregcarry84 avregcarry84 avregcarry88 avregcarry90 avregcarry92 
                      avregcarry94 avregcarry96 avregcarry98 avregcarry00 avregcarry02 avregcarry04 avregcarry06
                      avregcarry08 avregcarry10 avregcarry12 avregcarry14;
/*postdiagnosis aspirin -impute 86 to 88-*/
array anyasppostII{*} anyasppost80 anyasppost82 anyasppost84 anyasppost88 anyasppost88 anyasppost90 anyasppost92 
                      anyasppost94 anyasppost96 anyasppost98 anyasppost00 anyasppost02 anyasppost04 anyasppost06
                      anyasppost08 anyasppost10 anyasppost12 anyasppost14;
array aspwkpostII{*} aspwkpost80 aspwkpost82 aspwkpost84 aspwkpost88 aspwkpost88 aspwkpost90 aspwkpost92
                     aspwkpost94 aspwkpost96 aspwkpost98 aspwkpost00 aspwkpost02 aspwkpost04 aspwkpost06
                     aspwkpost08 aspwkpost10 aspwkpost12 aspwkpost14;
array regaspostII{*} regaspost80 regaspost82 regaspost84 regaspost88 regaspost88 regaspost90 regaspost92
                     regaspost94 regaspost96 regaspost98 regaspost00 regaspost02 regaspost04 regaspost06
                     regaspost08 regaspost10 regaspost12 regaspost14;

*****NSAIDs array*****;
/*NSAIDs was collected from 1990-. NSAIDs is missing before 1990.*/
anyibucarry80=.; anyibucarry82=.; anyibucarry84=.; anyibucarry86=.; anyibucarry88=.;
regibu80y=.;     regibu82y=.;     regibu84y=.;     regibu86y=.;     regibu88y=.;

array anyibucarryII{*} anyibucarry80 anyibucarry82 anyibucarry84 anyibucarry86 anyibucarry88 anyibucarry90 anyibucarry92
                       anyibucarry94 anyibucarry96 anyibucarry98 anyibucarry00 anyibucarry02 anyibucarry04 anyibucarry06
                       anyibucarry08 anyibucarry10 anyibucarry12 anyibucarry14;
array anyibupostII{*} regibu80y regibu82y regibu84y regibu86y regibu88y regibu90y regibu92y 
                      regibu94y regibu96y regibu98y regibu00y regibu02y regibu04y regibu06y
                      regibu08y regibu10y regibu12y regibu14y;

*****Pre and post dx*****;
/*determine immedeately before diagnosis and immedeately after diagnosis aspirin variables*/
do i=2 to dim(irt_asp)-1; 
 if irt_asp{i-1} lt mdtdx le irt_asp{i} then do;
 /*prediagnosis*/
 predxanyasp = anyaspcarryII{i-1}; /*immedeately before diagnosis any use of aspirin*/
 predxaspwk = aspwkcarryII{i-1}; /*immedeately before diagnosis aspirin itnake tabs/week*/
 predxregasp = regascarryII{i-1}; /*immedeately before diagnosis regular use of aspirin*/
 predxaspwkav = avaspwkcarryII{i-1}; /*immedeately before diagnosis cumulative average of intake*/
 predxregaspav = avregcarryII{i-1}; /*immedeately before diagnosis regular use using cumulative average of intake*/
 predxanyibu = anyibucarryII{i-1}; /*immedeately before diagnosis any use of NSAIDs*/

 /*postdiagnosis*/
 postdxanyasp = anyasppostII{i}; /*immedeately after the time of diagnosis any use of aspirin*/
 postdxaspwk = aspwkpostII{i}; /*immedeately after the time of diagnosis aspirin intake tabs/week*/
 postdxregasp = regaspostII{i}; /*immedeately after the time of diagnosis regular use*/
 postdxanyibu = anyibupostII{i}; /*immedeately after the time of diagnosis any use of NSAIDs*/

 cycle = i-1; 
 end;
end;

 /*aspirin use to be consistent with tablets/wk, any asp, and regular asp*/
 *pre*;
      if predxanyasp=1 and 0<predxaspwk then predxaspwk=0;
 else if predxanyasp=1 and predxaspwk=. then predxaspwk=0;
 else if predxanyasp=2 and predxaspwk=0 then predxaspwk=.;
      if predxanyasp=1 and predxregasp=2 then predxregasp=1;
 else if predxanyasp=1 and predxregasp=. then predxregasp=1;
 *else if predxanyasp=2 and predxregasp=1 then predxregasp=1;
 *post*;
      if postdxanyasp=1 and 0<postdxaspwk then postdxaspwk=0;
 else if postdxanyasp=1 and postdxaspwk=. then postdxaspwk=0;
 else if postdxanyasp=2 and postdxaspwk=0 then postdxaspwk=.;
      if postdxanyasp=1 and postdxregasp=2 then postdxregasp=1;
 else if postdxanyasp=1 and postdxregasp=. then postdxregasp=1;
 *else if postdxanyasp=2 and postdxregasp=1 then postdxregasp=1;


/*create a variable for time at which first non-missing post-diagnosis questionnaire returned*/
firstpost=.;
if cycle eq 1 then do;
   if reguasp82 ne . then firstpost=irtr82;
   else if reguasp84 ne . then firstpost=irtr84;
   else if reguasp88 ne . and irtr86 ne . then firstpost=irtr86;
   else if reguasp88 ne . and irtr86 eq . then firstpost=irtr88;
   else if reguasp90 ne . then firstpost=irtr90;
   else if reguasp92 ne . then firstpost=irtr92;
   else if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 2 then do;
   if reguasp84 ne . then firstpost=irtr84;
   else if reguasp88 ne . and irtr86 ne . then firstpost=irtr86;
   else if reguasp88 ne . and irtr86 eq . then firstpost=irtr88;
   else if reguasp88 ne . then firstpost=irtr88;
   else if reguasp90 ne . then firstpost=irtr90;
   else if reguasp92 ne . then firstpost=irtr92;
   else if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 3 then do;
   if reguasp88 ne . and irtr86 ne . then firstpost=irtr86;
   else if reguasp88 ne . and irtr86 eq . then firstpost=irtr88;
   else if reguasp90 ne . then firstpost=irtr90;
   else if reguasp92 ne . then firstpost=irtr92;
   else if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 4 then do;
   if reguasp88 ne . then firstpost=irtr88;
   else if reguasp90 ne . then firstpost=irtr90;
   else if reguasp92 ne . then firstpost=irtr92;
   else if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 5 then do;
   if reguasp90 ne . then firstpost=irtr90;
   else if reguasp92 ne . then firstpost=irtr92;
   else if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 6 then do;
   if reguasp92 ne . then firstpost=irtr92;
   else if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 7 then do;
   if reguasp94 ne . then firstpost=irtr94;
   else if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 8 then do;
   if reguasp96 ne . then firstpost=irtr96;
   else if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 9 then do;
   if reguasp98 ne . then firstpost=irtr98;
   else if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 10 then do;
   if reguasp00 ne . then firstpost=irtr00;
   else if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 11 then do;
   if reguasp02 ne . then firstpost=irtr02;
   else if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 12 then do;
   if reguasp04 ne . then firstpost=irtr04;
   else if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end;
else if cycle eq 13 then do;
   if reguasp06 ne . then firstpost=irtr06;
   else if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end; 
else if cycle eq 14 then do;
   if reguasp08 ne . then firstpost=irtr08;
   else if reguasp10 ne . then firstpost=irtr10;
   else if reguasp12 ne . then firstpost=irtr12;
   else if reguasp14 ne . then firstpost=irtr14;
end; 
else if cycle eq 15 then do;
   if reguasp10 ne . then firstpost=irtr10;
   if reguasp12 ne . then firstpost=irtr12;
   if reguasp14 ne . then firstpost=irtr14;
end;  
else if cycle eq 16 then do;
   if reguasp12 ne . then firstpost=irtr12;
   if reguasp14 ne . then firstpost=irtr14;
end;  
else if cycle eq 17 then do;
   if reguasp14 ne . then firstpost=irtr14;
end;  

/*create a variable for time in months from date of diagnosis 
to first non-missing aspirin questionnaire date*/
postmonth = firstpost-mdtdx;
label postmonth="dtdx to asp Qx";

/**************/
/*Alcohol code*/
/**************/
array irt_alc{*} irtr80 irtr82 irtr84 irtr86 irtr88 irtr90 irtr92 irtr94 
                 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 cutoff;
array orgalc[*] alco80n alco80n alco84n alco86n alco86n alco90n alco90n alco94n 
                alco94n alco98n alco98n alco02n alco02n alco06n alco06n alco10n;
array upalcarr[*] upalc80 upalc80 upalc84 upalc86 upalc86 upalc90 upalc90 upalc94 
                  upalc94 upalc98 upalc98 upalc02 upalc02 upalc06 upalc06 upalc10;
array alcoarr[*] base80n base80n base84n base86n base86n base90n base90n base94n
                 base94n base98n base98n base02n base02n base06n base06n base10n;

do i=1 to dim(orgalc);
   upalcarr[i]=orgalc[i];
   alcoarr[i]=orgalc[i];
end;


/*for predx alcohol, carry foward if missing*/
do i=2 to dim(upalcarr);
   if upalcarr[i]=. and upalcarr[i-1] ne . then upalcarr[i]=upalcarr[i-1];
end;

do i=1 to dim(upalcarr);
   if upalcarr[i]=0 then upalcarr[i]=0;
   else if 0<upalcarr[i]<15 then upalcarr[i]=1;
   else if 15<=upalcarr[i] then upalcarr[i]=2;
end;

/*for postdx alcohol, carry backward if missing*/

do i=dim(alcoarr)-1 to 1 by -1;
   if alcoarr[i] eq . and alcoarr[i+1] ne . then alcoarr[i]=alcoarr[i+1];
end;
do i=1 to dim(alcoarr);
   if alcoarr[i]=0 then alcoarr[i]=0;
   else if 0<alcoarr[i]<15 then alcoarr[i]=1;
   else if 15<=alcoarr[i] then alcoarr[i]=2;
end;

basealcon=alco80n; /*baseline alcohol intake*/

 do i = 2 to dim(irt_alc)-1; /*a do-end loop to determine pre and post diagnosis variables*/
                      if irt_alc {i-1} lt mdtdx le irt_alc {i} then 
                       do; /*dt of dx between 2 questionnaires*/
                               predxalc = upalcarr{i-1};   /*prediagnosis alcohol intake categories*/
                               if ((irt_alc{i}-6) ge mdtdx) and ((irt_alc{i}-48) lt mdtdx) then 
                                 do; /*for postdx wt - need to be at least 6 m and no more than 48m(4 year) after dx*/
                                       postdxalc = alcoarr{i};   /*postdiagnosis alcohol intake categories, use imputed*/
                                 end;
                               else if (irt_alc{i}-6) lt mdtdx and i ne dim(irt_alc)-1 then 
                                     do;
									   if ((irt_alc{i+1}-48) lt mdtdx) then 
                                        do;
                                         postdxalc = alcoarr{i+1};   /*postdiagnosis alcohol intake categories, use imputed*/
										end;
                                     end;
                               else do;
                                       postdxalc = .;
                                       end;
                       end;
  end;

/*predx coindg for the cases with irtr14<=date of diagnosis*/
if predxanyasp = . and irtr14<=mdtdx then predxanyasp=anyaspcarry14;
if predxaspwk = . and irtr14<=mdtdx then predxaspwk=aspwkcarry14;
if predxaspwkav = . and irtr14<=mdtdx then predxaspwkav=avaspwkcarry14;
if predxregasp = . and irtr14<=mdtdx then predxregasp=regascarry14;
if predxregaspav = . and irtr14<=mdtdx then predxregaspav=avregcarry14;
if predxanyibu = . and irtr14<=mdtdx then predxanyibu=anyibucarry14;
if predxalc = . and irtr14<=mdtdx then predxalc=upalc10;

run;

proc sort nodupkey; by id; run;

/********************************NHall data created*******************************************/
/**  Reading and combining HPFS data files. **/


/****************/
/* Read aspirin */
/****************/
/*************************************************
1986-1990 data (no amount was asked)
asp86-asp90: current use of aspirin 2+ times/week
             1=yes 
**************************************************/
%hp86 (keep=id asp86 aspi86 q18pt86 nomed86
            tyl86 motrn86 ibui86 tyli86, noformat=t);
/* aspirin codings all passthroughs will be coded as nonusers*/
aspi86=1;
if asp86=1 then aspi86=2;/*2=current users, 1=never users*/

ibui86=1;
if motrn86=1 then ibui86=2;/*2=current users, 1=never users*/

tyli86=1;
if tyl86=1 then tyli86=2;/*2=current users, 1=never users*/

run;

%hp88 (keep=id asp88 q26pt88 flag88 aspi88
motrn88 ibui88 tyl88 tyli88, noformat=t); /*flag88=1 if long questionnaire, =2 short qx*/
/* aspirin codings all passthroughs, unless they have only answered short qx 
(then coded as missing), will be coded as nonusers*/
aspi88=1;
if asp88=1 then aspi88=2;/*2=current users, 1=never users*/

ibui88=1;
if motrn88=1 then ibui88=2;/*2=current users, 1=never users*/

tyli88=1;
if tyl88=1 then tyli88=2;/*2=current users, 1=never users*/

if flag88=2 then do;
   aspi88=.; /*no aspirin question in short qx*/
   ibui88=.;
   tyli88=.;
end;
run; 

%hp90 (keep=id asp90 aspi90 flag90 q20pt90
motrn90 ibui90 tyl90 tyli90, noformat=t);
 /* aspirin codings, cave need to code those passthrough who have just 
answered the short qx as missing*/
aspi90=1;
if asp90=1 then aspi90=2; /*2=current users, 1=never users*/

ibui90=1;
if motrn90=1 then ibui90=2;/*2=current users, 1=never users*/

tyli90=1;
if tyl90=1 then tyli90=2;/*2=current users, 1=never users*/

if flag90=2 then do;
 aspi90=.;
 ibui90=.;
 tyli90=.; 
end;
run;



/*********************************************************************
1992 data
asp92: current use of aspirin 2+ times/week 
       1=yes
aspd92: Aspirin, average days in a month
        1=Never 2=1-4 days/month 3=5-14 days/month 4=15-21 days/month 
        5=22+ days/month 6=passthru
nasp92: How many aspirin a day
        1=Never, 2=less than 1,	3=1 aspirin, 4=2 aspirin, 
        5=3 - 4 aspirin, 6=5 - 6 aspirin, 7=7+  aspirin, 8=passthru
nomed92: 1=No regular medication, 2=passthru
**********************************************************************/
%hp92 (keep=id asp92 aspd92 nasp92 aspi92 flag92 nomed92 aspd nasp
            aspmo92 aspwk92
            motrn92 tyl92 ibui92 tyli92, noformat=t);
aspi92=.;
if asp92=1 then aspi92=2; /*2=current users, 1=never users*/

ibui92=1;
if motrn92=1 then ibui92=2;/*2=current users, 1=never users*/

tyli92=1;
if tyl92=1 then tyli92=2;/*2=current users, 1=never users*/

/*set each group to the median number of days of asp use**/
if aspd92=1 then aspd=0;
else if aspd92=2 then aspd=2.5;
else if aspd92=3 then aspd=9.5;
else if aspd92=4 then aspd=18;
else if aspd92=5 then aspd=30;
else if aspd92 in (0,6) then aspd=.;

/**median number of asp consumed in each group**/
if nasp92=1 then nasp=0;
else if nasp92=2 then nasp=0.5;
else if nasp92=3 then nasp=1;
else if nasp92=4 then nasp=2;
else if nasp92=5 then nasp=3.5;
else if nasp92=6 then nasp=5.5;
else if nasp92=7 then nasp=9;
else if nasp92 in(0,8) then nasp=.;

aspmo92=aspd*nasp; /**number of tablets asp/month**/

/** translate the continuous intake from asp/month to asp/week **/
aspwk92=aspmo92/4.3;  /*1992 intake of asp/week*/

if aspi92=. then do;
 if aspd92>=3 then aspi92=2; /*uses at least 2 days/week*/
 else if 0<=aspd92<3 then aspi92=1;
 else aspi92=1;/* passthrough the 2+/week question - will get set to missing 
                if they only filled out short qx later*/
 end;              

/*those only filled out short qx are missing*/
if flag92=2 then do; 
 aspi92=.; 
 aspwk92=.; 
 aspd92=.;
 tyli92=.;
 ibui92=.;   
end;

/*if pass through any aspirin and dose/frequency questions,
assume they are non-users if they filled out long form and didn't check
yes for aspirin as regular med*/
if flag92=1 then do;
 if aspi92=1 and aspwk92=. then  aspwk92=0; 
 if aspi92=1 and aspd92=. then aspd92=1;  
end;   

run;


/*********************************************************************
1994 data
asp94: current use of aspirin 2+ times/week
       1=yes
aspw94: How many aspirin tabs/week
        1=0, 2=0.5-2/week, 3=3 - 5, 4=6 - 14, 5=15+/week, 6=Passthru
aspfr94: How frequently you take aspirin
         1=<1 day/month, 2=3 days/month, 3=1-2 day/week, 4=3-4 days/week, 
	     5=5-6 days/week, 6=daily, 7=Passthru
**********************************************************************/
%hp94(keep=id asp94 aspfr94 aspw94 aspi94 aspwk94 aspmo94 freque94 nasp94 naspxx 
           aspd94 flag94
            motrn94 tyl94 ibui94 tyli94, noformat=t);

aspi94=.;
if asp94=1 then aspi94=2;/*2=current users, 1=never users*/
/* tylenol codings*/
tyli94=1;
if tyl94=1 then tyli94=2;/*2=current users, 1=never users*/

/* ibuprofen codings*/
ibui94=1;
if motrn94=1 then ibui94=2;/*2=current users, 1=never users*/
/*07.08.04 recode the 1994 ibuprofen variable*/

freque94=aspfr94;
nasp94=aspw94;

/*set each group to the median number of days of asp use**/
     if freque94=1 then aspd94=1;
else if freque94=2 then aspd94=2;
else if freque94=3 then aspd94=3;
else if freque94=4 then aspd94=4;
else if freque94 in (5,6) then aspd94=5;
else if freque94 in (0,7) then aspd94=.;

/**set each group to the median number of asp consumed**/
     if nasp94=1 then naspxx=0;
else if nasp94=2 then naspxx=1.25;
else if nasp94=3 then naspxx=4;
else if nasp94=4 then naspxx=10;
else if nasp94=5 then naspxx=20;
else if nasp94 in(0,6) then naspxx=.;

aspwk94 = naspxx; /*1994 average asp per week*/
aspmo94 = naspxx * 4.3; /*1994 asp per month*/

if aspi94=. then do;
 if aspd94>=3 then aspi94=2; /*at least 2 times per week*/
 else if 0<=aspd94<3 then aspi94=1;
 else aspi94=1;/* passthrough the 2+/week question - will set back to missing if 
they did not answer long form*/
end;

if flag94=2 then do;
 aspi94=.;
 aspwk94=.;
 aspd94=.;
 ibui94=.;
 tyli94=.;
end;

/*if pass through any aspirin and dose/frequency questions,
assume they are non-users if they filled out long form and didn't check
yes for aspirin as regular med*/  
if flag94=1 then do;
 if aspi94=1 and aspwk94=. then aspwk94=0;
 if aspi94=1 and aspd94=. then aspd94=1;
end;
run;


/**********************************************************************
1996 data
aspd96: aspirin, days per month
        1=Never 2=1-4 days/mo 3=5-14 days/mo 4=15-21 days/mo 
        5=22+ days/mo 6=Passthru
nasp96: aspirin, average per day
        1=Never  2=<1 aspirin (e.g., baby aspirin)  3=1 aspirin 4=2 aspirin
        5=3-4 aspirin  6=5-6 aspirin  7=7+ aspirin   8=Passthru

**********************************************************************/
%hp96 (keep=id aspd96 nasp96 flag96 aspi96 aspd nasp aspmo96 aspwk96
            motrn96 tyl96 ibui96 tyli96 onsai96, noformat=t);
/*set each group to the median number of days of asp use**/
if aspd96=1 then aspd=0;
else if aspd96=2 then aspd=2.5;
else if aspd96=3 then aspd=9.5;
else if aspd96=4 then aspd=18;
else if aspd96=5 then aspd=30;
else if aspd96 in (0,6) then aspd=.;

/**median number of asp consumed in each group**/
if nasp96=1 then nasp=0;
else if nasp96=2 then nasp=0.5;
else if nasp96=3 then nasp=1;
else if nasp96=4 then nasp=2;
else if nasp96=5 then nasp=3.5;
else if nasp96=6 then nasp=5.5;
else if nasp96=7 then nasp=9;
else if nasp96 in(0,8) then nasp=.;

aspmo96=aspd*nasp; /**number of tablets asp/month**/

/** translate the continuous intake from asp/month to asp/week **/
aspwk96=aspmo96/4.3;  /*1996 intake of asp/week*/


if 0<=aspd96<3 then aspi96=1;
else if aspd96>=3 then aspi96=2; /*at least 2+ times/week*/
else aspi96=.;

   ibui96=1;
   if motrn96=1 then ibui96=2;
   else if onsai96=1 then ibui96=2;
   
   tyli96=1;
   if tyl96=1 then tyli96=2;

/* flag those persons who just answered the short questionnaire
in 1996*/
if flag96=2 then do;
 aspi96=.;
 aspwk96=.;
 aspd96=.;
 ibui96=.;
 tyli96=.;
end;
run;

/**********************************************************************
1998 data
aspfr98: how frequently take aspirin
         1= 0 day/month  2= 1-3 days/month  3= 1-2 day/week  
         4= 3-4 days/week  5= 5-6 days/week  6= daily  7= Passthru
aspw98: how many aspirin tablets/week
        1= 0/wk  2= 0.5-2/week  3= 3-5/wk  4= 6-14/wk
        5= 15+/week 6= Passthru
**********************************************************************/
%hp98(keep=id aspfr98 aspw98 flag98 nasp98 aspd98 naspx aspwk98 aspmo98 aspi98
           tyl98 motrn98 nsaid98 ibui98 tyli98, noformat=t);

nasp98= aspw98;

/*set aspfr98 to the same category of the other years*/
if aspfr98=1 then aspd98=1;
else if aspfr98=2 then aspd98=2;
else if aspfr98=3 then aspd98=3;
else if aspfr98=4 then aspd98=4;
else if aspfr98 in (5,6) then aspd98=5;
else if aspfr98 in (0,7) then aspd98=.;

/**set each group to the median number of asp consumed**/
if nasp98=1 then naspx=0;
else if nasp98=2 then naspx=1.25;
else if nasp98=3 then naspx=4;
else if nasp98=4 then naspx=10;
else if nasp98=5 then naspx=20;
else if nasp98 in(0,6) then naspx=.;

aspwk98 = naspx; /*1998 average asp per week*/
aspmo98 = naspx * 4.3; /*1998 asp per month*/

if 0<=aspd98<3 then aspi98=1;
else if aspd98>=3 then aspi98=2;
else aspi98=.;

   ibui98=1;
   if motrn98=1 then ibui98=2;
   if nsaid98=1 then ibui98=2;
   
   tyli98=1;
   if tyl98=1 then tyli98=2;


/* flag those persons who just answered the short questionnaire
in 1998*/
if flag98=2 then do;
 aspi98=.;
 aspwk98=.;
 aspd98=.;
 ibui98=.;
 tyli98=.;
end;
run;

/************************************************************
2000 data
asp00: current use of aspirin 2+ times/week
       1=yes
aspdw00: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspw00: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds00: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
************************************************************/
%hp00(keep=id asp00 aspw00 aspdw00 aspds00 flag00 aspd00 nasp00 aspi00 naspxx dosxx mgwk
      aspwk00 aspmo00
      tyl00 tyldw00 tylw00 motrn00 nsaid00 mtrnw00 mtrdw00
      ibui00 tyli00, noformat=t); /*no baby aspirin info*/

aspd00= aspdw00;
nasp00= aspw00;

if flag00=1 then do;
 if asp00=1 then aspi00=2;  
 else if aspdw00 in (2,3,4) then aspi00=2;
 else aspi00=1;/* passthrough the 2+/week question*/
end;

/* tylenol codings*/
if flag00=1 then do;
 tyli00=1;
 if tyl00=1 then tyli00=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag00=1 then do;
 ibui00=1;
 if motrn00=1 then ibui00=2;/*2=current users, 1=never users*/
 if mtrdw00 in (2,3,4) then ibui00=2;
 if nsaid00=1 then ibui00=2; /*nsaids other than ibuprofen*/
end;

/*set aspfr98 to the same category of the other years*/
if aspdw00=1 then aspd00=2;
else if aspdw00=2 then aspd00=3;
else if aspdw00=3 then aspd00=4;
else if aspdw00=4 then aspd00=5;
else if aspi00=1 then aspd00=1; /*non-user*/
else if aspdw00 in (0,5) then aspd00=.; 
    
/**set each group to the median number of asp consumed**/
if nasp00=1 then naspxx=1.5;
else if nasp00=2 then naspxx=4;
else if nasp00=3 then naspxx=10;
else if nasp00=4 then naspxx=20;
else if aspi00=1 then naspxx=0; /*non-user*/
else if nasp00 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds00=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds00=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds00=3 then dosxx=325;
else if aspds00=4 then dosxx=650;
else if aspds00 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/

/*standard aspirin tablets/week*/
aspwk00 = mgwk/325; /*2000average asp per week (standard dose equivalents)*/
aspmo00 = aspwk00 * 4.3; /*2000 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag00=2 then do;
 aspi00=.;
 aspwk00=.;
 aspd00=.;
 ibui00=.;
 tyli00=.;
end;
run;

/************************************************************
2002 data
asp02: regular use of aspirin
       1=yes
aspd02: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt02: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds02: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
*************************************************************/
%hp02(keep=id asp02 aspd02 aspt02 aspds02 flag02 nasp02 aspi02 naspxx dosxx
      mgwk aspwk02 aspmo02
      tyl02 tyld02 tylt02 mtrn02 mtrnd02 mtrnt02 analg02 cox2i02
      ibui02 tyli02, noformat=t);

aspd02= aspd02;
nasp02= aspt02;

if flag02=1 then do;
 if asp02=1 then aspi02=2;  
 else if aspd02 in (2,3,4) then aspi02=2;
 else aspi02=1;/* passthrough regular-use question*/
end;

/* tylenol codings*/
if flag02=1 then do;
 tyli02=1;
 if tyl02=1 then tyli02=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag02=1 then do;
 ibui02=1;
 if mtrnd02 in (2,3,4) then ibui02=2;
 if mtrn02=1 then ibui02=2;/*2=current users, 1=never users*/
 if analg02=1 then ibui02=2; /*nsaids other than ibuprofen*/
 *if cox2i02 =1 then ibui02=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd02=1 then aspd02=2;
else if aspd02=2 then aspd02=3;
else if aspd02=3 then aspd02=4;
else if aspd02=4 then aspd02=5;
else if aspi02=1 then aspd02=1; /*non-user*/
else if aspd02 in (0,5) then aspd02=.; 

/**set each group to the median number of asp consumed**/
if nasp02=1 then naspxx=1.5;
else if nasp02=2 then naspxx=4;
else if nasp02=3 then naspxx=10;
else if nasp02=4 then naspxx=20;
else if aspi02=1 then naspxx=0; /*non-user*/
else if nasp02 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds02=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds02=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds02=3 then dosxx=325;
else if aspds02=4 then dosxx=650;
else if aspds02 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/
      
/*standard aspirin tablets/week*/
aspwk02 = mgwk/325; /*2002 average asp per week (standard dose equivalents)*/
aspmo02 = aspwk02 * 4.3; /*2002 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag02=2 then do;
 aspi02=.;
 aspwk02=.;
 aspd02=.;
 ibui02=.;
 tyli02=.;
end;
run;

/************************************************************
2004 data
asp04: regular use of aspirin
       1=yes
aspd04: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt04: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds04: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
*************************************************************/
%hp04(keep=id asp04 aspd04 aspt04 aspds04 flag04 nasp04 aspi04 naspxx dosxx
      mgwk aspwk04 aspmo04
      tyl04 tyld04 tylt04 mtrn04 mtrnd04 mtrnt04 analg04 cox2i04 cox2d04
      ibui04 tyli04, noformat=t);

aspd04= aspd04;
nasp04= aspt04;

if flag04=1 then do;
 if asp04=1 then aspi04=2;  
 else if aspd04 in (2,3,4) then aspi04=2;
 else aspi04=1;/* passthrough the regular-use question*/
end;

/* tylenol codings*/
if flag04=1 then do;
 tyli04=1;
 if tyl04=1 then tyli04=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag04=1 then do;
 ibui04=1;
 if mtrn04=1 then ibui04=2;/*2=current users, 1=never users*/
 if mtrnd04 in (2,3,4) then ibui04=2;
 if analg04=1 then ibui04=2; /*nsaids other than ibuprofen*/
 *if cox2i04=1 then ibui04=2;
 *if cox2d04 in (2,3,4) then ibui04=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd04=1 then aspd04=2;
else if aspd04=2 then aspd04=3;
else if aspd04=3 then aspd04=4;
else if aspd04=4 then aspd04=5;
else if aspi04=1 then aspd04=1; /*non-user*/
else if aspd04 in (0,5) then aspd04=.; 

/**set each group to the median number of asp consumed**/
     if nasp04=1 then naspxx=1.5;
else if nasp04=2 then naspxx=4;
else if nasp04=3 then naspxx=10;
else if nasp04=4 then naspxx=20;
else if aspi04=1 then naspxx=0; /*non-user*/
else if nasp04 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds04=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds04=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds04=3 then dosxx=325;
else if aspds04=4 then dosxx=650;
else if aspds04 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/
      
/*standard aspirin tablets/week*/   
aspwk04 = mgwk/325; /*2004 average asp per week (standard dose equivalents)*/
aspmo04 = aspwk04 * 4.3; /*2004 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag04=2 then do;
 aspi04=.;
 aspwk04=.;
 aspd04=.;
 ibui04=.;
 tyli04=.;
end;
run;

/************************************************************
2006 data
asp06: regular use of aspirin
       1=yes
aspd06: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt06: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds06: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
************************************************************/
%hp06(keep=id asp06 aspd06 aspt06 aspds06 flag06 nasp06 aspi06 naspxx dosxx
      mgwk aspwk06 aspmo06
      tyl06 tyld06 tylt06 mtrn06 mtrnd06 mtrnt06 analg06 cox2i06 cox2d06
      ibui06 tyli06, noformat=t);


aspd06= aspd06;
nasp06= aspt06;

if flag06=1 then do;
 if asp06=1 then aspi06=2;  
 else if aspd06 in (2,3,4) then aspi06=2;
 else aspi06=1;/* passthrough the regular-use question*/
end;

/* tylenol codings*/
if flag06=1 then do;
 tyli06=1;
 if tyl06=1 then tyli06=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag06=1 then do;
 ibui06=1;
 if mtrn06=1 then ibui06=2;/*2=current users, 1=never users*/
 if mtrnd06 in (2,3,4) then ibui06=2;
 if analg06=1 then ibui06=2; /*nsaids other than ibuprofen*/
 *if cox2i06=1 then ibui06=2;
 *if cox2d06 in (2,3,4) then ibui06=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd06=1 then aspd06=2;
else if aspd06=2 then aspd06=3;
else if aspd06=3 then aspd06=4;
else if aspd06=4 then aspd06=5;
else if aspi06=1 then aspd06=1; /*non-user*/
else if aspd06 in (0,5) then aspd06=.; 

/**set each group to the median number of asp consumed**/
     if nasp06=1 then naspxx=1.5;
else if nasp06=2 then naspxx=4;
else if nasp06=3 then naspxx=10;
else if nasp06=4 then naspxx=20;
else if aspi06=1 then naspxx=0; /*non-user*/
else if nasp06 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds06=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds06=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds06=3 then dosxx=325;
else if aspds06=4 then dosxx=650;
else if aspds06 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/
      
/*standard aspirin tablets/week*/   
aspwk06 = mgwk/325; /*2006 average asp per week (standard dose equivalents)*/
aspmo06 = aspwk06 * 4.3; /*2006 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag06=2 then do;
 aspi06=.;
 aspwk06=.;
 aspd06=.;
 ibui06=.;
 tyli06=.;
end;
run;

/************************************************************
2008 data
asp08: regular use of aspirin
       1=yes
aspd08: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt08: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds08: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
************************************************************/
%hp08(keep=id asp08 aspd08 aspt08 aspds08 flag08 nasp08 aspi08 naspxx dosxx
      mgwk aspwk08 aspmo08
      tyl08 tyld08 tylt08 mtrn08 mtrnd08 mtrnt08 analg08 cox2i08 cox2d08
      ibui08 tyli08);

aspd08= aspd08;
nasp08= aspt08;

if flag08=1 then do;
 if asp08=1 then aspi08=2;  
 else if aspd08 in (2,3,4) then aspi08=2;
 else aspi08=1;/* passthrough the regular-use question*/
end;

/* tylenol codings*/
if flag08=1 then do;
 tyli08=1;
 if tyl08=1 then tyli08=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag08=1 then do;
 ibui08=1;
 if mtrn08=1 then ibui08=2;/*2=current users, 1=never users*/
 if mtrnd08 in (2,3,4) then ibui08=2;
 if analg08=1 then ibui08=2; /*nsaids other than ibuprofen*/
 *if cox2i08=1 then ibui08=2;
 *if cox2d08 in (2,3,4) then ibui08=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd08=1 then aspd08=2;
else if aspd08=2 then aspd08=3;
else if aspd08=3 then aspd08=4;
else if aspd08=4 then aspd08=5;
else if aspi08=1 then aspd08=1; /*non-user*/
else if aspd08 in (0,5) then aspd08=.; 

/**set each group to the median number of asp consumed**/
     if nasp08=1 then naspxx=1.5;
else if nasp08=2 then naspxx=4;
else if nasp08=3 then naspxx=10;
else if nasp08=4 then naspxx=20;
else if aspi08=1 then naspxx=0; /*non-user*/
else if nasp08 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds08=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds08=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds08=3 then dosxx=325;
else if aspds08=4 then dosxx=650;
else if aspds08 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/
      
/*standard aspirin tablets/week*/   
aspwk08 = mgwk/325; /*2008 average asp per week (standard dose equivalents)*/
aspmo08 = aspwk08 * 4.3; /*2008 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag08=2 then do;
 aspi08=.;
 aspwk08=.;
 aspd08=.;
 ibui08=.;
 tyli08=.;
end;
run;

/************************************************************
2010 data
asp10: regular use of aspirin
       1=yes
aspd10: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt10: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds10: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
************************************************************/    
%hp10(keep=id asp10 aspd10 aspt10 aspds10 flag10 nasp10 aspi10 naspxx dosxx
      mgwk aspwk10 aspmo10
      tyl10 tyld10 tylt10 mtrn10 mtrnd10 mtrnt10 analg10 cox2i10 cox2d10
      ibui10 tyli10);

aspd10= aspd10;
nasp10= aspt10;

if flag10=1 then do;
 if asp10=1 then aspi10=2;  
 else if aspd10 in (2,3,4) then aspi10=2;
 else aspi10=1;/* passthrough the regular-use question*/
end;

/* tylenol codings*/
if flag10=1 then do;
 tyli10=1;
 if tyl10=1 then tyli10=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag10=1 then do;
 ibui10=1;
 if mtrn10=1 then ibui10=2;/*2=current users, 1=never users*/
 if mtrnd10 in (2,3,4) then ibui10=2;
 if analg10=1 then ibui10=2; /*nsaids other than ibuprofen*/
 *if cox2i10=1 then ibui10=2;
 *if cox2d10 in (2,3,4) then ibui10=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd10=1 then aspd10=2;
else if aspd10=2 then aspd10=3;
else if aspd10=3 then aspd10=4;
else if aspd10=4 then aspd10=5;
else if aspi10=1 then aspd10=1; /*non-user*/
else if aspd10 in (0,5) then aspd10=.; 

/**set each group to the median number of asp consumed**/
     if nasp10=1 then naspxx=1.5;
else if nasp10=2 then naspxx=4;
else if nasp10=3 then naspxx=10;
else if nasp10=4 then naspxx=20;
else if aspi10=1 then naspxx=0; /*non-user*/
else if nasp10 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds10=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds10=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds10=3 then dosxx=325;
else if aspds10=4 then dosxx=650;
else if aspds10 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/
      
/*standard aspirin tablets/week*/   
aspwk10 = mgwk/325; /*2010 average asp per week (standard dose equivalents)*/
aspmo10 = aspwk10 * 4.3; /*2010 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag10=2 then do;
 aspi10=.;
 aspwk10=.;
 aspd10=.;
 ibui10=.;
 tyli10=.;
end;
run;

/************************************************************
2012 data
asp12: regular use of aspirin
       1=yes
aspd12: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt12: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
aspds12: dose per tablet
         1.50-99  2.100-249  3.250-349  4.350+  5.Passthru
************************************************************/    
%hp12(keep=id asp12 aspd12 aspt12 aspds12 flag12 nasp12 aspi12 naspxx dosxx
      mgwk aspwk12 aspmo12
      tyl12 tyld12 tylt12 mtrn12 mtrnd12 mtrnt12 analg12 cox2i12 cox2d12
      ibui12 tyli12);

aspd12= aspd12;
nasp12= aspt12;

if flag12=1 then do;
 if asp12=1 then aspi12=2;  
 else if aspd12 in (2,3,4) then aspi12=2;
 else aspi12=1;/* passthrough the regular-use question*/
end;

/* tylenol codings*/
if flag12=1 then do;
 tyli12=1;
 if tyl12=1 then tyli12=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag12=1 then do;
 ibui12=1;
 if mtrn12=1 then ibui12=2;/*2=current users, 1=never users*/
 if mtrnd12 in (2,3,4) then ibui12=2;
 if analg12=1 then ibui12=2; /*nsaids other than ibuprofen*/
 *if cox2i12=1 then ibui12=2;
 *if cox2d12 in (2,3,4) then ibui12=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd12=1 then aspd12=2;
else if aspd12=2 then aspd12=3;
else if aspd12=3 then aspd12=4;
else if aspd12=4 then aspd12=5;
else if aspi12=1 then aspd12=1; /*non-user*/
else if aspd12 in (0,5) then aspd12=.; 

/**set each group to the median number of asp consumed**/
     if nasp12=1 then naspxx=1.5;
else if nasp12=2 then naspxx=4;
else if nasp12=3 then naspxx=10;
else if nasp12=4 then naspxx=20;
else if aspi12=1 then naspxx=0; /*non-user*/
else if nasp12 in(0,5) then naspxx=.;

/*aspirin dose*/
if aspds12=1 then dosxx=81; /*81 mg dose is likely*/
else if aspds12=2 then dosxx=162; /*2 baby aspirin dose*/
else if aspds12=3 then dosxx=325;
else if aspds12=4 then dosxx=650;
else if aspds12 in (0,5) then dosxx=.;

/** total mg per week**/
if dosxx ne . then mgwk=naspxx*dosxx; 
else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/
      
/*standard aspirin tablets/week*/   
aspwk12 = mgwk/325; /*2012 average asp per week (standard dose equivalents)*/
aspmo12 = aspwk12 * 4.3; /*2012 asp per month*/

/*if only filled out short questionnaire, set back to missing*/
if flag12=2 then do;
 aspi12=.;
 aspwk12=.;
 aspd12=.;
 ibui12=.;
 tyli12=.;
end;
run;

/************************************************************
2014 data
basp14: regular use of baby or low dose (100mg or less/tablet) aspirin
       1=yes
baspd14: Baby Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
baspt14: Baby Aspirin Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
asp14: regular use of aspirin
       1=yes
aspd14: Aspirin: Days/Week
         1=1  2=2-3  3=4-5  4=6+  5=Passthru
aspt14: Tablets/wk
        1=1-2  2=3-5  3=6-14  4=15+  5=Passthru
************************************************************/    
%hp14(keep=id asp14 aspd14 aspt14 basp14 baspd14 baspt14 flag14 nasp14 nbasp14 regu14 regubab14 
naspxx nbaspxx naspqxx aspwk14 aspmo14 aspi14
      tyl14 tyld14 tylt14 mtrn14 mtrnd14 mtrnt14 analg14 cox2i14 cox2d14
      ibui14 tyli14);

aspd14= aspd14;
nasp14= aspt14;
baspd14= baspd14;
nbasp14= baspt14;

/* aspirin codings*/
if flag14=1 then do;
 if asp14=1 then regu14=2;  
 else if aspd14 in (2,3,4) then regu14=2;
 else regu14=1;/* passthrough the regular-use question*/
end;

/* baby aspirin codings*/
if flag14=1 then do;
 if basp14=1 then regubab14=2;  
 else if baspd14 in (2,3,4) then regubab14=2;
 else regubab14=1;/* passthrough the basy aspirin regular-use question*/
end;

/* tylenol codings*/
if flag14=1 then do;
 tyli14=1;
 if tyl14=1 then tyli14=2;/*2=current users, 1=never users*/
end;
   
/* ibuprofen codings*/
if flag14=1 then do;
 ibui14=1;
 if mtrn14=1 then ibui14=2;/*2=current users, 1=never users*/
 if mtrnd14 in (2,3,4) then ibui14=2;
 if analg14=1 then ibui14=2; /*nsaids other than ibuprofen*/
 *if cox2i14=1 then ibui14=2;
 *if cox2d14 in (2,3,4) then ibui14=2;
end;

/*set aspfr98 to the same category of the other years*/
if aspd14=1 then aspd14=2;
else if aspd14=2 then aspd14=3;
else if aspd14=3 then aspd14=4;
else if aspd14=4 then aspd14=5;
else if regu14=1 then aspd14=1; /*non-user*/
else if aspd14 in (0,5) then aspd14=.; 

if baspd14=1 then aspd14=2;
else if baspd14=2 then baspd14=3;
else if baspd14=3 then baspd14=4;
else if baspd14=4 then baspd14=5;
else if regubab14=1 then baspd14=1; /*non-user*/
else if baspd14 in (0,5) then baspd14=.; 

/**set each group to the median number of asp consumed**/
     if nasp14=1 then naspxx=1.5;
else if nasp14=2 then naspxx=4;
else if nasp14=3 then naspxx=10;
else if nasp14=4 then naspxx=20;
else if regu14=1 then naspxx=0; /*non-user*/
else if nasp14 in(0,5) then naspxx=.;

/**set each group to the median number of baby asp consumed**/
     if nbasp14=1 then nbaspxx=1.5;
else if nbasp14=2 then nbaspxx=4;
else if nbasp14=3 then nbaspxx=10;
else if nbasp14=4 then nbaspxx=20;
else if regubab14=1 then nbaspxx=0; /*non-user*/
else if nbasp14 in(0,5) then nbaspxx=.;

naspqxx=nbaspxx/4; /*number of aspirin equivalents*/

/*2014 intake asp/week*/
 if naspxx eq . and naspqxx ne . then aspwk14=naspqxx;
 else if naspxx ne . and naspqxx eq . then aspwk14=naspxx;
 else  aspwk14 = naspxx+ naspqxx; 
 if regu14=2 and naspxx in (0,.) and naspqxx in (0,.) then aspwk14=.; 
 else if regubab14=2 and naspxx in (0,.) and naspqxx in (0,.) then aspwk14=.; 
    
aspmo14 = aspwk14 * 4.3; /*2014 asp per month*/

 if regu14=2 or aspwk14>=2 then aspi14=2;
 else aspi14=1;

/*if only filled out short questionnaire, set back to missing*/
if flag14=2 then do;
 aspi14=.;
 aspwk14=.;
 aspd14=.;
 baspd14=.;
 ibui14=.;
 tyli14=.;
end;
run;

/*merge aspirin files*/
data hpaspone;
merge hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14;
by id;

/*Carry forward or backward if missing and creat new aspirin variables*/
/*aspirin intake tabs/week -available from 1992-*/
array aspwk{*} aspwk92 aspwk94 aspwk96 aspwk98 aspwk00 aspwk02 aspwk04 aspwk06 aspwk08 aspwk10 aspwk12 aspwk14;
array aspwkpre{*} aspwkpre92 aspwkpre94 aspwkpre96 aspwkpre98 aspwkpre00 
                  aspwkpre02 aspwkpre04 aspwkpre06 aspwkpre08 aspwkpre10 aspwkpre12 aspwkpre14;			   
array aspwkpost{*} aspwkpost92 aspwkpost94 aspwkpost96 aspwkpost98 aspwkpost00
                   aspwkpost02 aspwkpost04 aspwkpost06 aspwkpost08 aspwkpost10 aspwkpost12 aspwkpost14;
array avaspwkpre{*} avaspwkpre92 avaspwkpre94 avaspwkpre96 avaspwkpre98 avaspwkpre00
                    avaspwkpre02 avaspwkpre04 avaspwkpre06 avaspwkpre08 avaspwkpre10 avaspwkpre12 avaspwkpre14;
array aspwkcarry{*} aspwkcarry92 aspwkcarry94 aspwkcarry96 aspwkcarry98 aspwkcarry00 
                    aspwkcarry02 aspwkcarry04 aspwkcarry06 aspwkcarry08 aspwkcarry10 aspwkcarry12 aspwkcarry14;
array avaspwkcarry{*} avaspwkcarry92 avaspwkcarry94 avaspwkcarry96 avaspwkcarry98 avaspwkcarry00 
                      avaspwkcarry02 avaspwkcarry04 avaspwkcarry06 avaspwkcarry08 avaspwkcarry10 avaspwkcarry12 avaspwkcarry14;

/*regular use of aspirin*/
/*cumulative average is not calculated for regular use in HPFS 
because regular use is defined as frequency (2 or more times/week)*/					  
array reguasp{*} aspi86 aspi88 aspi90 aspi92 aspi94
                 aspi96 aspi98 aspi00 aspi02 aspi04 aspi06 aspi08 aspi10 aspi12 aspi14;
array regaspre{*} regaspre86 regaspre88 regaspre90 regaspre92 regaspre94
                  regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14;
array regaspost{*} regaspost86 regaspost88 regaspost90 regaspost92 regaspost94
                   regaspost96 regaspost98 regaspost00 regaspost02 regaspost04 regaspost06 regaspost08 regaspost10 regaspost12 regaspost14;
array regascarry{*} regascarry86 regascarry88 regascarry90 regascarry92 regascarry94
                    regascarry96 regascarry98 regascarry00 regascarry02 regascarry04 regascarry06 regascarry08 regascarry10 regascarry12 regascarry14;

/*duration of regular use of aspirin*/
array adur{*} adur8688 adur8890 adur9092 adur9294 adur9496 adur9698 adur9800 
              adur0002 adur0204 adur0406 adur0608 adur0810 adur1012 adur1214 adur1416;
array adurarray{*} adur8688 adur8890 adur9092 adur9294 adur9496 adur9698 adur9800
                adur0002 adur0204 adur0406 adur0608 adur0810 adur1012 adur1214 adur1416;

/*to have same number in the array from 1992*/
array sameaspwk{*} aspwk92 aspwk94 aspwk96 aspwk98 aspwk00 aspwk02 aspwk04 aspwk06 aspwk08 aspwk10 aspwk12 aspwk14;
array samereguasp{*} aspi92 aspi94 aspi96 aspi98 aspi00 aspi02 aspi04 aspi06 aspi08 aspi10 aspi12 aspi14;
array sameaspwkpre{*} aspwkpre92 aspwkpre94 aspwkpre96 aspwkpre98 aspwkpre00 
                  aspwkpre02 aspwkpre04 aspwkpre06 aspwkpre08 aspwkpre10 aspwkpre12 aspwkpre14;			   
array sameregaspre{*} regaspre92 regaspre94
                  regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14;

***NSAIDs array***;
/*any use of ibuprofen*/
array anyibu{*} ibui86 ibui88 ibui90 ibui92 ibui94 ibui96 ibui98 ibui00 ibui02 ibui04 ibui06 ibui08 ibui10 ibui12 ibui14;
array anyibupost{*} regibu86y regibu88y regibu90y regibu92y regibu94y 
                    regibu96y regibu98y regibu00y regibu02y regibu04y 
                    regibu06y regibu08y regibu10y regibu12y regibu14y;
array anyibucarry{*} anyibucarry86 anyibucarry88 anyibucarry90 anyibucarry92 anyibucarry94 
                     anyibucarry96 anyibucarry98 anyibucarry00 anyibucarry02 anyibucarry04 
                     anyibucarry06 anyibucarry08 anyibucarry10 anyibucarry12 anyibucarry14;

*****Aspirin*****;
/*cumulative average of aspirin variables before carrying forward
  available from 1992*/
/*prediagnosis cumulative average of aspirin tabs/week*/
sumvar=0; n=0;
do j=1 to dim(aspwk);
 avaspwkpre{j} = aspwk{j};
 if (aspwk{j} ne .) then do;
  n=n+1;
  sumvar=sumvar+aspwk{j};
 end;

 if n=0 then avaspwkpre{j} = aspwk{j};
 else avaspwkpre{j} = sumvar/n;
end;

/*Prediagnosis*/
/*carry aspirin variables forward ONE CYCLE if missing to use these as time-dependent variables*/    
/*carry forward aspirin tabs/week one cycle*/
do i=1 to dim(aspwk);
 aspwkpre{i}=aspwk{i};
end;

do i=dim(aspwkpre) to 2 by -1;
 if aspwkpre{i} eq . and aspwkpre{i-1} ne . then aspwkpre{i}=aspwkpre{i-1};
end;
do i=2 to dim(sameaspwk);
 if samereguasp{i}=2 and sameaspwk{i}=. and sameaspwk{i-1}=0 then sameaspwkpre{i}=.;     
 if samereguasp{i}=1 and sameaspwk{i}=. and 0<sameaspwk{i-1} then sameaspwkpre{i}=.;   
end;


/*carry forward cumulative average of aspirin tabs/week one cycle*/
do i=dim(avaspwkpre) to 2 by -1;
 if avaspwkpre{i} eq . and avaspwkpre{i-1} ne . then avaspwkpre{i}=avaspwkpre{i-1};
end;

/*carry forward regular use of aspirin one cycle*/
do i=1 to dim(reguasp);
 regaspre{i}=reguasp{i};
end;

do i=dim(regaspre) to 2 by -1;
 if regaspre{i} eq . and regaspre{i-1} ne . then regaspre{i}=regaspre{i-1};
end;
do i=2 to dim(sameaspwk);
 if samereguasp{i}=. and sameaspwk{i}=0 and samereguasp{i-1}=2 then sameregaspre{i}=.;   
end;

/*impute missing aspirin by carrying forward all the cycle if missing 
to calculate immedeately before or immedeately after diagnosis aspirin.*/
/*intake tabs/week*/
do i=1 to dim(aspwk);
 aspwkcarry{i}=aspwk{i};
end;
do i=2 to dim(aspwkcarry);
 if aspwkcarry{i} eq . and aspwkcarry{i-1} ne . then aspwkcarry{i}=aspwkcarry{i-1};
end;

/*cumulative average of intake tabs/week*/
do i=1 to dim(avaspwkpre);
 avaspwkcarry{i}=avaspwkpre{i};
end;
do i=2 to dim(avaspwkcarry);
 if avaspwkcarry{i} eq . and avaspwkcarry{i-1} ne . then avaspwkcarry{i}=avaspwkcarry{i-1};
end;

/*regular use*/
do i=1 to dim(reguasp);
 regascarry{i}=reguasp{i};
end;
do i=2 to dim(regascarry);
 if regascarry{i} eq . and regascarry{i-1} ne . then regascarry{i}=regascarry{i-1};
end;

/*Postdiagnosis*/
/*impute missing aspirin by carrying backward all the cycle if missing
to calculate immedeately after diagnosis aspirin tabs/week*/
/*intake tabs/week*/
do i=1 to dim(aspwk);
 aspwkpost{i}=aspwk{i};
end;

do i=dim(aspwkpost)-1 to 1 by -1;
 if aspwkpost{i} ne . then aspwkpost{i}=aspwkpost{i};
 else if aspwkpost{i} eq . and aspwkpost{i+1} ne . then aspwkpost{i}=aspwkpost{i+1};
end;

/*regular use of aspirin*/
do i=1 to dim(reguasp);
 regaspost{i}=reguasp{i};
end;

do i=dim(regaspost)-1 to 1 by -1;
 if regaspost{i} ne . then regaspost{i}=regaspost{i};
 else if regaspost{i} eq . and regaspost{i+1} ne . then regaspost{i}=regaspost{i+1};
end;

/*duration of regular aspirin use*/
/*1986*/
if aspi86>=2 then  do;
 adur8688=4; /*assume that the 1986 users have been using for at least 2 years at baseline*/     
end; 
else if .<aspi86<2 then do; 
 adur8688=0; 
end; 
else if aspi86=. then do; 
adur8688=.; 
end;

/*1988-2010, if aspirin was regularly used, 2 years were added as the duration in the period*/
do i=2 to dim(adur);
 if reguasp{i}>=2 then adur{i}=2;  
 else if .<reguasp{i}<2 then adur{i}=0;  
 else if reguasp{i}=. then adur{i}=.; 
end;

/*fills in missing duration with prior questionnaire response*/    
do i=2 to dim(adurarray);
 if adurarray{i}=. then adurarray{i}=adurarray{i-1};
 else;
end;

regaspdur86=sum(adur8688);
regaspdur88=sum(adur8688,adur8890);
regaspdur90=sum(adur8688,adur8890,adur9092);
regaspdur92=sum(adur8688,adur8890,adur9092,adur9294);
regaspdur94=sum(adur8688,adur8890,adur9092,adur9294,adur9496); 
regaspdur96=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698);
regaspdur98=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800);
regaspdur00=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002);
regaspdur02=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204);
regaspdur04=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406);
regaspdur06=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608);
regaspdur08=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810);
regaspdur10=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012);
regaspdur12=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214);
regaspdur14=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214,adur1416);

*****NSAIDs*****;
/*Prediagnosis, Carry forward all the cycle*/
/*any use of ibu*/
do i=1 to dim(anyibucarry);
anyibucarry{i}=anyibu{i};
end;
do i = 2 to dim(anyibucarry);  
if anyibucarry{i} in (.) then anyibucarry{i} = anyibucarry{i-1}; 
end;

/*Postdiagnosis, impute missing ibu by carrying backward all the cycle if missing
to calculate immedeately after diagnosis ibu tabs/week*/
/*any use of ibu*/
do i=1 to dim(anyibupost);
   anyibupost{i}=anyibu{i};
end;
do i=dim(anyibupost)-1 to 1 by -1;
 if anyibupost{i} ne . then anyibupost{i}=anyibupost{i};
 else if anyibupost{i} eq . and anyibupost{i+1} ne . then anyibupost{i}=anyibupost{i+1};
end;

run;

proc sort nodupkey; by id; run;

proc datasets nolist;
delete hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14;
run;


/**  Reading in HPFS colorectal CA disease file.  This is done   **/
/**  because many variables of interest are not loaded into the  **/
/**  tissue tracking programs.                                   **/
data hp_colc1;
infile hp_colc1;
input
id 1-6 /* id number for HPFS*/
colorect 7 /* all colorectal cancer-conf 11-19*/
colon 8 /* colon cancer, MOSTLY CONF=11, BUT NOT ALL*/
rectum 9 /* rectal cancer, MOSTLY CONF=11, BUT NOT ALL */
prox 10 /* proximal cancer, MOSTLY CONF=11, BUT NOT ALL */
distal 11 /* distal cancer, MOSTLY CONF=11, BUT NOT ALL */
distcr 12 /* distal and or rectum, MOSTLY CONF=11, BUT NOT ALL */
dateca 13-16 /* date of dx in NHS mo-yr format*/
coldirt 17 /*colon cancer including those without site info conf 11-19*/
dead 18 /* died of CRC either primary or secondary cause of death*/
advanced 19 /* old staging: died of CRC or lymphnode and or distant mets*/
mets 20 /* old staging: lympnode and or distant mets*/
ab 21 /* old staging: early stage, see coding sheet state 1 or 2*/
conf 22-24 /* confirmation codes medical records if dx through dx follow up*/
dconf 25-27 /* confirmation code death file if dx through death file, primary cause*/
celltype 28-29 /* Celltype 
        10    Epithelial (unspecified)
		11    Adenocarcinoma
		12    Mucinous Adenocarcinoma
		13    Signet-ring Cell
		14    Adeno-Squamous
		15    Undifferentiated*/
grade 30      /* Histological Grade
		1       Well Differentiated
		2       Grade 2 Moderately Diff..
		3       Grade 3 Poorly Diff..
		4       Unspecified*/
other_cond 31 /* OTHER CONDITIONS
		0        None
		1        Chronic Ulcerative Colitis
		2        Chron s granulomatous Colitis
		3        Unspecified Inflammatory Bowel Disease
		4        Familial Polyposis Syndromes*/
tstage 32 /* EXTENT OF DISEASE THROUGH BOWEL WALL
	 	1	T1 - invades submucosa

		2	 T2 - invades muscularis
		3	T3 -  invades through muscularis into subserosa
		4	T4 - invades other organs structures, perforation
		5	Tis - carcinoma in situ, invasion of lamina propria
		6	Tx  - unknown*/
nstage  33 /* NUMBER OF LYMPH NODES INVOLVED
		1	N0 - no regional lymph nodes metastases
		2	N1 - metastases in 1 - 3 regional lymph nodes
		3	N2 - metastases in 4 or more regional lymph nodes
		4	Positive lymph nodes - number unknown
		5	Nx - unknown status*/   
mstage 34 /* DISTANT METASTASES
		1	M0 - no distant metastases known
		2	M1 - distant metastases*/
mwork 35/* METASTIC WORKUP
		1	Distant metastases present
		2	Complete negative workup*
		3	Incomplete workup/chest unknown
		4	Incomplete workup/abdomen unknown
		5	No metastatic work-up reported*/
/* TNM Stage Grouping I-IV, 1=yes, else missing, see below*/ 
/* TNM stage grouping:*/ 
/*Stage IV any T, any N, M1*/
/*Stage III any T, N1,N2, M0, also includes our NHS code tstage=4 which is number of lymphnodes unknown*/
/*Stage II T3, N0, M0 or T4, N0, M0*/
/*Stage I T1, N0, M0 or T2, N0, M0*/
TNM_1 36 
TNM_2 37
TNM_3 38
TNM_4 39 
overlap_conf 40 /* diagnosed in both disease and death primary cause fu 1=yes*/
finalstage 41 /*  TNM_1   finalstage = 1
	      	      TNM_2   finalstage = 2
		          TNM_3   finalstage = 3
		          TNM_4   finalstage = 4*/
dconfs 42-43 /* confirmed as secondary cause of death, conf code*/
overlap_confs 44 /*diagnosed in disease and death secondary cause fu 1=yes*/
sitehp 45-46  /* subcode 5 and 6 */
    /* 39  COLON
	       30  hepatic flexure
	       31  transverse colon
	       32  descending colon (left)
	       33  sigmoid colon (flexure)
	       34  cecum  (ileocecal valve)
	       35  appendix
	       36  ascending colon (right)
	       37  splenic flexure
	       38  other
    	49  RECTUM
	       40  rectosigmoid junction
	       41  rectum
	       42  anal canal
	       43  anus, unspecified
	       48  other*/
crcother 47 /* confirmed colorectal cancer without information on site */
dukesstage    48 /* DUKES stage 
			1= spread to mucosa and muscle only
			2= preirectum or pericolic and lymph
			3= lymph node and /or  distant  metastasis
			4= unspecified
		*/
dukes_sub 49  /* 1=yes 0=no  substituted dukes into finalstage if finalstage is missing and dukes stage s 1 or 2 */; 

ydx=floor(dateca/12);

conf1119=colorect;
mdtdx=dateca;

proc sort data=hp_colc1; by id; run;

/*************Reading physical activity data*******************/
%hp10; proc sort; by id; run;

data hp10;                                         /*change from hp06 to hp10*/
set hp10;
keep id ser10;
run;

data hp_mets;
        infile hp_mets lrecl=1000 recfm = d;
        input 	id 1-6
        	act86 7-11
        	act88 57-61
        	act90 112-116
        	act92 172-176
        	act94 232-236
        	act96 292-296
        	act98 352-356
        	act00 412-416
        	act02 472-476
        	act04 532-536
            act06 597-601
			act08  662-666
            act10  727-731
            act12  802-806
            act14  877-881;
        	
        if act86 ge 998 then act86 = .;
        if act88 ge 998 then act88 = .;
        if act90 ge 998 then act90 = .;
        if act92 ge 998 then act92 = .;
        if act94 ge 998 then act94 = .;
        if act96 ge 998 then act96 = .;
        if act98 ge 998 then act98 = .;
        if act00 ge 998 then act00 = .;
        if act02 ge 998 then act02 = .;
        if act04 ge 998 then act04 = .;
		if act06 ge 998 then act06 = .;
		if act08 ge 998 then act08 = .;
		if act10 ge 998 then act10 = .;
		if act12 ge 998 then act12 = .;
		if act14 ge 998 then act14 = .;
        
proc sort nodupkey data=hp_mets;by id;run;

/****************************************************************/
/** Reading in HPFS derived data.                              **/
/****************************************************************/
%hp_der (drop=cd); proc sort; by id; run;

data derived;
set hp_der;
irt86=rtmnyr86;
irt88=rtmnyr88;
irt90=rtmnyr90;
irt92=rtmnyr92;
irt94=rtmnyr94;
irt96=rtmnyr96;
irt98=rtmnyr98;
irt00=rtmnyr00;
irt02=rtmnyr02;
irt04=rtmnyr04;
irt06=rtmnyr06;
ht86=height;
age86x=age86;
keep id irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06
        wt86 wt88 wt90 wt92 wt94 wt96 wt98 wt00 wt02 wt04 wt06
        smoke86 smoke88 smoke90 smoke92 smoke94 smoke96 smoke98 smoke00 smoke02 smoke04 smoke06
		pckyr86 pckyr88 pckyr90 pckyr92 pckyr94 pckyr96 pckyr98 pckyr00 pckyr02 pckyr04 pckyr06
        ht86 age86x dbmy86 dbmy09;
proc sort nodupkey; by id; run;

%hp_der_2 (drop=cd); proc sort nodupkey; by id; run;

data derived2;
set hp_der_2 ;
irt08=rtmnyr08;
irt10=rtmnyr10;
irt12=rtmnyr12;
irt14=rtmnyr14;
keep id irt08 irt10 irt12 irt14 wt08 wt10 wt12 wt14 smoke08 smoke10 smoke12 smoke14 pckyr08 pckyr10 pckyr12 pckyr14;
proc sort nodupkey; by id; run; 

/****************************************************************/
/** Reading in HPFS death data file.                           **/
/****************************************************************/
%hp_dead (drop=icda cd dtdth conf dtdx);
if mmdth<1 or mmdth>12 then mmdth=6; else; 
	 if 0=<yydth<50 then yydth=yydth+100;
     if yydth>0 then dtdth=yydth*12 + mmdth;
else                 dtdth=.;


deadmonth=dtdth;
dicda=icda;

if dthconf in(.,3,4) then delete; /** NOT SURE IF IT'S CORRECT TO DO THIS **/
run;

proc sort nodupkey; by id; run;

/* proc print data=hp_dead; var id mmdth yydth deadmonth dicda incicda; run; */
/* HPFS FH codes 1 */
/** Bringing in the HPFS family history data.  **/
/*In 1994, 1998, 2000, 2002, 2004, 2006 and 2010, participants were asked about family history of colorecta cancer directly**/
/* family history of colorectal cancer in first relative are unavailable */
*%hp_der (keep=id  mclc86  fclc86, noformat=t); /*hp_der is read above*/
%hp90(keep=id mclc90 fclc90 sclc90, noformat=t); run;
%hp92(keep=id mclc92 fclc92 sclc92, noformat=t); run;
%hp96(keep=id pclc96 pclcd96 sclc196 scl1d96 sclc296 scl2d96 noclc96, noformat=t); run;
%hp08(keep=id sclc108 sclc208, noformat=t); run;

data hpfamily;
merge hp_der (in=fam86) hp90 hp92 hp96 hp08;
by id;
if fam86 then base_famhx = 1;


***FH 86***;
   cafam86=0;
   if fclc86=1 or mclc86=1 then cafam86=1;

   cafam286=0;
        if sum(fclc86, mclc86)=1 then cafam286=1;
   else if sum(fclc86, mclc86)=2 then cafam286=2;

***FH 90***;
   cafam90=0;
   if fclc90=1 or mclc90=1 or sclc90=1 or cafam86=1 then cafam90=1;

   cafam290=0;
     if sum(fclc90, mclc90, sclc90)>1 or cafam286=2 then cafam290=2;
else if sum(fclc90, mclc90, sclc90)=1 or cafam286=1 then cafam290=1;

***FH 92***;
   cafam92=0;
   if fclc92=1 or mclc92=1 or sclc92=1 or cafam90=1 then cafam92=1;

   cafam292=0;
     if sum(fclc92, mclc92, sclc92)>1 or cafam290=2 then cafam292=2;
else if sum(fclc92, mclc92, sclc92)=1 or cafam290=1 then cafam292=1;

***FH 96***;
   cafam96=0;
   if pclc96=1 or sclc196=1 or sclc296=1 or cafam92=1 then cafam96=1;

   cafam296=0;
     if sclc296=1 or sum(pclc96, sclc196)=2 or cafam292=2 then cafam296=2;
else if sum(pclc96, sclc196)=1 or cafam292=1 then cafam296=1;

***FH 08***;
   cafam08=0;
   if sclc108=1 or sclc208=1 or cafam96=1 then cafam08=1;

   cafam208=0;
      if sclc208=1 or cafam296=2 then cafam208=2;
 else if sclc108=1 or cafam296=1 then cafam208=1;
run;
proc datasets nolist;
   delete hp90 hp92 hp96 hp08;
run;

proc sort nodupkey; by id; run;

/* HPFS FH codes 1 end*/

/****************/
/* Read Alcohol */
/****************/
%h86_nts(keep=alco86n);
%h90_nts(keep=alco90n);
%h94_nts(keep=alco94n);
%h98_nts(keep=alco98n);
%h02_nts(keep=alco02n);
%h06_nts(keep=alco06n);
%h10_nts(keep=alco10n);
%h14_nts(keep=alco14n);

data hpalcohol;
merge h86_nts h90_nts h94_nts h98_nts h02_nts h06_nts h10_nts h14_nts;
by id;
proc datasets nolist;
delete h86_nts h90_nts h94_nts h98_nts h02_nts h06_nts h10_nts h14_nts;
run;
proc sort nodupkey; by id; run;

/************************/
/* Read Vitamin D score */
/************************/
data hpvtdscore;
infile "/proj/hpchds/hpchd0y/Ed/VitD_predictor/VitD_predictor_score_032012.dat";
input id vdp86 vdp88 vdp90 vdp92 vdp94 vdp96 vdp98 vdp00 vdp02 vdp04 vdp06 vdp08;
run;
proc sort nodupkey data=hpvtdscore; by id; run;

data hpvtdscore;
 set hpvtdscore;
array raw[*] vdp86 vdp88 vdp90 vdp92 vdp94 vdp96 vdp98 vdp00 vdp02 vdp04 vdp06 vdp08;
array avg[*] vdp86a vdp88a vdp90a vdp92a vdp94a vdp96a vdp98a vdp00a vdp02a vdp04a vdp06a vdp08a;
sumvar=0; n=0;
do j=1 to dim(raw);
   avg{j}=raw{j};
   if (raw{j} ne .) then do;
      n=n+1;
      sumvar=sumvar+raw{j};
   end;
   if n=0 then avg{j}=raw{j};
   else avg{j}=sumvar/n;
end;
run;

proc sort nodupkey; by id; run;

/*****************************************************/
/*            Read in endoscopy data                */
/****************************************************/
data dhp_der;
merge derived derived2;
by id;

/* Setting  irt */
array irtset{*} irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14;
/* If participant did not return questionnaire, or irtXX date is before */
/* Jan of that questionnaire year, or is after or equal to Jan of the */
/* next questionniare year, then it is incorrect, and the return date   */
/* should  be set to the mailing date (Jan of that years).             */
do i=1 to DIM(irtset);         /*DIM returns the number of elements in that array*/
if irtset{i}<1009+(24*i) or irtset{i}>=1033+(24*i) then irtset{i}=1009+(24*i);
end;

if irt88<1057 or irt88 in (.,0) then irt88=1057; /*1057 is Jan 1988*/
age88=(irt88-dbmy86)/12;
age90=(irt90-dbmy86)/12;
age92=(irt92-dbmy86)/12;
age94=(irt94-dbmy86)/12;
age96=(irt96-dbmy86)/12;
age98=(irt98-dbmy86)/12;
age00=(irt00-dbmy86)/12;
age02=(irt02-dbmy86)/12;
age04=(irt04-dbmy86)/12;
age06=(irt06-dbmy86)/12;
age08=(irt08-dbmy86)/12;
age10=(irt10-dbmy86)/12;
age12=(irt12-dbmy86)/12;
age14=(irt14-dbmy86)/12;

keep id age: irt: ;
run;

proc sort nodupkey; by id; run;


/******************************************************************/
/*                 Read CASE DATA FILE                            */
/******************************************************************/

data polyp;
infile '/proj/hppols/hppol0c/hpfs/periodbased/active/colpol_8610_per.dat' lrecl=1000;
input 
id        1-6	    /*HPFS ID number*/
poldtdth     7-10		/*date of death in months since 1900*/
poldtdx      11-14		/*date of diagnosis in months since 1900*/
;
run;

proc sort; by id; run;

proc sort nodupkey; by id;
run;


/********************************/
/*Read Colonoscopy/Sigmoidoscopy*/
/********************************/
/************************************************
1988
   sigsy88 Sigmoidoscopy - Symptoms 1.yes
   sigsc88 Sigmoidoscopy - Routine 1.yes
   sigx88 Sigmoidoscopy  1.no sigmoidoscopy
   sigpt88 Sigmoidoscopy - PASSTHRU  1.PASSTHRU
   colsy88 Colonoscopy - Symptoms  1.yes
   colsc88 Colonoscopy - Routine  1.yes
   colx88 Colonoscopy  1.no colonoscopy
   colpt88 Colonoscopy - PASSTHRU  1.PASSTHRU
   q25pt88 EXAMS PASSTHRU (L25) 1.PASSTHRU
1990
   sigm90 Colonoscopy or Sigmoidoscopy
    1.No colonoscopy;\
	2.Yes;\
	3.PASSTHRU
   sigm190 Date First Sig/Colonoscopy  
    1.Before 1986;\
	2.1986;\
	3.1987;\
	4.1988;\
	5.1989;\
	6.1990 or later;\
	7.PASSTHRU
   sigmr90 Most recent Sig/Colonoscopy
	1.Before 1986;\
	2.1986;\
	3.1987;\
	4.1988;\
	5.1989;\
	6.1990 or later;\
	7.PASSTHRU
1992
   sigm92 Have you ever had Colonoscopy or Sigmoidoscopy?
    1.No colonoscopy;\
	2.Yes;\
	3.PASSTHRU
   sig9092 Colon/sigmoid. since 1990 
	1.No clx 90+;\
	2.Yes;\
	3.PASSTHRU
1994
   sigm94 Colonoscopy or Sigmoidoscopy 
	1.No colonoscopy;\
	2.Yes;\
	3.PASSTHRU
1996
   sig9496  Colonoscopy/Sigmoidoscopy 1994+(L14 S4)
        1.No colonoscopy;\
        2.Yes;\
        3.PASSTHRU
1998,2000
   sigm98 Colonoscopy or Sigmoidoscopy
        1. No colonoscopy;\
        2. Yes;\
        3. PASSTHRU
2002
   sigmd02 Colonoscopy or Sigmoidoscopy
        1. No colonoscopy;\
        2. Yes;\
        3. PASSTHRU
2004,2006,2008,2010
   colsc04 Colonoscopy (L8)
	1.No colonoscopy;\
	2.Yes;\
	3.PASSTHRU
   sigmd04	Sigmoidoscopy (L8)
	1.No sigmoidoscopy;\
	2.Yes;\
	3.PASSTHRU
2004-2008
   sighx04 Sigmoidoscopy (L30)
   sig8604 Sigmoidoscopy, before 1986(L30)
   sig8704 Sigmoidoscopy, 1986-87 (L30)
   sig8904 Sigmoidoscopy, 1988-89 (L30)	
   sig9104 Sigmoidoscopy, 1990-91 (L30)	
   sig9304 Sigmoidoscopy, 1992-93 (L30)
   sig9504 Sigmoidoscopy, 1994-95 (L30)
   sig9704 Sigmoidoscopy, 1996-97 (L30)
   sig9904 Sigmoidoscopy, 1998-99 (L30)
   sig0104 Sigmoidoscopy, 2000-01 (L30)
   sig0204 Sigmoidoscopy, 2002 (L30)
   sig0304 Sigmoidoscopy, 2003 (L30)
   sig0404 Sigmoidoscopy, 2004 (L30)
   sigpt04 Sigmoidoscopy, Passthru (L30)

   illpt04 Illness/proc., ever - PTB (L30) 1. Passthru
   (includes all questions in Q30 were not filled (Shingles, Seizure, Hearing loss...)
************************************************/
/********************************************************************
Reasons
1990,1992,1994,1996,2002
vbld90 Bleeding in Stool  1=yes
hxclc90 Family History-Colon Cancer  1=yes
fecal90 Pos. Test-Occult Fecal Blood  1=yes
abdpn90 Abdominal Pain  1=yes
diarr90 Diarrhea or Constipation  1=yes
rout90 Routine Screening 1=yes

1998,2000 (name "diar" is different)
vbld98 Bleeding in Stool  1=yes
hxclc98 Family History-Colon Cancer  1=yes
fecal98 Pos. Test-Occult Fecal Blood  1=yes
abdpn98 Abdominal Pain  1=yes
diar98 Diarrhea or Constipation  1=yes
rout98 Routine Screening 1=yes

2004,2006,2008,2010
vbld04 Bleeding in Stool  1=yes
hxclc04 Family History-Colon Cancer  1=yes
fecal04 Pos. Test-Occult Fecal Blood  1=yes
abdpn04 Abdominal Pain  1=yes
diarr04 Diarrhea or Constipation  1=yes
rout04 Routine Screening 1=yes
virt04 Virtual (CT) colongraphy (L8a) 1. Yes
cpolp04 Prior polyps (L8a) 1. Yes
bari04 Barium enema (L8a) 1. Yes
scopt04 Reason for sig/colonoscopy, PT (L8a) 1. Passthru
********************************************************************/
/*Long vs. short Qx
flag88--flag06   1.long quest. 2.short quest.
endo was asked from 1996- in short qx*/
%hp88(keep=flag88 sigsy88 sigsc88 sigx88 sigpt88 colsy88 colsc88 colx88 colpt88 q25pt88, noformat=t);
%hp90(keep=flag90 sigm90 sigm190 sigmr90 vbld90 fecal90 abdpn90 diarr90 hxclc90 rout90 q13bp90, noformat=t); /*Channing format seems wrong*/
%hp92(keep=flag92 sigm92 sig9092 vbld92 fecal92 abdpn92 diarr92 hxclc92 rout92 q13bp92, noformat=t); 
%hp94(keep=flag94 sigm94 vbld94 fecal94 abdpn94 diarr94 hxclc94 rout94 q9apt94, noformat=t);
%hp96(keep=flag96 sig9496 vbld96 fecal96 abdpn96 diarr96 hxclc96 rout96 q15pt96, noformat=t);
%hp98(keep=flag98 sigm98 vbld98 fecal98 abdpn98 diar98 hxclc98 rout98 sigmp98, noformat=t);
%hp00(keep=flag00 sigm00 vbld00 fecal00 abdpn00 diar00 hxclc00 rout00 sigmp00, noformat=t);
%hp02(keep=flag02 sigmd02 vbld02 fecal02 abdpn02 diarr02 hxclc02 rout02 scopt02, noformat=t);
%hp04(keep=flag04 illpt04 sigmd04 colsc04 scopt04 vbld04 hxclc04 virt04 fecal04 cpolp04 bari04 diarr04 abdpn04 rout04
           sighx04 sig8604 sig8704 sig8904 sig9104 sig9304 sig9504 sig9704 sig9904 sig0104 sig0204 sig0304 sig0404 sigpt04
           colhx04 col8604 col8704 col8904 col9104 col9304 col9504 col9704 col9904 col0104 col0204 col0304 col0404 colpt04, noformat=t);
%hp06(keep=flag06 id colsc06 sigmd06 vbld06 hxclc06 virt06 cpol06 fecal06 diarr06 cpolp06 abdpn06 bari06 rout06, noformat=t);
%hp08(keep=flag08 id colsc08 sigmd08 vbld08 hxclc08 virt08 cpol08 fecal08 diarr08 cpolp08 abdpn08 bari08 rout08, noformat=t);
%hp10(keep=flag10 id colsc10 sigmd10 vbld10 hxclc10 virt10 cpol10 fecal10 diarr10 cpolp10 abdpn10 bari10 rout10, noformat=t);
%hp12(keep=flag12 id colsc12 sigmd12 vbld12 hxclc12 virt12 cpol12 fecal12 diarr12 cpolp12 abdpn12 bari12 rout12, noformat=t);
%hp14(keep=flag14 id colsc14 sigmd14 vbld14 hxclc14 ctcol14 cpol14 fecal14 diarr14 cpolp14 abdpn14  rout14, noformat=t);

data hpsigmo;
 merge hp88 (in=xhp88) hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 (in=xhp04) hp06 hp08 hp10 hp12 hp14
       polyp hp_colc1 dhp_der derived2 hp_dead;
 by id;
 inhp88=xhp88;
 inhp04=xhp88;

endo86=.; endo88=.; endo90=.; endo92=.; endo94=.; endo96=.; 
endo98=.; endo00=.; endo02=.; endo04=.; endo06=.; endo08=.; endo10=.;
endo12=.; endo14=.;


/*Long (or with endo question)*/
if flag88=1 then longq88=1; else longq88=0;
if flag90=1 then longq90=1; else longq90=0;
if flag92=1 then longq92=1; else longq92=0;
if flag94=1 then longq94=1; else longq94=0;
if flag96 in (1,2) then longq96=1; else longq96=0;  /*endo was asked from 1996- in short qx*/
if flag98 in (1,2)  then longq98=1; else longq98=0;
if flag00 in (1,2)  then longq00=1; else longq00=0;
if flag02 in (1,2)  then longq02=1; else longq02=0;
if flag04 in (1,2)  then longq04=1; else longq04=0;
if flag06 in (1,2)  then longq06=1; else longq06=0;
if flag08 in (1,2)  then longq08=1; else longq08=0;
if flag10 in (1,2)  then longq10=1; else longq10=0;
if flag12 in (1,2)  then longq12=1; else longq12=0;
if flag14 in (1,2)  then longq14=1; else longq14=0;

*who answered short qx but returned to long qx in the next cycle*;
array longqar[*] longq88 longq90 longq92 longq94 longq96 
                 longq98 longq00 longq02 longq04 longq06 longq08 longq10 longq12 longq14;
array relong[*] relong88 relong90 relong92 relong94 relong96 
                relong98 relong00 relong02 relong04 relong06 relong08 relong10 relong12 relong14;
do i=2 to dim (longqar);
   if longqar[i-1] ne 1 and longqar[i] eq 1 then relong[i]=1; else relong[i]=0;
end;


/**********
 endoscopy
**********/
if sigx88=1 or colx88=1 then endo88=1;
else if sigsy88=1 or sigsc88=1 or colsy88=1 or colsc88=1 then endo88=2; /*endo yes*/

if sigm90=1 then endo90=1; /*endo no*/
else if sigm90=2 then endo90=2; /*endo yes*/

if sig9092=1 then endo92=1; /*endo no*/
else if sig9092=2 then endo92=2; /*endo yes*/
else if sigm92=1 then endo92=1; 

if sigm94=1 then endo94=1; /*endo no*/
else if sigm94=2 then endo94=2; /*endo yes*/

if sig9496=1 then endo96=1;
else if sig9496=2 then endo96=2;

if sigm98=1 then endo98=1;
else if sigm98=2 then endo98=2;

if sigm00=1 then endo00=1;
else if sigm00=2 then endo00=2;

if sigmd02=1 then endo02=1;
else if sigmd02=2 then endo02=2;

if colsc04=2 or col0204=1 or col0304=1 or sigmd04=2 or sig0204=1 or sig0304=1 then endo04=2; /*endo yes*/
else if colsc04=1 or sigmd04=1 then endo04=1; /*endo no*/

if colsc06=2 or  sigmd06=2 then endo06=2; /*endo yes*/
else if colsc06=1 or  sigmd06=1 then endo06=1; /*endo no*/

if colsc08=2 or  sigmd08=2 then endo08=2; /*endo yes*/
else if colsc08=1 or  sigmd08=1 then endo08=1; /*endo no*/

if colsc10=2 or  sigmd10=2 then endo10=2; /*endo yes*/
else if colsc10=1 or  sigmd10=1 then endo10=1; /*endo no*/

if colsc12=2 or  sigmd12=2 then endo12=2; /*endo yes*/
else if colsc12=1 or  sigmd12=1 then endo12=1; /*endo no*/

if colsc14=2 or  sigmd14=2 then endo14=2; /*endo yes*/
else if colsc14=1 or  sigmd14=1 then endo14=1; /*endo no*/

*-----------*
 Use 1990 Qx
*-----------*;
/*endo86 indicate experience of endoscopy before 1986 (1=BEFORE 1986)*/
if sigm190 in (1) or sigmr90 in (1) then endo86=2;
else if (sigm190 in (2,3,4,5,6)) then endo86=1; /*endo no*/

/*endo88-endo90 were missing, 1990 info was used to fill the answer.
 We don't impute endo88 if endo90=yes becase person shouldn't take
 endoscopy twice within 4 years. Same for endo90*/

if ((endo90 ne 2) and (sigm190 in (2,3) or sigmr90 in (2,3)) and endo88=. ) 
   then endo88=2; /*yes endo*/
else if (endo88=. and sigm190 in (4,5,6)) then endo88=1; /*when first sigmo is later than 1988, endo88 should be no*/

if ((endo88 ne 2) and (sigm190 in (4,5,6) or sigmr90 in (4,5,6)) and endo90=. ) 
   then endo90=2;
else if (endo90=. and sigm190 in (2,3)) then endo90=1; /*she won't take endo twice within 5 years*/
else if (endo90=. and sigmr90 in (1,2,3)) then endo90=1; /*if most recent endo in 86 or 87, she won't take in 88, 89*/

*-----------*
 Use 2004 Qx
*-----------*;
/*For only missing variables of the past Qx, we use 2004 info*/
/*We don't impute endo[i] if person already endo[i-1]=yes or endo[i+1]=yes*/
/*never*/
/*pass through means "he never took" because there's no "never" option in 2004 Qx in HPFS*/
if endo86=2 or endo88=2 or endo90=2 or endo92=2 or endo94=2 or 
   endo96=2 or endo98=2 or endo00=2 or endo02=2 or endo04=2 
   then atleast=1; /*yes edo at least once in some year. They cannot be "Never endo"*/


/*we fill from the latest information*/
/*04 can fill endo04 as we assume they took endo in the midepoint between qxs
  (i.e., midpoint between 04qx and 06qx is June 05. Thus, endo in 04 is included in 04qx cycle*/
if (endo04 ne 1 and (sig0404=1 or col0404=1))
   then endo04=2; /*yes*/                            /*illpt04=1 is all path through*/

/*03 endo can fill endo04*/
if (endo02 ne 2 and endo06 ne 2 and endo04=. and (sig0304=1 or col0304=1))
   then endo04=2; /*yes*/
else if endo04=. and flag04 in (1,2) then endo04=1; /*participated endo q but no answer*/

/*02 endo can fill endo04*/
if (endo02 ne 2 and endo06 ne 2 and endo04=. and (sig0204=1 or col0204=1))
   then endo04=2; /*yes*/
else if endo04=. and flag04 in (1,2) then endo04=1; /*participated endo q but no answer*/

/*2000-2001 endo can fill endo02*/
if (endo00 ne 2 and endo04 ne 2 and endo02=. and (sig0104=1 or col0104=1))
   then endo02=2; /*yes*/
else if endo02=. and flag04 in (1,2) then endo02=1; /*participated endo q but no answer*/

/*1998-1999 endo can fill endo00*/
if (endo98 ne 2 and endo02 ne 2 and endo00=. and (sig9904=1 or col9904=1))
   then endo00=2; /*yes*/
else if endo00=. and flag04 in (1,2) then endo00=1; /*participated endo q but no answer*/

/*1996-1997 endo can fill endo98*/
if (endo96 ne 2 and endo00 ne 2 and endo98=. and (sig9704=1 or col9704=1))
   then endo98=2; /*yes*/
else if endo98=. and flag04 in (1,2) then endo98=1; /*participated endo q but no answer*/

/*1994-1995 endo can fill endo96*/
if (endo94 ne 2 and endo98 ne 2 and endo96=. and (sig9504=1 or col9504=1))
   then endo96=2; /*yes*/
else if endo96=. and flag04 in (1,2) then endo96=1; /*participated endo q but no answer*/

/*92-93 endo can fill endo94*/
if (endo92 ne 2 and endo96 ne 2 and endo94=. and (sig9304=1 or col9304=1))
   then endo94=2; /*yes*/
else if endo94=. and flag04 in (1,2) then endo94=1; /*participated endo q but no answer*/

/*90-91 endo can fill endo92*/
if (endo90 ne 2 and endo94 ne 2 and endo92=. and (sig9104=1 or col9104=1))
   then endo92=2; /*yes*/
else if endo92=. and flag04 in (1,2) then endo92=1; /*participated endo q but no answer*/

/*88-89 endo can fill endo90*/
if (endo88 ne 2 and endo92 ne 2 and endo90=. and (sig8904=1 or col8904=1))
   then endo90=2; /*yes*/
else if endo90=. and flag04 in (1,2) then endo90=1; /*participated endo q but no answer*/

/*86-87 endo can fill endo88*/
if (endo90 ne 2 and endo88=. and (sig8704=1 or col8704=1))
   then endo88=2; /*yes*/
else if endo88=. and flag04 in (1,2) then endo88=1; /*participated endo q but no answer*/

/*before 1986, we fill endo86*/
if (endo86=. and (sig8604=1 or col8604=1)) 
   then endo86=2; /*yes*/                        /*illpt04=1 is all path through*/
else if endo86=. and flag04 in (1,2) then endo86=1; /*participated endo q but no answer*/


*****fill in if missing*******;
if endo88=. and flag88=1 then endo88=1; /*those who participated in long Qx endo no*/

if endo90=. and flag90=1 then endo90=1; /*those who participated in long Qx endo no*/

if endo92=. and flag92=1 then endo92=1; /*those who participated in long Qx endo no*/

if endo94=. and flag94=1 then endo94=1; /*those who participated in long Qx endo no*/

if endo96=. and flag96 in (1,2) then endo96=1; /*those who participated in long and short Qx endo no*/

if endo98=. and flag98 in (1,2) then endo98=1; /*those who participated in long and short Qx endo no*/

if endo00=. and flag00 in (1,2) then endo00=1; /*those who participated in long and short Qx endo no*/

if endo02=. and flag02 in (1,2) then endo02=1; /*those who participated in long and short Qx endo no*/

if endo04=. and flag04 in (1,2) then endo04=1; /*those who participated in long and short Qx endo no*/

if endo06=. and flag06 in (1,2) then endo06=1; /*those who participated in long and short Qx endo no*/

if endo08=. and flag08 in (1,2) then endo08=1; /*those who participated in long and short Qx endo no*/

if endo10=. and flag10 in (1,2) then endo10=1; /*those who participated in long and short Qx endo no*/

if endo12=. and flag12 in (1,2) then endo12=1; /*those who participated in long and short Qx endo no*/

if endo14=. and flag14 in (1,2) then endo14=1; /*those who participated in long and short Qx endo no*/

*-----------*
 Use 1990 Qx
*-----------*;
if endo86=. and flag90=1 then endo86=1; /*endo no*/

if endo88=. and flag90=1 then endo88=1; /*long qx*/

if endo90=. and flag90=1 then endo90=1; /*long qx*/




*--------------------------*
 Clean consecutive endoscopy
*--------------------------*;
/*If person reported endoscopy in the successive Qx cycle,
we assume endo in the second report was the same one already reported in the last Qx.*/
/*1988-2006*/
if endo88=2 then endo90=1;
if endo90=2 then endo92=1;
if endo92=2 then endo94=1;
if endo94=2 then endo96=1;
if endo96=2 then endo98=1;
if endo98=2 then endo00=1;
if endo00=2 then endo02=1;
if endo02=2 then endo04=1;
if endo04=2 then endo06=1;
if endo06=2 then endo08=1;
if endo08=2 then endo10=1;
if endo10=2 then endo12=1;
if endo12=2 then endo14=1;

*-------------------------------------------------------*
 After clean successive endoscopy,
 Endoscopy just before dtdx of polyp
*-------------------------------------------------------*;
/* For person who did not report endo but polyp was diagnosed.
 (We assume this was not for screening but for symptoms)*/
array arrendo [*] endo86 endo88 endo90 endo92 endo94 endo96 
                  endo98 endo00 endo02 endo04 endo06 endo08 endo10 endo12 endo14; /*period endoscopy, 1=no endo, 2=yes endo*/
array endos[*]    endos86 endos88 endos90 endos92 endos94 endos96 
                  endos98 endos00 endos02 endos04 endos06 endos08 endos10 endos12 endos14; /*period endoscopy, 0=no endo, 1=yes endo*/
array arirt [*]   irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14;
array hendo [*]   hendo86 hendo88 hendo90 hendo92 hendo94 hendo96 hendo98 hendo00 hendo02 hendo04 hendo06 hendo08 hendo10 hendo12 hendo14; /*hisotry of endoscopy, 0=no, 1=yes*/


/*when person diagnosed as adenoma (poldtdx exists) but they did not report endoscopy*/
do i=2 to dim(arirt);
   if (arirt[i-1]<=poldtdx<arirt[i] and arrendo[i] ne 2) then do;
      arrendo[i]=2; /*yes endo*/
   end;
end;

/*missing endoscopy status immediately after/before the Q-cycle with endoscopy 
will be no endoscopy as we assume people will not take endoscopy within 5 years*/
do i=2 to dim(arrendo);
   if arrendo[i]=. and arrendo[i-1]=2 then arrendo[i]=1; /*no endo*/
end;

do i=1 to dim(arrendo)-1;
   if arrendo[i]=. and arrendo[i+1]=2 then arrendo[i]=1; /*no endo*/
end;


*-------------------------------------*
 person who all miss endo status
*-------------------------------------*;

do i=1 to dim(arrendo);
   if arrendo[i]=1 then endos[i]=0; /*no endo*/
   else if arrendo[i]=2 then endos[i]=1; /*yes endo*/
end;

endosum=0;
do i=1 to dim(endos);
   endosum= sum (endosum,endos[i]); /*sum of endoscopy experience*/
end;

if endos86=. and endos88=. and endos90=. and endos92=. and endos94=. and endos96=. and
   endos98=. and endos00=. and endos02=. and endos04=. and endos06=. and endos08=. and endos10=. and endos12=. and endos14=. then
   endosum=.;  /*Note, sum function returns 0 if the value is missing*/

if endosum=0 then neverendo=1;


*----------------------------------------*
 history of endoscopy
*----------------------------------------*;
hendo86=endos86;
do i=2 to dim(hendo);
   if hendo[i-1]=. and endos[i]=. then hendo[i]=.;       /*missing*/
   else if hendo[i-1]=1 or endos[i]=1 then hendo[i]=1;   /*with history of endoscopy*/
   else hendo[i]=0;                                      /*no history of endoscopy*/
end;
run;


data hpsigmo;
 set hpsigmo;
keep
id poldtdx endo: endos: hendo: neverendo endosum;
run;

proc sort nodupkey; by id; run;

/* Appendectomy
app86: Appendectomy; yes=1
appd86: Year of appendectomy; 1=<1955, 2=1955-64, 3=1965-74, 4=1975-79, 5=1980+, 9=Passthrough */

%hp86 (keep=id app86 appd86, noformat=T);
/*data hpapp;
set hp86;
run;

proc print data=hpapp;
var id app86 appd86;
run;

proc univariate data=hpapp;
var id app86 appd86;
run; */

data hpapp;
set hp86;
hpapp55=0;
hpapp60=0;
hpapp70=0;
hpapp77=0;
hpapp83=0;
hpappthrough=0;
if app86=. then app86=0; /* missing=0 */
if appd86=. then appd86=0; /* missing=0 */
if appd86=1 then hpapp55=1; /* 1=<1955 */
if appd86=2 then hpapp60=1; /* 1=1955-64 */
if appd86=3 then hpapp70=1; /* 1=1965-74 */
if appd86=4 then hpapp77=1; /* 1=1975-79 */
if appd86=5 then hpapp80=1; /* 1=1980+ */
if appd86=9 then hpappthrough=1; /* 1=Passthrough */
run;

proc sort nodupkey data=hpapp;
by id;
run;

proc freq data=hpapp;
     tables app86 appd86; 
     run;

/*****************************************************/
/*            Read in tumor biomarkers               */
/****************************************************/

data hp_all_lab;
merge cimp_high (in=incimp) braf (in=inbraf)
msi (in=inmsi)     kras (in=inkras)  kras2 (in=inkras2)	fasn (in=infasn)	cox2all (in=incox2all)	p53 (in=inp53)
ctnnb1 (in=inctnnb1) line1 (in=inline)	path2 (in=inpath2)	p21 (in=inp21)	p27 (in=inp27)	p16 (in=inp16)
ccnd1 (in=inccnd1) ccnd1tma1314 (in=inccnd1tma1314)	pik3ca (in=inpik3ca) cdk8 (in=incdk8) cdk8ks (in=incdk8ks) 	sirt1 (in=insirt1) sirt1sub1 (in=insirt1sub1) sirt1sub2 (in=insirt1sub2) 
stmn (in=instmn) dnmt3b (in=indnmt3b) pparg (in=inpparg) rps6 (in=inrps6) 
p53new (in=inp53new) p53tma121 (in=inp53tma121) p53tma122 (in=inp53tma122) 
fasnnew (in=infasnnew) fasntma121 (in=infasntma121) fasntma122 (in=infasntma122) 
cox2new (in=incox2new) cox2tma121 (in=incox2tma121) cox2tma122 (in=incox2tma122) ptgs2newtma1314 (in=inptgs2newtma1314)
pakt (in=inpakt) paktTMA12sub1 (in=inpaktTMA12sub1) paktTMA12sub2 (in=inpaktTMA12sub2) pten (in=inpten)
CDH1TMA12sub1(in=inCDH1TMA12sub1)CDH1TMA12sub2(in=inCDH1TMA12sub2) CDH1(in=inCDH1) IGF2DMR0 ( in=inIGF2DMR0)
KDM1(in=inKDM1) KDM1TMA12sub1(in=inKDM1TMA12sub1) KDM1TMA12sub2(in=inKDM1TMA12sub2) 
STAT3TMA12sub1(in=inSTAT3TMA12sub1) STAT3TMA12sub2(in=inSTAT3TMA12sub2) stat3(in=instat3) cdx2 (in=incdx2)
PTGER2(in=inPTGER2) PTGER2TMA12sub1(in=inPTGER2TMA12sub1) PTGER2TMA12sub2(in=inPTGER2TMA12sub2) aurka (in=inaurka) 
HIF1A(in=inHIF1A) HIF1ATMA12sub1(in=inHIF1ATMA12sub1)HIF1ATMA12sub2(in=inHIF1ATMA12sub2)
EPAS1TMA12sub1(in=inEPAS1TMA12sub1)EPAS1TMA12sub2(in=inEPAS1TMA12sub2) EPAS1(in=inEPAS1)
prkaa (in=inprkaa) MAPK(in=inMAPK) PRKAATMA12sub1(in=inPRKAATMA12sub1)PRKAATMA12sub2(in=inPRKAATMA12sub2)
MAPKTMA12sub1(in=inMAPKTMA12sub1)MAPKTMA12sub2(in=inMAPKTMA12sub2)
CTSB(in=inCTSB) CTSBTMA12sub1(in=inCTSBTMA12sub1) CTSBTMA12sub2(in=inCTSBTMA12sub2) 
MLH1IHC(in=inMLH1IHC) MSH2IHC(in=inMSH2IHC) MGMTIHC(in=inMGMTIHC) cd3(in=incd3) cd8(in=incd8) 
cd45ro(in=incd45ro) foxp3(in=infoxp3) vdrnew (in=invdrnew) vdrtma121 (in=invdrtma121) vdrtma122 (in=invdrtma122) jcvt(in=injcvt)
ctnnb1TMnon12 (in=inctnnb1TMnon12) ctnnb1TM121 (in=inctnnb1TM121) ctnnb1TM122 (in=inctnnb1TM122) ctnnb1TMfullsec (in=inctnnb1TMfullsec) ctnnb1so(in=inctnnb1so) ctnnb1tma1314(in=inctnnb1tma1314)
irs1 (in=inirs1) yap1 (in=inyap1) igf2bp3 (in=inigf2bp3) irs2ale (in=inirs2ale) irs2 (in=inirs2)
mageanon12(in=inmageanon12) mageatma121(in=inmageatma121) mageatma122(in=inmageatma122) 
cmet(in=incmet) hpgd(in=inhpgd) vdrnovo(in=invdrnovo) cd274tma121 (in=incd274tma121) cd274tma122 (in=incd274tma122)
cd274non12 (in=incd274non12) cd274 (in=incd274) PDCD1LG2 (in=inPDCD1LG2) PDCD1LG2add (in=inPDCD1LG2add) PDCD1 (in=inPDCD1)
ctnnb1normal (in=inctnnb1normal) hgf (in=inhgf) smo (in=insmo) smotm (in=insmotm)
fuso (in=infuso) mir21155 (in=inmir21155) NFKB1 (in=inNFKB1) RELA (in=inRELA) CASR (in=inCASR) neoag (in=inneoag)
HS_LIBRARY_SIZE (in=inHS_LIBRARY_SIZE) Bifido (in=inBifido)
LC3AB (in=inLC3AB) beclin (in=inbeclin) p62 (in=inp62) tcellif (in=intcellif) tcellnew (in=intcellnew) fusonuc2 (in=infusonuc2) HEcell (in=inHEcell)
MF(in=inMF) MF_index(in=inMF_index) MF_M1M2(in=inMF_M1M2) HE_Gcross(in=inHE_Gcross) budding(in=inbudding) pks (in=inpks) 
Myeloid(in=inMyeloid) Myeloid_Gcross(in=inMyeloid_Gcross) PTGS2_HPGD(in=inPTGS2_HPGD) NK (in=inNK) NK_Gcross (in=inNK_Gcross) bft (in=inbft) 
vessel (in=invessel) ves_Gcross (in=inves_Gcross) cafmif (in=incafmif) cafGcross (in=incafGcross) stroma_epi_ratio (in=instroma_epi_ratio) drs (in=indrs);
by TumorID; if Cohort="H" and (incimp=1 OR inbraf=1 OR inmsi=1 OR inkras=1 OR inkras2=1 
OR infasn=1 or incox2all=1 or inp53=1 or inctnnb1=1 or inline=1 or inpath2=1 or insirt1=1 or insirt1sub1=1 or insirt1sub2=1
or inp21=1 or inp27=1 or inp16=1 or inccnd1=1 or inccnd1tma1314=1 or inpik3ca=1 or instmn=1 or indnmt3b=1 or incdk8=1 or incdk8ks=1
or inpparg=1 or inrps6=1 or inp53new=1 or inp53tma121=1 or inp53tma122=1 or infasnnew=1 
or infasntma121=1 or infasntma122=1 or incox2new=1 or incox2tma121=1 or incox2tma122=1 or inptgs2newtma1314=1 or inIGF2DMR0=1
or inpakt=1 or inpaktTMA12sub1=1 or inpaktTMA12sub2=1 or inpten=1 or inCDH1=1 or inCDH1TMA12sub1=1 or inCDH1TMA12sub2=1
or inKDM1=1 or inKDM1TMA12sub1=1 or inKDM1TMA12sub2=1
or inSTAT3TMA12sub1=1 or inSTAT3TMA12sub2=1 or instat3=1 or incdx2=1
or inPTGER2=1 or inPTGER2TMA12sub1=1 or inPTGER2TMA12sub2=1 or inaurka=1
or inHIF1A=1 or inEPAS1=1 or inHIF1ATMA12sub1=1 or inHIF1ATMA12sub2=1 or inEPAS1TMA12sub1=1 or inEPAS1TMA12sub2=1
or inPRKAATMA12sub1=1 or inPRKAATMA12sub2=1 or inMAPKTMA12sub1=1 or inMAPKTMA12sub2=1 or inMAPK=1 or inprkaa=1
or inCTSB=1 or inCTSBTMA12sub1=1 or inCTSBTMA12sub2=1 or inMLH1IHC=1 or inMSH2IHC or inMGMTIHC 
or incd3=1 or incd8=1 or incd45ro=1 or infoxp3=1 or injcvt=1 or invdrnew=1 
or invdrtma121=1 or invdrtma122=1 or inctnnb1TMnon12=1 or inctnnb1TM121=1  or inctnnb1TM122=1 
or inctnnb1TMfullsec=1 or inctnnb1so=1 or inctnnb1tma1314 or inirs1=1 or inyap1=1 or inigf2bp3=1 or inirs2ale=1 or inirs2=1 
 or inmageanon12=1 or inmageatma121=1 or inmageatma122=1 or incmet=1  or inhpgd=1 or invdrnovo=1
or incd274tma121=1 or incd274tma122=1 or incd274non12=1 or incd274=1 or inPDCD1LG2=1 or inPDCD1LG2add=1 or inPDCD1=1
or inctnnb1normal=1 or inhgf=1 or insmo=1 or insmotm=1 or infuso=1 or inmir21155=1 or inNFKB1=1 or inRELA=1 or inCASR=1 or inneoag=1
or inHS_LIBRARY_SIZE=1 or inBifido=1
or inLC3AB=1 or inbeclin=1 or inp62=1 or intcellif=1
or intcellnew=1 or infusonuc2=1 or inHEcell=1 or inMF=1 or inMF_index=1 or inMF_M1M2=1 or inHE_Gcross=1 or inbudding=1 or inpks=1 
or inMyeloid=1 or inMyeloid_Gcross=1 or inPTGS2_HPGD=1 or inNK=1 or inNK_Gcross=1 or inbft=1 or invessel=1 or inves_Gcross=1 or incafmif=1 or incafGcross=1 or indrs=1); 
/**  Using the IN=variables to flag observations from each  lab result file.  We create these variable at this 
point in the SAS program because the IN=variables are  temporary and would not be available after the merge. **/
if incimp=1 then cimp_rec=1; else cimp_rec=2;
*if inDifferentiation=1 then Differentiation_rec=1; *else Differentiation_rec=2;
if inmsi=1  then msi_rec=1;  else msi_rec=2;
if inbraf=1 then braf_rec=1; else braf_rec=2;
if inkras=1 then kras_rec=1; else kras_rec=2;
if inkras2=1 then kras2_rec=1; else kras2_rec=2;
if infasn=1 then fasn_rec=1; else fasn_rec=2;
if incox2all=1 then cox2_rec=1; else cox2_rec=2;
if inp53=1 then p53_rec=1; else p53_rec=2;
if inp53new =1 then p53new_rec =1; else p53new_rec =2; 
if inp53tma121=1 then p53tma121_rec=1; else p53tma121_rec=2; 
if inp53tma122=1 then p53tma122_rec=1; else p53tma122_rec=2; 
if infasnnew =1 then fasnnew_rec =1; else fasnnew_rec =2; 
if infasntma121=1 then fasntma121_rec=1; else fasntma121_rec=2; 
if infasntma122=1 then fasntma122_rec=1; else fasntma122_rec=2; 
if incox2new =1 then cox2new_rec =1; else cox2new_rec =2; 
if incox2tma121=1 then cox2tma121_rec=1; else cox2tma121_rec=2; 
if incox2tma122=1 then cox2tma122_rec=1; else cox2tma122_rec=2;
if inptgs2newtma1314=1 then ptgs2newtma1314_rec=1; else ptgs2newtma1314_rec=2; 
if inctnnb1=1 then ctnnb1_rec=1; else ctnnb1_rec=2; 
if inline=1 then line_rec=1; else line_rec=2;
if inpath2=1 then path2_rec=1; else path2_rec=2;
if inp21=1 then p21_rec=1; else p21_rec=2; 
if inp27=1 then p27_rec=1; else p27_rec=2; 
if inp16=1 then p16_rec=1; else p16_rec=2; 
if inccnd1=1 then ccnd1_rec=1; else ccnd1_rec=2;
if inccnd1tma1314=1 then ccnd1tma1314_rec=1; else ccnd1tma1314_rec=2;  
if inpik3ca=1 then pik3ca_rec=1; else pik3ca_rec=2; 
if indnmt3b=1 then dnmt3b_rec=1; else dnmt3b_rec=2;  
if incdk8=1 then cdk8_rec=1; else cdk8_rec=2; 
if incdk8ks=1 then cdk8ks_rec=1; else cdk8ks_rec=2; 
if insirt1=1 then sirt1_rec=1; else sirt1_rec=2; 
if insirt1sub1=1 then sirt1sub1_rec=1; else sirt1sub1_rec=2; 
if insirt1sub2=1 then sirt1sub2_rec=1; else sirt1sub2_rec=2; if instmn=1 then stmn_rec=1; else stmn_rec=2;
if inpparg=1 then pparg_rec=1; else pparg_rec=2; 
if inrps6=1 then rps6_rec=1; else rps6_rec=2; 
if inIGF2DMR0=1 then IGF2DMR0_rec=1; else IGF2DMR0_rec=2;
if inpakt=1 then pakt_rec=1; else pakt_rec=2; 
if inpaktTMA12sub1=1 then paktTMA12sub1_rec=1; else paktTMA12sub1_rec=2; 
if inpaktTMA12sub2=1 then paktTMA12sub2_rec=1; else paktTMA12sub2_rec=2;
if inpten=1 then pten_rec=1; else pten_rec=2;
if inCDH1TMA12sub1=1 then CDH1TMA12sub1_rec=1; else CDH1TMA12sub1_rec=2;
if inCDH1TMA12sub2=1 then CDH1TMA12sub2_rec=1; else CDH1TMA12sub2_rec=2;
if inCDH1=1 then CDH1_rec=1; else CDH1_rec=2;
if inKDM1=1 then KDM1_rec=1; else KDM1_rec=2;
if inKDM1TMA12sub1=1 then KDM1TMA12sub1_rec=1; else KDM1TMA12sub1_rec=2;
if inKDM1TMA12sub2=1 then KDM1TMA12sub2_rec=1; else KDM1TMA12sub2_rec=2;
if inSTAT3TMA12sub1=1 then STAT3TMA12sub1_rec=1; else STAT3TMA12sub1_rec=2;
if inSTAT3TMA12sub2=1 then STAT3TMA12sub2_rec=1; else STAT3TMA12sub2_rec=2;
if instat3=1 then pstat3_rec=1; else pstat3_rec=2;
if incdx2=1 then cdx2_rec=1; else cdx2_rec=2;
if inPTGER2=1 then PTGER2_rec=1; else PTGER2_rec=2;
if inPTGER2TMA12sub1=1 then PTGER2TMA12sub1_rec=1; else PTGER2TMA12sub1_rec=2;
if inPTGER2TMA12sub2=1 then PTGER2TMA12sub2_rec=1; else PTGER2TMA12sub2_rec=2;
if inaurka=1 then aurka_rec=1; else aurka_rec=2;
if inHIF1A=1 then HIF1A_rec=1; else HIF1A_rec=2;
if inEPAS1=1 then EPAS1_rec=1; else EPAS1_rec=2;
if inHIF1ATMA12sub1=1 then HIF1ATMA12sub1_rec=1; else HIF1ATMA12sub1_rec=2;
if inHIF1ATMA12sub2=1 then HIF1ATMA12sub2_rec=1; else HIF1ATMA12sub2_rec=2;
if inEPAS1TMA12sub1=1 then EPAS1TMA12sub1_rec=1; else EPAS1TMA12sub1_rec=2;
if inEPAS1TMA12sub2=1 then EPAS1TMA12sub2_rec=1; else EPAS1TMA12sub2_rec=2;
if inprkaa=1 then prkaa_rec=1; else prkaa_rec=2;
if inMAPK=1 then MAPK_rec=1; else MAPK_rec=2;
if inPRKAATMA12sub1=1 then PRKAATMA12sub1_rec=1; else PRKAATMA12sub1_rec=2;
if inPRKAATMA12sub2=1 then PRKAATMA12sub2_rec=1; else PRKAATMA12sub2_rec=2;
if inMAPKTMA12sub1=1 then MAPKTMA12sub1_rec=1; else MAPKTMA12sub1_rec=2;
if inMAPKTMA12sub2=1 then MAPKTMA12sub2_rec=1; else MAPKTMA12sub2_rec=2;
if inCTSB=1 then CTSB_rec=1; else CTSB_rec=2;
if inCTSBTMA12sub1=1 then CTSBTMA12sub1_rec=1; else CTSBTMA12sub1_rec=2;
if inCTSBTMA12sub2=1 then CTSBTMA12sub2_rec=1; else CTSBTMA12sub2_rec=2;
if inMLH1IHC=1 then MLH1IHC_rec=1; else MLH1IHC_rec=2;
if inMSH2IHC=1 then MSH2IHC_rec=1; else MSH2IHC_rec=2;
if inMGMTIHC=1 then MGMTIHC_rec=1; else MGMTIHC_rec=2;
if incd3=1 then cd3_rec=1; else cd3_rec=2; 
if incd8=1 then cd8_rec=1; else cd8_rec=2;
if incd45ro=1 then cd45ro_rec=1; else cd45ro_rec=2;
if infoxp3=1 then foxp3_rec=1; else foxp3_rec=2;
if injcvt=1 then jcvt_rec=1; else jcvt_rec=2;
if invdrnew =1 then vdrnew_rec =1; else vdrnew_rec =2; 
if invdrtma121=1 then vdrtma121_rec=1; else vdrtma121_rec=2; 
if invdrtma122=1 then vdrtma122_rec=1; else vdrtma122_rec=2;
if inctnnb1TMnon12=1 then ctnnb1TMnon12_rec=1; else ctnnb1TMnon12_rec=2;
if inctnnb1TM121=1 then ctnnb1TM121_rec=1; else ctnnb1TM121_rec=2;
if inctnnb1TM122=1 then ctnnb1TM122_rec=1; else ctnnb1TM122_rec=2;
if inctnnb1TMfullsec=1 then ctnnb1TMfullsec_rec=1; else ctnnb1TMfullsec_rec=2;
if inctnnb1so=1 then ctnnb1so_rec=1; else ctnnb1so_rec=2;
if inctnnb1tma1314=1 then ctnnb1tma1314_rec=1; else ctnnb1tma1314_rec=2;
if inirs1=1 then irs1_rec=1; else irs1_rec=2;
if inyap1=1 then yap1_rec=1; else yap1_rec=2;
if inigf2bp3=1 then igf2bp3_rec=1; else igf2bp3_rec=2;
if inirs2ale=1 then irs2ale_rec=1; else irs2ale_rec=2; 
if inirs2=1 then irs2_rec=1; else irs2_rec=2; 
if inmageanon12=1 then mageanon12_rec=1; else mageanon12_rec=2;
if inmageatma121=1 then mageatma121_rec=1; else mageatma121_rec=2;
if inmageatma122=1 then mageatma122_rec=1; else mageatma122_rec=2;
if incmet=1 then cmet_rec=1; else cmet_rec=2;
if inhpgd=1 then hpgd_rec=1; else hpgd_rec=2;
if invdrnovo=1 then vdrnovo_rec=1; else vdrnovo_rec=2;
if incd274tma121=1 then cd274tma121_rec=1; else cd274tma121_rec=2;
if incd274tma122=1 then cd274tma122_rec=1; else cd274tma122_rec=2;
if incd274non12=1 then cd274non12_rec=1; else cd274non12_rec=2;
if incd274=1 then cd274_rec=1; else cd274_rec=2;
if inPDCD1LG2=1 then PDCD1LG2_rec=1; else PDCD1LG2_rec=2;
if inPDCD1LG2add=1 then PDCD1LG2add_rec=1; else PDCD1LG2add_rec=2;
if inPDCD1=1 then PDCD1_rec=1; else PDCD1_rec=2;
if inctnnb1normal=1 then ctnnb1normal_rec=1; else ctnnb1normal_rec=2;
if inhgf=1 then hgf_rec=1; else hgf_rec=2;
if insmo=1 then smo_rec=1; else smo_rec=2;
if insmotm=1 then smotm_rec=1; else smotm_rec=2;
if infuso=1 then fuso_rec=1; else fuso_rec=2;
if inmir21155=1 then mir_rec=1; else mir_rec=2;
if inNFKB1=1 then NFKB1_rec=1; else NFKB1_rec=2;
if inRELA=1 then RELA_rec=1; else RELA_rec=2;
if inCASR=1 then CASR_rec=1; else CASR_rec=2;
if inneoag=1 then neoag_rec=1; else neoag_rec=2;
if inHS_LIBRARY_SIZE=1 then HS_LIBRARY_SIZE_rec=1; else HS_LIBRARY_SIZE_rec=2;
if inBifido=1 then Bifido_rec=1; else Bifido_rec=2;
if inLC3AB=1 then LC3AB_rec=1; else LC3AB_rec=2;
if inbeclin=1 then beclin_rec=1; else beclin_rec=2;
if inp62=1 then p62_rec=1; else p62_rec=2;
if intcellnew=1 then tcellnew_rec=1; else tcellnew_rec=2;
if intcellif=1 then tcellif_rec=1; else tcellif_rec=2;
if infusonuc2=1 then fusonuc2_rec=1; else fusonuc2_rec=2;
if inHEcell=1 then HEcell_rec=1; else HEcell_rec=2;
if inMF=1 then MF_rec=1; else MF_rec=2;
if inMF_index=1 then MF_index_rec=1; else MF_index_rec=2;
if inMF_M1M2=1 then MF_M1M2_rec=1; else MF_M1M2_rec=2;
if inHE_Gcross=1 then HE_Gcross_rec=1; else HE_Gcross_rec=2;
if inbudding=1 then budding_rec=1; else budding_rec=2;
if inMyeloid=1 then Myeloid_rec=1; else Myeloid_rec=2;
if inMyeloid_Gcross=1 then Myeloid_Gcross_rec=1; else Myeloid_Gcross_rec=2;
if inPTGS2_HPGD=1 then PTGS2_HPGD_rec=1; else PTGS2_HPGD_rec=2;
if inNK=1 then NK_rec=1; else NK_rec=2;
if inNK_Gcross=1 then NK_Gcross_rec=1; else NK_Gcross_rec=2;
if inpks=1 then pks_rec=1; else pks_rec=2;
if inbft=1 then bft_rec=1; else bft_rec=2;
if invessel=1 then vessel_rec=1; else vessel_rec=2;
if inves_Gcross=1 then ves_Gcross_rec=1; else ves_Gcross_rec=2;
if incafmif=1 then cafmif_rec=1; else cafmif_rec=2;
if incafGcross=1 then cafGcross_rec=1; else cafGcross_rec=2;
if instroma_epi_ratio=1 then stroma_epi_ratio_rec=1; else stroma_epi_ratio_rec=2;
if indrs=1 then drs_rec=1; else drs_rec=2;

proc sort nodupkey data=hp_all_lab; by id; run;

/* Combining HPFS lab data with other cohort  data (e.g., death data, disease data)   */
/*BMI and Physical Activity data from 1986 through 2010 are included in HPFS*/

data hp_alldata; 
  merge hp_all_lab (where=(patholdiff in (1,2,3,4)) in=inlab)
        hpaspone (in=hpas)
        hp_dead (in=a) 
        hp_mets hpfamily hp_der hp_colc1 (in=mstr) derived derived2 hp06 hpalcohol hpvtdscore hpsigmo hpapp
        end=_end_; 
  by id;  sex=2; 
  hpasin=hpas;
  if dbmy09=. then delete;
  colc1=mstr; if colc1=. then colc1=0;
  lab =inlab; if lab=. then lab=0;

cutoff = 1440; /** Cutoff: Dec 2019 **/

/* excluding malignant polyps*/
if sex=2 and id in (107084, 111239, 111928, 113365, 113875, 119770, 122257, 132548, 
 136560, 136772, 137761, 140068, 145740, 148983, 174674, 174986, 179398, 301594, 304921, 305686, 307916, 
 308998, 501390, 503635, 604338, 700016, 710190, 713785, 717028, 721143, 722621) then delete; 
/* excluding carcinoid, anal cancer, or cases with previous cancer history */
 if sex=2 and id in (401553, 403685, 139817, 301854, 712572, 721650) then delete;
/* if sex=2 and id in (100411, 100714, 100759, 104005, 104141, 109937, 112038, 112761, 
112987, 114085, 114165, 123911, 125508, 126725, 129682, 131243, 132188, 138032, 140988, 
141240, 144537, 144557, 145432, 147357, 149063, 149236, 150826, 150958, 151178, 153643, 
158665, 159382, 165656, 165890, 169733, 169789, 173628, 173839, 177372, 178136, 181844, 
182600, 185735, 186514, 186977, 188551, 189715, 304835, 305214, 307469, 308562,
407933, 500619, 500939, 502390, 502759, 507081, 507588, 600836, 701390, 702118,
702535, 703448, 706043, 706402, 707430, 708453, 715004, 717503, 110009, 113553,
120144, 124514, 125861, 126038, 143047, 144481, 148733, 153941, 171380, 176577,
178484, 182566, 301180, 303130, 305506, 307677, 308826, 402462, 506568, 508930,
706532, 710075, 713996, 106139, 109414, 126585, 127758, 141586, 159153, 160536,
188494, 188875, 304164, 601840, 704615, 106139, 126585, 141586, 160536, 188494,
704615, 106139, 141586, 160536, 188494) then cutoff = 1254; else cutoff = 1278;  */

id=id*100;

exrec=1;
if first.id and mstr then exrec=0;
hp = 1;
/*setting irt array*/
       array irt {*} irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 cutoff;
               array irtr {*} irtr86 irtr88 irtr90 irtr92 irtr94 irtr96 irtr98 irtr00 irtr02 irtr04 irtr06 irtr08 irtr10 irtr12 irtr14 cutoff;
               do i = 1 to dim(irt);
                       if irt{i} eq 0 or irt{i} eq . then irtr{i} = (1009 + 24*i);     /*changed from 1014 to 1009 for HPFS*/
                       else irtr{i} = irt {i};
               end;

/*availability of postdx questionnaire*/
array irtyn {*}  irtyn86 irtyn88 irtyn90 irtyn92 irtyn94 irtyn96 irtyn98 irtyn00 irtyn02 irtyn04 irtyn06 irtyn08 irtyn10 irtyn12 irtyn14 cutoff;

				 do i = 1 to dim(irt)-1;
                       if irt{i} eq 0 or irt{i} eq . then irtyn{i} = 0;
                       else irtyn{i} = 1;
                 end;

qqyes=0;
do i = 2 to dim(irt)-1; 
                       if irtr {i-1} lt dateca le irtr {i} then 
                       do; irtsum = 0;
                          do j = i to dim(irt)-1; 
                              irtsum = irtsum + irtyn{j};
                          end;
					      if irtsum ^=0 then qqyes=1; else qqyes=0; 
                       end;
end;

 /* determining weight and physical activty pre and post-diagnosis */
               hendo86=.;
               noinfovdp=.;
               
               array wtar{*} wt86 wt88 wt90 wt92 wt94 wt96 wt98 wt00 wt02 wt04 wt06 wt08 wt10 wt12 wt14;
               array wtarrpre{*} wt86x wt88x wt90x wt92x wt94x wt96x wt98x wt00x wt02x wt04x wt06x wt08x wt10x wt12x wt14x;
               array wtarpost{*} wt86y wt88y wt90y wt92y wt94y wt96y wt98y wt00y wt02y wt04y wt06y wt08y wt10y wt12y wt14y;
               array activity{*} act86 act88 act90 act92 act94 act96 act98 act00 act02 act04 act06 act08 act10 act12 act14; 
               array activitypre{*} actc86x actc88x actc90x actc92x actc94x actc96x actc98x actc00x actc02x actc04x actc06x actc08x actc10x actc12x actc14x;
               array activitypost {*} actc86y actc88y actc90y actc92y actc94y actc96y actc98y actc00y actc02y actc04y actc06y actc08y actc10y actc12y actc14y;
               array smoke{*} smoke86 smoke88 smoke90 smoke92 smoke94 smoke96 smoke98 smoke00 smoke02 smoke04 smoke06 smoke08 smoke10 smoke12 smoke14;
			   array pkyr{*} pckyr86 pckyr88 pckyr90 pckyr92 pckyr94 pckyr96 pckyr98 pckyr00 pckyr02 pckyr04 pckyr06 pckyr08 pckyr10 pckyr12 pckyr14;
               array endosc{*} endos86 endos88 endos90 endos92 endos94 endos96 endos98 endos00 endos02 endos04 endos06 endos08 endos10 endos12 endos14; /*current period endoscopy, 0=no end, 1=yes endo*/
               array hendos[*] hendo86 hendo88 hendo90 hendo92 hendo94 hendo96 hendo98 hendo00 hendo02 hendo04 hendo06 hendo08 hendo10 hendo12 hendo14; /*history of endoscopy, 0=no, 1=yes*/
			   array vtdar{*} vdp86 vdp88 vdp90 vdp92 vdp94 vdp96 vdp98 vdp00 vdp02 vdp04 vdp06 vdp08 noinfovdp noinfovdp noinfovdp;
			   array vtdarave{*} vdp86a vdp88a vdp90a vdp92a vdp94a vdp96a vdp98a vdp00a vdp02a vdp04a vdp06a vdp08a vdp08a noinfovdp noinfovdp;
			   array vtdarpre{*} vdp86x vdp88x vdp90x vdp92x vdp94x vdp96x vdp98x vdp00x vdp02x vdp04x vdp06x vdp08x vdp10x noinfovdp noinfovdp;
			   array vtdarpost{*} vdp86y vdp88y vdp90y vdp92y vdp94y vdp96y vdp98y vdp00y vdp02y vdp04y vdp06y vdp08y noinfovdp noinfovdp noinfovdp; /*We can not carry forward to imput postdiagnosis VD Score for 2010, we just keep it as blank*/
               array cafam2 {*} cafam286 cafam286 cafam290 cafam292 cafam292 cafam296 cafam296 cafam296 cafam296 cafam296 cafam296 cafam208 cafam208 cafam208 cafam208;

 /*impute weights forward if missing or 0 - will be used only for predx values*/            
              do i = 1 to dim(irt)-1;  
                       if wtar{i} gt 0 and wtar{i} ne . then wtarrpre{i} = wtar{i};
                       else if wtar{i} in (0,.) and i ne 1 then wtarrpre{i} = wtarrpre{i-1}; 
                       else wtarrpre{i} = .;
                       end;
  /*impute physical activity forward if missing or 0 - will be used only for predx values*/
               do i = 1 to dim(irt)-1;  
                       if activity{i} ne . then activitypre{i} = activity{i};
                       else if activity{i} eq . and i ne 1 then activitypre{i} =activitypre{i-1};  
                       else activitypre{i} = .;
                       end;

 /*impute vitamin D score if missing - will be used only for predx values*/
               do i = 1 to dim(irt)-1;  
					   if vtdar{i} ne . then vtdarpre{i} = vtdar{i};
					   else if vtdar{i} = . and i ne 1 then vtdarpre{i} = vtdarpre{i-1};
					   else vtdarpre{i} =.;
					   end;

  /*impute weights backwards if missing or 0 - only for postdx values     
               do i = 1 to dim(irt)-1; 
                      if wtar{dim(irt)-i} gt 0 and wtar{dim(irt)-i} ne . then wtarpost{dim(irt)-i} = wtar{dim(irt)-i};
                       else if wtar{dim(irt)-i} in (0,.) and i ne 1 then wtarpost{dim(irt)-i} = wtarpost{dim(irt)+1-i};
                       else wtarpost{dim(irt)-i} = .;
               end;
  */
             do i = 1 to dim(irt)-1; 
                      if wtar{i} gt 0 and wtar{i} ne . then wtarpost{i} = wtar{i};
                      else wtarpost{i} = .;
               end;

/*impute PA backwards if missing or 0 - only for postdx values           
               do i = 1 to dim(irt)-1; 
                       if activity{dim(irt)-i} ne . then activitypost{dim(irt)-i} = activity{dim(irt)-i};
                       else if activity{dim(irt)-i} eq . and i ne 1 then activitypost{dim(irt)-i}=activitypost{dim(irt)+1-i};
                       else activitypost{dim(irt)-i} = .;
                       end;
   */    

                   do i = 1 to dim(irt)-1; 
                      activitypost{i} = activity{i};
                   end;

    /*vitamin D score -  only for postdx values*/
                   do i = 1 to dim(irt)-2;         /*keep postdiagnostic VD score in 2010 as blank*/
					  vtdarpost{i} = vtdar{i};
			       end;

/*					    
  if irtr{dim(irt)-1}<dateca then do;
                               predxwt = wtarrpre{dim(irt)-1};
							   predxphact = activitypre {dim(irt)-1};
                               presmoking = smoke {dim(irt)-1};
                               predxdt = irtr {dim(irt)-1};
							     end;*/

              do i = 2 to dim(irt)-1; /*a do-end loop to determine pre and post diagnosis variables*/
                       if irtr {i-1} lt dateca le irtr {i} then do; /*dt of dx between 2 questionnaires*/
                               predxwt = wtarrpre{i-1};             /*prediagnosis weight*/
                               predxphact = activitypre {i-1};      /*prediagnosis physical activity*/
                               presmoking = smoke {i-1};            /*prediagnosis smoking status*/
							   prepkyr=pkyr {i-1};                  /*prediagnosis pack-year of smoking*/
                               predxdt = irtr {i-1};
                               prevtds = vtdarpre{i-1};             /*predisgnosis raw vitamin D score*/
							   prevtdsav=vtdarave{i-1};             /*prediagnosis cumulative average of vitamin D score*/
							   preendo= endosc{i-1};                /*prediagnosis period endoscopy, just once, 0=no end, 1=yes endo*/                       
							   prehendo=hendos{i-1};                 /*prediagnosis history of ednoscopy*/                         
                               prefh2=cafam2{i-1};                  /*prediagnosis family history of colorectal cancer*/

                               if (irtr{i}-6) ge dateca and ((irtr{i}-48) lt dateca) then do; /*for postdx wt - need to be at least 6 m and no more than 48 m after dx*/
                                       postdxwt = wtarpost{i};        /*postdiagnosis weight, not use imputed*/
                                       postdxdt = irtr{i};            /*keeps the date of survey for post date measure*/
                                       postdxphact = activitypost{i}; /*postdiagnosis physical activity, not use imputed*/ 
                                       postsmoking = smoke {i};       /*postdiagnosis smoking status, not use imputed*/
									   postpkyr=pkyr {i};             /*postdiagnosis pack-year of smoking, not use imputed*/
									   postvtds = vtdarpost{i};       /*postdiagnosis raw vitamin D score, not use imputed*/
									   end;
                               else if (irtr{i}-6) lt dateca and i ne dim(irt)-1 then do;
							        if ((irtr{i+1}-48) lt dateca) then 
                                      do;
                                       postdxwt = wtarpost{i+1};
                                       postdxdt = irtr{i+1};
                                       postdxphact = activitypost{i+1};
                                       postsmoking = smoke {i+1};
									   postpkyr=pkyr {i+1};                    
									   postvtds = vtdarpost{i+1};
									   end;
                                       end;
                               else do;
                                       postdxwt = .;
                                       postdxdt = .;
                                       postdxphact = .;
                                       postsmoking = .;
									   postpkyr=.;
									   postvtds = .;
                                       end;
					  
                       end;
               end;	


/*predx coindg for the cases with irtr14<=date of diagnosis*/
if predxwt = . and irtr14<=dateca then predxwt=wt14x;
if predxphact = . and irtr14<=dateca then predxphact=actc14x;
if presmoking = . and irtr14<=dateca then presmoking=smoke14;
if prepkyr=. and irtr14<=dateca then prepkyr=pckyr14;
if prevtds = . and irtr14<=dateca then prevtds=vdp10x;
if prevtdsav =. and irtr14<=dateca then prevtdsav=vdp08a;
if prefh2 =. and irtr14<=dateca then prefh2=cafam208;
if preendo=. and irtr14<=dateca then preendo=endos14;
if prehendo=. and irtr14<=dateca then prehendo=hendo14;
if irtr14<=dateca then predxdt=irtr14;

if prepkyr>=998 then prepkyr=.;
if postpkyr>=998 then postpkyr=.;


/* HPFS FH codes 2 */ 
if 1<=prefh2 then prefh=1; 
else if prefh2=0 then prefh=0;
*pre-post-dx FH. FH status at immideately after the dx*;
array postcafam2{*} cafam286 cafam290 cafam292 cafam296 cafam208;
array postfhirt{*}  irtr86   irtr90   irtr92   irtr96  irtr08;
prepostfh2=prefh2;
do i=1 to dim(postcafam2)-1;
   if postfhirt{i}<dateca<=postfhirt{i+1} then prepostfh2=postcafam2{i+1};
end;
if 1<=prepostfh2 then prepostfh=1;
else if prepostfh2=0 then prepostfh=0;
/* HPFS FH codes 2 end*/

/*convert to kg*/
       predxkg = predxwt / 2.2;
       postdxkg = postdxwt / 2.2;
       
       /*create a date variable for timeframe from postdxweight date to either death or cutoff*/
       if deadmonth = . then postdate = cutoff - postdxdt;
       else postdate = deadmonth - postdxdt;
       
       /*will exclude patients who had a physical activity measurement less than 6 months from
       death - to reduce bias of decreased activity due to disease*/
       if postdate lt 6 then activityexcl = 1;
       else activityexcl = 0;
       
       /*create a time from date of prediagnosis activity to diagnosis*/
       if predxdt ne 0 or predxdt ne . then timepredx = dateca - predxdt;

       else timepredx = .;
       
       /*create a time from date of diagnosis to postdiagnosis activity */

       if postdate ne 0 or postdate ne . then timepostdx = postdxdt - dateca;
       else timepostdx = .;
       
       /*convert to bmi*/
       if ht86 > 0 then predxbmi = (predxwt/2.2)/((ht86*0.0254)*(ht86*0.0254));
       if ht86 > 0 then postdxbmi = (postdxwt/2.2)/((ht86*0.0254)*(ht86*0.0254));
       
       /*change in BMI and KG pre and post dx*/
       bmichange= postdxbmi - predxbmi;
       kgchange = postdxkg - predxkg;
       
	   /*creat prediagnosis physical activity cateories*/
	   if predxphact = . then predxactivity = 9;
       else if predxphact ge 0 and predxphact le 3 then predxactivity = 1;
       else if predxphact gt 3 and predxphact le 9 then predxactivity = 2;
       else if predxphact gt 9 and predxphact le 18 then predxactivity = 3;
       else if predxphact gt 18 then predxactivity = 4;
      
	  /*creat postdiagnosis physical activity categories*/
      if postdxphact = . then postdxactivity = 9;
      else if postdxphact ge 0 and postdxphact le 3 then postdxactivity = 1;
      else if postdxphact gt 3 and postdxphact le 9 then postdxactivity = 2;
      else if postdxphact gt 9 and postdxphact le 18 then postdxactivity = 3;
	  else if postdxphact gt 18 then postdxactivity = 4;
       
       /*smoker will be the variable to describe smoking status at time of diagnosis*/
       select (presmoking);
       when ('1') presmoker = 1; /*never*/
       when ('2') presmoker = 2; /*past smoker*/
       when ('3') presmoker = 3; /*no, unknown past*/
       when ('4') presmoker = 4; /*current smoker*/
       otherwise presmoker = 5; /*missing*/
       end;
       
      select (postsmoking);
       when ('1') postsmoker = 1; /*never*/
       when ('2') postsmoker = 2; /*past smoker*/
       when ('3') postsmoker = 3; /*no, unknown past*/
       when ('4') postsmoker = 4; /*current smoker*/
       otherwise postsmoker = 5; /*missing*/
       end;

	   /*prediagnosis pack-year of smoking categories*/       
       if (prepkyr=0 or presmoker=1) then prepkyrc=1;      
	else if 0<prepkyr<20 then prepkyrc=2;
	else if 20<=prepkyr<40 then prepkyrc=3;
	else if 40<=prepkyr<999 then prepkyrc=4;
	else prepkyrc=5;     /*missing*/
    
	/*postdiagnosis pack-year of smoking categories*/
	   if (postpkyr=0 or postsmoker=1) then postpkyrc=1;     
	else if 0<postpkyr<20 then postpkyrc=2;
	else if 20<=postpkyr<40 then postpkyrc=3;
	else if 40<=postpkyr<999 then postpkyrc=4;
	else postpkyrc=5;     /*missing*/


agedx=(dateca-dbmy86)/12;
ageyr=agedx;
        if       agedx lt 50 then agegrp=1;
   else if 50 le agedx lt 60 then agegrp=2;
   else if 60 le agedx lt 70 then agegrp=3;
   else if       agedx ge 70 then agegrp=4;
   
%indic3(vbl=agegrp,prefix=agegrp,min=2,max=4,reflev=1,missing=., usemiss = 0);

/***********************************************************/
/**  Creating a new TNM stage variable.  To do this, I'm  **/
/**  replicating the code Charlie used in his program:    **/
/**  /proj/nhclcs/nhclc0d/cfuchs/colon.032805.sas         **/
/***********************************************************/
newstage = 99;
     if  tstage = 5 and nstage = 1 and mstage = 1                then newstage = 0;
else if (tstage = 1 or tstage = 2) and nstage = 1 and mstage = 1 then newstage = 1;
else if (tstage = 3 or tstage = 4) and nstage = 1 and mstage = 1 then newstage = 2;
else if  nstage ge 2 and nstage le 4 and mstage = 1              then newstage = 3;
else if  mstage = 2                                              then newstage = 4;

	 if newstage = 1 then stageall=1; 
else if newstage = 2 then stageall=2;
else if newstage = 3 then stageall=3; 
else if newstage = 4 then stageall=4; else stageall =5;  
%indic3(vbl=stageall,prefix=stageall,min=2,max=5,reflev=1,usemiss=0); 

/** There is another definition of TNM**/
/**Kana imputed 127 missing stages into stage I and stage II in HPFS**/
/**finalstage is the variable with imputaed stages**/
/*/*Compared with stageall, finalstage has less missing stage*/
     if finalstage=. then finalstage =5;           
%indic3(vbl=finalstage,prefix=finalstage,min=2,max=5,reflev=1,usemiss=0);  

/********************************************************************************/
/**  BELOW ARE THE SURVIVAL TIME CALCULATIONS.  JEFF USED SURVEY DATE IN SOME  **/
/**  OF HIS SURVIVAL TIME CALCULATIONS, SO WE WILL NEED TO MODIFY THIS TO USE  **/
/**  DATE OF DX FOR OUR ANALYSES.                                              **/
/********************************************************************************/
if a and (dicda=:'153' or dicda=:'154') & dicda ne 'E' then case11=1;
   else case11=0;

   if a and mstr then case19=1;
   else case19=0;

   if a and case11 ne 1 then do;
      if 0<deadmonth<=cutoff then do;
      crccens=0;
      crcsurv=(deadmonth-dateca)/12;
      end;
      else if cutoff<deadmonth then do;
      crccens=0;
      crcsurv=(cutoff-dateca)/12;
	  end;
      end;

   else if case11 ne 1 then do;
      crccens=0;
      crcsurv=(cutoff-dateca)/12; 
      end;

   else if case11 eq 1 then do;
      if 0<deadmonth<=cutoff then do;
      crcsurv=(deadmonth-dateca)/12;
      crccens=1;
	  end;
      else if cutoff<deadmonth then do;
      crcsurv=(cutoff-dateca)/12;
      crccens=0;
      end;
      end;

   if crcsurv > 120 then do;
      crcsurv = 120;
      crccens = 0;
   end;

   if case19 ne 1 then do;
      oscens=0;
      osurv=(cutoff-dateca)/12;
      end;

   else if case19 eq 1 then do;
       if 0<deadmonth<=cutoff then do;
       osurv=(deadmonth-dateca)/12;
       oscens=1;
	   end;
       else if cutoff<deadmonth then do;
       osurv=(cutoff-dateca)/12;
       oscens=0;
	   end;
       end;

   if osurv > 120 then do;
      osurv = 120;
      oscens = 0;
   end;

/*added to create crcsurvpost as in NHS*/
/*for postdx activity, the time is from date of postdx activity questionnaire to death or cutoff
         for predx activity, the time is from date of diagnosis to death or cutoff*/
   if case11 eq 1 and case19 eq 1 then do;
		crccens = 1;
		oscens = 1;
		crcsurvpost=(deadmonth-postdxdt)/12;
		ospost=(deadmonth-postdxdt)/12;		           
		crcsurvpost2 =(deadmonth-dateca)/12;
		end;
	  else if case11 ne 1 and case19 eq 1 then do;
		crccens = 0;
		oscens = 1;
		crcsurvpost=(deadmonth-postdxdt)/12;
        crcsurvpost2 =(deadmonth-dateca)/12;
		ospost=(deadmonth-postdxdt)/12;
		end;
	  else if case11 ne 1 and case19 ne 1 then do;
		crccens = 0;
		oscens = 0;
        crcsurvpost=(cutoff-postdxdt)/12;
        crcsurvpost2 =(cutoff-dateca)/12;
		ospost=(cutoff-postdxdt)/12;
              	end;

/*************************/
/*Aspirin and NSAIDs code*/
/*************************/

*****Aspirin array*****;
/*NOTE that tablets per week is only available after 1992*/
aspwkcarry86=.; aspwkcarry88=.; aspwkcarry90=.;
avaspwkcarry86=.; avaspwkcarry88=.; avaspwkcarry90=.;
aspwkpost86=.; aspwkpost88=.; aspwkpost90=.;
/*prediagnosis aspirin*/
array aspwkcarryII{*} aspwkcarry86 aspwkcarry88 aspwkcarry90 aspwkcarry92 aspwkcarry94 aspwkcarry96 aspwkcarry98
                      aspwkcarry00 aspwkcarry02 aspwkcarry04 aspwkcarry06 aspwkcarry08 aspwkcarry10 aspwkcarry12 aspwkcarry14;
array avaspwkcarryII{*} avaspwkcarry86 avaspwkcarry88 avaspwkcarry90 avaspwkcarry92 avaspwkcarry94 avaspwkcarry96 
                        avaspwkcarry98 avaspwkcarry00 avaspwkcarry02 avaspwkcarry04 avaspwkcarry06 avaspwkcarry08 avaspwkcarry10 
                        avaspwkcarry12 avaspwkcarry14;
array regascarryII{*} regascarry86 regascarry88 regascarry90 regascarry92 regascarry94 regascarry96 regascarry98 
                      regascarry00 regascarry02 regascarry04 regascarry06 regascarry08 regascarry10 regascarry12 regascarry14;
array avregcarryII{*} avregcarry86 avregcarry88 avregcarry90 avregcarry92 avregcarry94 avregcarry96 avregcarry98
                      avregcarry00 avregcarry02 avregcarry04 avregcarry06 avregcarry08 avregcarry10 avregcarry12 avregcarry14;
/*postdiagnosis aspirin*/
array aspwkpostII{*} aspwkpost86 aspwkpost88 aspwkpost90 aspwkpost92 aspwkpost94 aspwkpost96 aspwkpost98 
                     aspwkpost00 aspwkpost02 aspwkpost04 aspwkpost06 aspwkpost08 aspwkpost10 aspwkpost12 aspwkpost14;
array regaspostII{*} regaspost86 regaspost88 regaspost90 regaspost92 regaspost94 regaspost96 regaspost98 
                     regaspost00 regaspost02 regaspost04 regaspost06 regaspost08 regaspost10 regaspost12 regaspost14;


*****NSAIDs array*****;
array anyibucarryII{*} anyibucarry86 anyibucarry88 anyibucarry90 anyibucarry92 anyibucarry94 anyibucarry96 anyibucarry98
                       anyibucarry00 anyibucarry02 anyibucarry04 anyibucarry06 anyibucarry08 anyibucarry10 anyibucarry12 anyibucarry14;
array anyibupostII{*} regibu86y regibu88y regibu90y regibu92y regibu94y regibu96y regibu98y
                      regibu00y regibu02y regibu04y regibu06y regibu08y regibu10y regibu12y regibu14y;


/*determine immedeately before diagnosis and immedeately after diagnosis aspirin variables*/
do i=2 to dim(irtr)-1; 
 if irtr{i-1} lt dateca le irtr{i} then do;
 /*prediagnosis*/
 predxaspwk = aspwkcarryII{i-1};     /*immedeately before diagnosis aspirin itnake tabs/week*/
 predxaspwkav = avaspwkcarryII{i-1}; /*immedeately before diagnosis cumulative average of intake*/
 predxregasp = regascarryII{i-1};    /*immedeately before diagnosis regular use of aspirin*/
 predxanyibu = anyibucarryII{i-1};   /*immedeately before diagnosis any use of NSAIDs*/

 /*postdiagnosis*/
 postdxaspwk = aspwkpostII{i};       /*immedeately after the time of diagnosis aspirin intake tabs/week*/
 postdxregasp = regaspostII{i};      /*immedeately after the time of diagnosis regular use*/
 postdxanyibu = anyibupostII{i};     /*immedeately after the time of diagnosis any use of NSAIDs*/

 cycle = i-1; 
 end;
end;

/*aspirin use to be consistent with tablets/wk and regular asp*/
 *pre*;
     if predxregasp=1 and 0<predxaspwk then predxaspwk=0;
else if predxregasp=2 and predxaspwk=0 then predxaspwk=.;
 *post*;
     if postdxregasp=1 and 0<postdxaspwk then postdxaspwk=0;
else if postdxregasp=2 and postdxaspwk=0 then postdxaspwk=.;


/*create a variable for time at which first non-missing post-diagnosis questionnaire returned*/
firstpost=.;
if cycle eq 1 then do;
 if aspi88 ne . then firstpost=irtr88;
 else if aspi90 ne . then firstpost=irtr90;
 else if aspi92 ne . then firstpost=irtr92;
 else if aspi94 ne . then firstpost=irtr94;
 else if aspi96 ne . then firstpost=irtr96;
 else if aspi98 ne . then firstpost=irtr98;
 else if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 2 then do;
 if aspi90 ne . then firstpost=irtr90;
 else if aspi92 ne . then firstpost=irtr92;
 else if aspi94 ne . then firstpost=irtr94;
 else if aspi96 ne . then firstpost=irtr96;
 else if aspi98 ne . then firstpost=irtr98;
 else if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 3 then do;
 if aspi92 ne . then firstpost=irtr92;
 else if aspi94 ne . then firstpost=irtr94;
 else if aspi96 ne . then firstpost=irtr96;
 else if aspi98 ne . then firstpost=irtr98;
 else if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 4 then do;
 if aspi94 ne . then firstpost=irtr94;
 else if aspi96 ne . then firstpost=irtr96;
 else if aspi98 ne . then firstpost=irtr98;
 else if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 5 then do;
 if aspi96 ne . then firstpost=irtr96;
 else if aspi98 ne . then firstpost=irtr98;
 else if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 6 then do;
 if aspi98 ne . then firstpost=irtr98;
 else if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 7 then do;
 if aspi00 ne . then firstpost=irtr00;
 else if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 8 then do;
 if aspi02 ne . then firstpost=irtr02;
 else if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 9 then do;
 if aspi04 ne . then firstpost=irtr04;
 else if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 10 then do;
 if aspi06 ne . then firstpost=irtr06;
 else if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 11 then do;
 if aspi08 ne . then firstpost=irtr08;
 else if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 12 then do;
 if aspi10 ne . then firstpost=irtr10;
 else if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 13 then do;
 if aspi12 ne . then firstpost=irtr12;
 else if aspi14 ne . then firstpost=irtr14;
end;
else if cycle eq 14 then do;
 if aspi14 ne . then firstpost=irtr14;
end;

/*create a variable for time in months from date of diagnosis 
to first non-missing aspirin questionnaire date*/
postmonth = firstpost-dateca;
label postmonth="dtdx to asp Qx";

/**************/
/*Alcohol code*/
/**************/
array orgalc[*]   alco86n alco86n alco90n alco90n alco94n alco94n alco98n alco98n alco02n alco02n alco06n alco06n alco10n alco10n alco14n;
array upalcarr[*] upalc86 upalc86 upalc90 upalc90 upalc94 upalc94 upalc98 upalc98 upalc02 upalc02 upalc06 upalc06 upalc10 upalc10 upalc14;
array alcoarr[*]  base86n base86n base90n base90n base94n base94n base98n base98n base02n base02n base06n base06n base10n base10n base14n;

do i=1 to dim(orgalc);
   upalcarr[i]=orgalc[i];
   alcoarr[i]=orgalc[i];
end;

/*for predx, carry foward if missing*/
do i=2 to dim(upalcarr);
   if upalcarr[i]=. and upalcarr[i-1] ne . then upalcarr[i]=upalcarr[i-1];
end;

do i=1 to dim(upalcarr);
   if upalcarr[i]=0 then upalcarr[i]=0;
   else if 0<upalcarr[i]<15 then upalcarr[i]=1;
   else if 15<=upalcarr[i] then upalcarr[i]=2;
end;

/*for postdx, carry backward if missing*/
do i=dim(alcoarr)-1 to 1 by -1;
   if alcoarr[i] eq . and alcoarr[i+1] ne . then alcoarr[i]=alcoarr[i+1];
end;
do i=1 to dim(alcoarr);
   if alcoarr[i]=0 then alcoarr[i]=0;
   else if 0<alcoarr[i]<15 then alcoarr[i]=1;
   else if 15<=alcoarr[i] then alcoarr[i]=2;
end;

basealcon=alco86n; /*baseline alcohol intake*/

 do i = 2 to dim(irtr)-1; /*a do-end loop to determine pre and post diagnosis variables*/
                      if irtr {i-1} lt dateca le irtr {i} then 
                       do; /*dt of dx between 2 questionnaires*/
                               predxalc = upalcarr{i-1};         /*prediagnosis alcohol intake categories*/
                               if ((irtr{i}-6) ge dateca) and ((irtr{i}-48) lt dateca) then 
                                 do; /*for postdx wt - need to be at least 6 m and no more than 48m(4 year) after dx*/
                                       postdxalc = alcoarr{i};   /*postdianosis alcohol intake categories, use imputed*/
                                 end;
                               else if (irtr{i}-6) lt dateca and i ne dim(irtr)-1 then 
                                     do;
									   if ((irtr{i+1}-48) lt dateca) then 
                                        do;
                                         postdxalc = alcoarr{i+1}; /*postdianosis alcohol intake categories, use imputed*/
										end;
                                     end;
                               else do;
                                       postdxalc = .;
                                       end;
                       end;
  end;

/*predx coindg for the cases with irtr14<=date of diagnosis*/
if predxaspwk = . and irtr14<=dateca then predxaspwk=aspwkcarry14;
if predxaspwkav = . and irtr14<=dateca then predxaspwkav=avaspwkcarry14;
if predxregasp = . and irtr14<=dateca then predxregasp=regascarry14;
if predxregaspav = . and irtr14<=dateca then predxregaspav=avregcarry14;
if predxalc = . and irtr14<=dateca then predxalc=upalc14;
if predxanyibu = . and irtr14<=dateca then predxanyibu=anyibucarry14;

/*any use of aspirin in HPFS is same as regular use of aspirin*/
predxanyasp=predxregasp;
postdxanyasp=postdxregasp;

run;



/**********************HPFS data with lab data is created****************************/


/**************************************************************************************/
/************************ Combining NHS and HPFS data files. **************************/
/**************************************************************************************/
data alldata;
set nh_alldata hp_alldata;
/* excluding malignant polyps*/
if TumorID in (888, 2710, 1530, 1303) then delete;
proc sort data=alldata; by cohort id; run;


/***************************create new variables for all user***************************/
data alldata;set alldata end=_end_; /*this is necessary to eliminate the unintinalized error for _end_ 052615*/


/**  Creating common site/location variables   **/
/* "sitea" 1-5 proximal, 6-8 distal colon, 9-10 rectum
1=appendix
2=cecum
3=ascending
4=hepatic flexure
5=transverse
6=splenic flexure
7=descending 
8=sigmoid
9=rectosigmoid
10=rectum */
sitea =. ; 
if sitehp=30 then sitea=4; 
if sitehp=31 then sitea=5;
if sitehp=32 then sitea=7;
if sitehp=33 then sitea=8;
if sitehp=34 then sitea=2;
if sitehp=35 then sitea=1;
if sitehp=36 then sitea=3;
if sitehp=37 then sitea=6;
if sitehp=40 then sitea=9;
if sitehp=41 then sitea=10;
if sitehp=42 then sitea=10;
if sitehp=43 then sitea=10;
if sitehp=49 then sitea=10;

if site=1 then sitea=3;       
if site=2 then sitea=5;
if site=3 then sitea=7;
if site=4 then sitea=8;
if site=5 then sitea=10;
if site=6 then sitea=2;
if site=8 then sitea=9;

if sitea= . and strlocation = "T"  then sitea=5; 
if sitea= . and strlocation = "S"  then sitea=8; 
if sitea= . and strlocation = "RT" then sitea=3; 
if sitea= . and strlocation = "RS" then sitea=9; 
if sitea= . and strlocation = "R"  then sitea=10; 
if sitea= . and strlocation = "P"  then sitea=1; 
if sitea= . and strlocation = "left" then sitea=7; 
if sitea= . and strlocation = "L"  then sitea=7; 
if sitea= . and strlocation = "H"  then sitea=4; 
if sitea= . and strlocation = "F"  then sitea=6; 
if sitea= . and strlocation = "distA" then sitea=3; 
if sitea= . and strlocation = "D"  then sitea=7; 
if sitea= . and strlocation = "C"  then sitea=2; 
if sitea= . and strlocation = "A"  then sitea=3; 
/* assign detailed subsite info for NHS */
if 1<= site <=2 and strlocation = "H" then sitea=4; 
if 2<= site <=3 and strlocation = "F" then sitea=6; 
if     site = 6 and strlocation = "P" then sitea=1; 

/* "siteb" including "colon unspecified"
1=appendix
2=cecum
3=ascending
4=hepatic flexure
5=transverse
6=splenic flexure
7=descending 
8=sigmoid
9=rectosigmoid
10=rectum 
11=colon unspecified 
12=rectum unspecified */

if 1<= sitea <=10 then siteb = sitea; 
else if 38<=sitehp<=39 then siteb=11;
else if     sitehp =48 then siteb=12; 
else if site=7 and coldirt = 1 then siteb=11;
else if site=7 and rectdirt=1 then siteb=12; 

/* "sitec" simplified to match with original NHS subsite classification
1=cecum
2=ascending
3=hepatic flexure/transverse
4=splenic flexure/descending 
5=sigmoid
6=rectosigmoid
7=rectum */

if 1<= sitea <=2 then sitec=1; 
if     sitea  =3 then sitec=2;
if 4<= sitea <=5 then sitec=3; 
if 6<= sitea <=7 then sitec=4;
if     sitea  =8 then sitec=5;
if     sitea  =9 then sitec=6;
if     sitea =10 then sitec=7; 

/* proximal colon v distal colon v rectum */ 
if 1<= sitea <=5 then location =2; 
if 6<= sitea <=8 then location =1; 
if 9<= sitea<=10 then location =0; 
%indic3(vbl=location, prefix=location, min=1, max=2, reflev=0, missing=., usemiss = 1, 
label0='rectal cancer', label1='distal colon', label2='proximal colon');

/* location variables missing included into proximal colon*/
if location = 0 then loc =0; 
if location = 1 then loc =1; 
else loc =2; 
%indic3(vbl=loc, prefix=loc, min=1, max=2, reflev=0, usemiss = 0, 
label0='rectal cancer', label1='distal colon', label2='proximal colon/missing'); 

/* FH codes 3*/
if prefh2 = 0 then prefh2all=0; 
else if prefh2 = 1 then prefh2all=1; 
else if prefh2 = 2 then prefh2all=2; 
else prefh2all =0; 

 %indic3(vbl=prefh2all, prefix=prefh2all, min=1, max=2, reflev=0, usemiss = 0, 
label0='without family history of colorectal cancer',
label1='predx CRC FH 1 1st degree relative', 
label2='predx CRC FH >=2 1st degree relative'); /* missing cases are 
included into referent */ 
 %indic3(vbl=prefh2, prefix=prefh2, min=1, max=2, reflev=0, missing=.,usemiss = 1, 
label0='without family history of colorectal cancer',
label1='predx CRC FH 1 1st degree relative', 
label2='predx CRC FH >=2 1st degree relative'); /* missing cases are assigned 
as missing indicator category*/ 



/*********************cutoff for molecular markers**********************/
/*CDX2*/
if CDX2Strongest>=2 then cdx2=0; /*CDX2 pos*/
else if CDX2Strongest=1 then cdx2=1; /*CDX2 loss*/


/*PTGER2 definition for non-TMA12*/
if 0<=PTGER2percposcyto<50 then PTGER2=0; /*PTGER2 neg*/
else if 50<=PTGER2percposcyto<=100 then PTGER2=1; /*PTGER2 pos*/

/*PTGER2 definition for TMA12*/
if PTGER2overallcyto=. then PTGER2TMAper = (PTGER2TMA121perccyto + PTGER2TMA122percposcyto)/2;

if PTGER2overallcyto=. and PTGER2TMA121perccyto=. and PTGER2TMA122percposcyto ne . then PTGER2TMAper=PTGER2TMA122percposcyto;
if PTGER2overallcyto=. and PTGER2TMA122percposcyto=. and PTGER2TMA121perccyto ne . then PTGER2TMAper=PTGER2TMA121perccyto;

if 0<=PTGER2TMAper<50 then PTGER2=0;/*PTGER2 neg*/
else if 50<=PTGER2TMAper<=100 then PTGER2=1;/*PTGER2 pos*/


/*AURKA*/
if 3<=aurkanoverall <=4 then aurk=1;/*AURKA pos*/
else if aurkanoverall = 2 and aurkanperc >=50 then aurk=1;/*AURKA pos*/
else if aurkanoverall = 2  then aurk=0;/*AURKA neg*/
else if aurkanoverall = 1  then aurk=0;/*AURKA neg*/


/*HIF1Acat2 definition for non-TMA12*/
if HIF1Aoverall = 4                        then HIF1Acat2=1;/*HIF1A pos*/
else if HIF1Aoverall = 3 and 50 =<HIF1Aposperc <=100 then HIF1Acat2=1;/*HIF1A pos*/
else if HIF1Aoverall = 3  then HIF1Acat2=0;/*HIF1A neg*/
else if 1<=HIF1Aoverall <=2 then HIF1Acat2=0;/*HIF1A neg*/

/*HIF1Acat2 definition for TMA12*/
if HIF1Aoverall=. then HIF1ATMA12 = (HIF1ATMA121overall + HIF1ATMA122overall)/2;
if HIF1Aoverall=. then HIF1ATMAper = (HIF1ATMA121posperc + HIF1ATMA122posperc)/2;

if HIF1Aoverall=. and HIF1ATMA121overall=. and HIF1ATMA122overall ne . then HIF1ATMA12=HIF1ATMA122overall;
if HIF1Aoverall=. and HIF1ATMA122overall=. and HIF1ATMA121overall ne . then HIF1ATMA12=HIF1ATMA121overall;
if HIF1Aoverall=. and HIF1ATMA121posperc=. and HIF1ATMA122posperc ne . then HIF1ATMAper=HIF1ATMA122posperc;
if HIF1Aoverall=. and HIF1ATMA122posperc=. and HIF1ATMA121posperc ne . then HIF1ATMAper=HIF1ATMA121posperc;

if 3<=HIF1ATMA12<=4 then HIF1Acat2=1;/*HIF1A pos*/
else if HIF1ATMA12 = 2.5 and 40 =<HIF1ATMAper <=100  then HIF1Acat2=1;/*HIF1A pos*/
else if HIF1ATMA12 = 2.5  then HIF1Acat2=0;/*HIF1A neg*/
else if 1<=HIF1ATMA12<=2  then HIF1Acat2=0;/*HIF1A neg*/



/*EPAS1cat2 definition for non-TMA12*/
if 2<=EPAS1overall<=4     then EPAS1cat2=1; /*EPAS1 pos*/
else if EPAS1overall =1   then EPAS1cat2=0; /*EPAS1 neg*/

/*EPAS1cat2 definition for TMA12*/
if EPAS1overall=. then EPAS1TMA12 = (EPAS1TMA121overall + EPAS1TMA122overall)/2;
if EPAS1overall=. then EPAS1TMAper = (EPAS1TMA121posperc + EPAS1TMA122posperc)/2;

if EPAS1overall=. and EPAS1TMA121overall=. and EPAS1TMA122overall ne . then EPAS1TMA12=EPAS1TMA122overall;
if EPAS1overall=. and EPAS1TMA122overall=. and EPAS1TMA121overall ne . then EPAS1TMA12=EPAS1TMA121overall;
if EPAS1overall=. and EPAS1TMA121posperc=. and EPAS1TMA122posperc ne . then EPAS1TMAper=EPAS1TMA122posperc;
if EPAS1overall=. and EPAS1TMA122posperc=. and EPAS1TMA121posperc ne . then EPAS1TMAper=EPAS1TMA121posperc;

if 2<=EPAS1TMA12 <=4 then EPAS1cat2=1;/*EPAS1 pos*/
else if EPAS1TMA12=1.5 and 5=<EPAS1TMAper <=100  then EPAS1cat2=1;/*EPAS1 pos*/
else if EPAS1TMA12=1.5 then EPAS1cat2=0;/*EPAS1 neg*/
else if EPAS1TMA12=1   then EPAS1cat2=0;/*EPAS1 neg*/


/*PRKAA (AMPK) definition for non-TMA12*/
if 3<=PRKAAstrongest<=4       then PRKAA=1;/*PRKAA pos*/
else if PRKAAstrongest = 2 and 20=<PRKAAposperc<=100 then PRKAA=1;/*PRKAA pos*/
else if PRKAAstrongest = 2     then PRKAA=0;/*PRKAA neg*/
else if PRKAAstrongest = 1     then PRKAA=0;/*PRKAA neg*/


/*PRKAA (AMPK) definition for TMA12*/
if PRKAAstrongest=. then PRKAATMA12 = (PRKAATMA121strongest + PRKAATMA122strongest)/2;
if PRKAAstrongest=. then PRKAATMAper = (PRKAATMA121percpos + PRKAATMA122percpos)/2;

if PRKAAstrongest=. and PRKAATMA121strongest=. and PRKAATMA122strongest ne . then PRKAATMA12=PRKAATMA122strongest;
if PRKAAstrongest=. and PRKAATMA122strongest=. and PRKAATMA121strongest ne . then PRKAATMA12=PRKAATMA121strongest;
if PRKAAstrongest=. and PRKAATMA121percpos=. and PRKAATMA122percpos ne . then PRKAATMAper=PRKAATMA122percpos;
if PRKAAstrongest=. and PRKAATMA122percpos=. and PRKAATMA121percpos ne . then PRKAATMAper=PRKAATMA121percpos;

if 2<=PRKAATMA12<=4     then PRKAA=1;/*PRKAA pos*/
else if PRKAATMA12=1.5 and 10=<PRKAATMAper<=100  then PRKAA=1;/*PRKAA pos*/
else if PRKAATMA12=1.5  then PRKAA=0;/*PRKAA neg*/
else if PRKAATMA12=1    then PRKAA=0;/*PRKAA neg*/

/*MAPK (ERK1/2) definition for non-TMA12 (BJC 2010)*/
if 2<=MAPKstrnuc<=4   then MAPK=1;/*MAPK pos*/
else if MAPKstrnuc = 1 and 0<MAPKposnucper<=100  then MAPK=1;/*MAPK pos*/
else if MAPKstrnuc = 1  then MAPK=0; /*MAPK neg*/

/*MAPK (ERK1/2) definition for TMA12 (BJC 2010)*/
if MAPKstrnuc =. then MAPKTMA12 = (MAPKTMA121strongestnuclear  + MAPKTMA122strongestnuclear )/2;
if MAPKstrnuc =. then MAPKTMAper = (MAPKTMA121percposnuclear + MAPKTMA122percposnuclear)/2;

if MAPKstrnuc=. and MAPKTMA121strongestnuclear =. and MAPKTMA122strongestnuclear  ne . then MAPKTMA12=MAPKTMA122strongestnuclear ;
if MAPKstrnuc=. and MAPKTMA122strongestnuclear =. and MAPKTMA121strongestnuclear  ne . then MAPKTMA12=MAPKTMA121strongestnuclear ;
if MAPKstrnuc=. and MAPKTMA121percposnuclear=. and MAPKTMA122percposnuclear ne . then MAPKTMAper=MAPKTMA122percposnuclear;
if MAPKstrnuc=. and MAPKTMA122percposnuclear=. and MAPKTMA121percposnuclear ne . then MAPKTMAper=MAPKTMA121percposnuclear;

if 2.5<=MAPKTMA12 <=4 then MAPK=1;/*MAPK pos (BJC 2010)*/
else if 1.5<=MAPKTMA12<=2 and 10=<MAPKTMAper <=100  then MAPK=1;/*MAPK pos*/
else if 1.5<=MAPKTMA12<=2 and 0=<MAPKTMAper <10  then MAPK=0;/*MAPK neg*/
else if MAPKTMA12=1  then MAPK=0;/*MAPK neg (BJC 2010)*/

/*pAkt definition for non TMA12*/     
if 2<=paktoverall <=4    then pakt=1;/*p-AKT pos*/
else if paktoverall =1   then pakt=0;/*p-AKT neg*/

/*pAkt definition for TMA12*/
if pAktoverall=. then pAktTMA12 = (paktTMA121overall + paktTMA122overall)/2;
if pAktoverall=. then pAktTMAper = (paktTMA121percpos + paktTMA122percpos)/2;

if pAktoverall=. and paktTMA121overall=. and paktTMA122overall ne . then pAktTMA12=paktTMA122overall;
if pAktoverall=. and paktTMA122overall=. and paktTMA121overall ne . then pAktTMA12=paktTMA121overall;
if pAktoverall=. and paktTMA121percpos=. and paktTMA122percpos ne . then pAktTMAper=paktTMA122percpos;
if pAktoverall=. and paktTMA122percpos=. and paktTMA121percpos ne . then pAktTMAper=paktTMA121percpos;

if 1.5<=pAktTMA12 <=4                        then pakt=1;/*p-AKT pos*/
else if pAktTMA12 = 1 and 0<pAktTMAper<=100  then pakt=1;/*p-AKT pos*/
else if pAktTMA12 = 1                        then pakt=0;/*p-AKT neg*/

/*CTSB definition for non-TMA12*/
if 2<=CTSBoverall <=4     then CTSB=1;/*CTSB pos*/
else if CTSBoverall =1 and 1=<CTSBposper<=100 then CTSB=1;/*CTSB pos*/
else if CTSBoverall =1    then CTSB=0;/*CTSB neg*/

/*CTSB definition for TMA12*/
if CTSBoverall=. then CTSBTMA12 = (CTSBTMA121overall + CTSBTMA122overall)/2;
if CTSBoverall=. then CTSBTMAper = (CTSBTMA121percpos + CTSBTMA122percpos)/2;

if CTSBoverall=. and CTSBTMA121overall=. and CTSBTMA122overall ne . then CTSBTMA12=CTSBTMA122overall;
if CTSBoverall=. and CTSBTMA122overall=. and CTSBTMA121overall ne . then CTSBTMA12=CTSBTMA121overall;
if CTSBoverall=. and CTSBTMA121percpos=. and CTSBTMA122percpos ne . then CTSBTMAper=CTSBTMA122percpos;
if CTSBoverall=. and CTSBTMA122percpos=. and CTSBTMA121percpos ne . then CTSBTMAper=CTSBTMA121percpos;

if 1.5<=CTSBTMA12 <=4 then CTSB=1;/*CTSB pos*/
else if CTSBTMA12=1  then CTSB=0; /*CTSB neg*/

/*IGF2 DMR0 (gastro 2010)*/

/*IGF2 DMR0 has 3 CpGs. In Gastro paper, we used only 2 CpG (first and second one).*/
/*poscheck=0(blue), poscheck=1(yellow), poscheck=2(red)*/

/*use blue and yellow, not red*/
if 0<=IGF2DMR0pos1check<=1 then IGF2DMR0pos1V=1;
else if IGF2DMR0pos1check=2 then IGF2DMR0pos1V=0;

if 0<=IGF2DMR0pos2check<=1 then IGF2DMR0pos2V=1;
else if IGF2DMR0pos2check=2 then IGF2DMR0pos2V=0;


IGF2DMR0totalposition2=IGF2DMR0pos1V+IGF2DMR0pos2V;
*if IGF2DMR0totalposition2=0 then delete;

IGF2DMR0pos1Cmethylatedvalue=IGF2DMR0pos1perc*IGF2DMR0pos1V;
IGF2DMR0pos2Cmethylatedvalue=IGF2DMR0pos2perc*IGF2DMR0pos2V;

IGF2DMR0totalvalue2=IGF2DMR0pos1Cmethylatedvalue+IGF2DMR0pos2Cmethylatedvalue;

if IGF2DMR0totalposition2 ne 0 then do;
IGF2DMR0avgr2=IGF2DMR0totalvalue2/IGF2DMR0totalposition2; end;
/*IGF2DMR0avgr2 can be used as "raw value"*/

/*quartile*/
if      37.45<=IGF2DMR0avgr2<=100     then IGF2quall=1;
else if 30.60<=IGF2DMR0avgr2<37.45  then IGF2quall=2;
else if 23.90<=IGF2DMR0avgr2<30.60  then IGF2quall=3;
else if 0<=IGF2DMR0avgr2<23.90     then IGF2quall=4;
%indic3(vbl=IGF2quall, prefix=IGF2quall, min=1, max=4, reflev=1, missing=., usemiss=0);   

/*definition for IGF hypo*/
if 1<=IGF2quall<=3 then IGF2qucat2=1;
else if IGF2quall=4 then IGF2qucat2=2;


/*MLH1 definition*/
if 3<=MLH1overall<=4 then MLH1loss=0; /*MLH1 intact*/
else if 1<=MLH1overall<=2 then MLH1loss=1; /*MLH1 loss*/

/*MSH2 definition*/
if 3<=MSH2overall<=4 then MSH2=2;/*MSH2 pos*/
else if 1<=MSH2overall<=2 then MSH2=1;/*MSH2 neg*/

/*cut off of p16 lost (IJC 2010)*/
if 0<p16overall<=1 then p16d=1;
else if p16overall=2 and p16internalcontrolpositive=1                 then p16d=2;
else if p16overall=2 and p16internalcontrolpositive=0 then p16d=3;
else if p16overall=2                                     then p16d=4; 
else if p16overall=3 and p16lostArea =1                               then p16d=5; 
else if p16overall=3 and p16smallarealoss=1                           then p16d=6;
else if p16overall=3 then p16d=7;
else if p16overall=4 then p16d=8;

if p16d in (1,2) then p16a=1; /*p16 IHC loss*/
else if p16d in (3,4,5,6,7,8) then p16a =0; /*p16 IHC pos*/


/*cut off of p16 methylation (IJC 2010)*/
if P16cc<4 then p16b=0; /*p16 unmethylated*/
else if P16cc>=4 then p16b=1; /*p16 methylated*/


/* cut off of PPARG*/
if 3<=ppargnuclearoverall<=4 then pparg=1;
else if ppargnuclearoverall =2 and 20<= ppargperc then pparg=1 ; 
else if ppargnuclearoverall =2 and 10<= ppargperc <20 then pparg=0 ; 
else if ppargnuclearoverall =2                      then pparg=0 ; 
else if ppargnuclearoverall =1 then pparg =0; 


/*cut off of mgmt methylation*/;
if mgmt=0 then mgmtmet=0; /*mgmt unmethylated*/
else if mgmt=1 then mgmtmet=1;  /*mgmt methylated*/


/*cut off of mgmt lost*/;
if 0<MGMToverall<=1 then mgmtih=1; /*MGMT IHC loss*/
else if 2<=MGMToverall<=4 then mgmtih=0; /*MGMT IHC pos*/

/* CDK8 cutoff*/ 
if cdk8noverall >=2 and cdk8cyto >=3 then cdk8d =3;
else if cdk8noverall >=2                  then cdk8d =2;
else if cdk8noverall = 1                  then cdk8d =1;

if cdk8d>=2 then cdk8f=1; /*CDK8 pos*/
else if cdk8d=1 then cdk8f=0; /*CDK8 neg*/


/*p53sub1 definition for TMA12*/
 if     3<=p53tma121overall<=4 and 50=<p53tma121perc <=100 then p53sub1= 5;
else if 3<=p53tma121overall<=4 and 30=<p53tma121perc < 50 then p53sub1= 4;
else if 3<=p53tma121overall<=4 and 0=<p53tma121perc < 30 then p53sub1= 3;
else if p53tma121overall =2 and 50=<p53tma121perc <=100 then p53sub1= 2;
else if p53tma121overall=2  and 0=<p53tma121perc < 50 then p53sub1= 1;
else if p53tma121overall=1  then p53sub1= 0;

/*p53sub2 definition for TMA12*/
if      3<=p53tma122overall<=4 and 50=<p53tma122perc <=100 then p53sub2= 5;
else if 3<=p53tma122overall<=4 and 30=<p53tma122perc < 50 then p53sub2= 4;
else if 3<=p53tma122overall<=4 and 0=<p53tma122perc < 30 then p53sub2= 3;
else if p53tma122overall =2 and 50=<p53tma122perc <=100 then p53sub2= 2;
else if p53tma122overall=2  and 0=<p53tma122perc < 50 then p53sub2= 1;
else if p53tma122overall=1  then p53sub2= 0;

p53TMA12score=(p53sub1+p53sub2)/2;
if p53sub1=. and p53tma122BlockSlideNo=12 then p53TMA12score=p53sub2;
if p53sub2=. and p53tma121BlockSlideNo=12 then p53TMA12score=p53sub1;

/*p53 definition for TMA12*/
if p53TMA12score>=4.5 then p53g=2;/*p53 pos*/
else if  0<=p53TMA12score<=4.0 then p53g=1;/*p53 neg*/

/*p53 nonTMA12*/
	 if    p53IHCoverall>=3 and   p53IHCpos>=50 then p53g=2; /*p53 pos*/
else if 1<=p53IHCoverall<=2 or 0<=p53IHCpos <50 then p53g=1; /*p53 neg*/

/*p53 new*/
	 if    p53newIHCoverall>=3 and   p53newIHCpos>=50 then p53g=2; /*p53 pos*/
else if 1<=p53newIHCoverall<=2 or 0<=p53newIHCpos <50 then p53g=1; /*p53 neg*/

/* TP53 */
if p53g=2 then p53b=1; else if p53g=1 then p53b=0; 
if p53g=2 then p53pos=1; else p53pos=0; 


/*pik3ca mutation*/
/*categorize 4 groups (including flag); wt, ex1, ex9, ex20*/
     if  PIK3CA20mut=1      then pik3ca3=3;
else if  PIK3CA9mut=1       then pik3ca3=2; 
else if  PIK3CA1mut=1       then pik3ca3=1;
else if pikwt=1 and pikmt=0 then pik3ca3=0;
%indic3(vbl=pik3ca3, prefix=pik3ca3, min=1, max=3, reflev=0, missing=., usemiss=1,label1='pik3ca ex1', 
label2='pik3ca ex9', label3='pik3ca ex20');

/*categorize 3 groups (including flag); wt, ex1, ex9&20*/
     if  PIK3CA20mut=1       then pik3ca2=2;
else if  PIK3CA9mut=1        then pik3ca2=2; 
else if  PIK3CA1mut=1        then pik3ca2=1;
else if  pikwt=1 and pikmt=0 then pik3ca2=0;
%indic3(vbl=pik3ca2, prefix=pik3ca2, min=1, max=2, reflev=0, missing=., usemiss=1,label1='pik3ca ex1', 
label2='pik3ca ex9&20');

/*categorize 2 groups (including flag); wt&ex1, ex9&20*/
	 if pik3ca3 >1    then pik3ca=1;
else if 0<= pik3ca3 <=1 then pik3ca=0;
%indic3(vbl=pik3ca, prefix=pik3ca, min=1, max=1, reflev=0, missing=., usemiss=1,label1='pik3ca ex9&20');
if pik3ca=1 then pik=1; else pik=0; 


/*DNMT3B*/
     if 30<=dnmt3bposnuclear <=100                            then dnmt3ba=2; 
else if dnmt3boverallnuclear=1                                then dnmt3ba=1; 
else if 2<=dnmt3boverallnuclear<=4 and 0<=dnmt3bposnuclear<30 then dnmt3ba=0;
 if  0<= dnmt3ba <=1 then dnmt3b=0; /*dnmt3b neg*/
else if  dnmt3ba  =2  then dnmt3b=1; /*dnmt3b pos*/


/*STMN1*/
     if  stmnoverall =1                          then stmn=0;
else if  stmnwkstrongperc <20 and stmnoverall =2 then stmn=1;
else if  stmnwkstrongperc >=20                   then stmn=2; 
if  0<= stmn <=1 then stmn1=0; /*stmn1 neg*/
else if  stmn=2  then stmn1=1; /*stmn1 pos*/


/*JCVT*/
     if 2<=jcvtoverallnuc<=4 then jcvt=1; /*jcvt pos*/
else if    jcvtoverallnuc =1 then jcvt=0; /*jcvt neg*/


/*CCND1*/   
     if 2<=CCND1strongest<=4	 then ccnd1s=1;
else if 2<=CCND1strongest1314<=4 then ccnd1s=1; /*CCND1 for survival pos*/
else if    CCND1strongest=1     then ccnd1s=0; 
else if    CCND1strongest1314=1 then ccnd1s=0; /*CCND1 for survival neg*/

     if 3<=CCND1overall<=4 and CCND1wkstrongperc >=20 then ccnda=3; 
else if 3<=CCND1overall1314<=4 and CCND1CAwsperc >=20 then ccnda=3; 
else if    CCND1overall=2 and CCND1wkstrongperc  >=50 then ccnda=2; 
else if    CCND1overall1314=2 and CCND1CAwsperc  >=50 then ccnda=2; 
else if    CCND1overall=2 and CCND1wkstrongperc   <50 then ccnda=1;
else if    CCND1overall1314=2 and CCND1CAwsperc   <50 then ccnda=1;
else if    CCND1overall=1                             then ccnda=0;
else if    CCND1overall1314=1                         then ccnda=0;


     if  2<= ccnda <=3 then ccnd1m=1; /*CCND1 for molecular pos*/
else if  0<= ccnda <=1 then ccnd1m=0; /*CCND1 for molecular neg*/



/*VDR*/
     if vdrtma121strong >= 3    then vdr=1; /*vdr pos*/
else if vdrtma121strong=2 and vdrtma121percentpos >=50 then vdr=1; /*vdr pos*/
else if vdrtma121strong=2 and vdrtma121percentpos <50 then vdr=0; /*vdr neg*/
else if vdrtma121strong=1 then vdr=0; /*vdr neg*/

     if vdrstrongest >= 3 then vdr=1; /*vdr pos*/
else if vdrstrongest=2 and vdrpercentpos >=50 then vdr=1; /*vdr pos*/
else if vdrstrongest=2 and vdrpercentpos <50 then vdr=0; /*vdr neg*/
else if vdrstrongest=1  then vdr=0; /*vdr neg*/



/*RPS6*/
     if RPS6Overall = 4                                                   then rps6s6= 2;
else if RPS6Overall = 3 and                       50=<RPS6wk_strperc<=100 then rps6s6= 2;
else if RPS6Overall = 3 and                       20=<RPS6wk_strperc < 50 then rps6s6= 2;
else if RPS6Overall = 3 and                       0=< RPS6wk_strperc < 20 then rps6s6= 2;
else if RPS6Overall = 2 and RPS6Strongest >=3 and 50=<RPS6wk_strperc<=100 then rps6s6= 2;
else if RPS6Overall = 2 and RPS6Strongest >=3 and 20=<RPS6wk_strperc < 50 then rps6s6= 1;
else if RPS6Overall = 2 and RPS6Strongest >=3 and 0=< RPS6wk_strperc < 20 then rps6s6= 1;
else if RPS6Overall = 2 and RPS6Strongest = 2 and 50=<RPS6wk_strperc <100 then rps6s6= 2;
else if RPS6Overall = 2 and RPS6Strongest = 2 and 20=<RPS6wk_strperc < 50 then rps6s6= 1;
else if RPS6Overall = 2 and RPS6Strongest = 2 and 0=< RPS6wk_strperc < 20 then rps6s6= 1;
else if RPS6Overall = 1                                                   then rps6s6= 1; 
     if rps6s6=2 then rps6=1; /*rps6 pos*/
else if rps6s6=1 then rps6=0; /*rps6 neg*/


/*T-cell subsets (CD3, CD8, PTPRC/CD45RO, FOXP3)*/
/*cancer neoplastic cell region quartile*/
if       nuclei_ca_cd3 >=580.72    then cd3quart=3;
if 244.97=< nuclei_ca_cd3 <580.72  then cd3quart=2;
if 86.27=< nuclei_ca_cd3 <244.97 then cd3quart=1; 
if      0=< nuclei_ca_cd3 <86.27   then cd3quart=0;

if       nuclei_ca_cd8 >=646.4    then cd8quart=3;
if 236.65=< nuclei_ca_cd8 <646.4  then cd8quart=2;
if 76.68=< nuclei_ca_cd8 <236.65 then cd8quart=1; 
if      0=< nuclei_ca_cd8 <76.68   then cd8quart=0;

if       nuclei_ca_cd45 >=726.55    then cd45roquart=3;
if 376.97=< nuclei_ca_cd45 <726.55  then cd45roquart=2;
if 158.66=< nuclei_ca_cd45 <376.97 then cd45roquart=1; 
if      0=< nuclei_ca_cd45 <158.66   then cd45roquart=0;

if       nuclei_ca_foxp3 >=48.07    then foxp3quart=3;
if 26.36=< nuclei_ca_foxp3 <48.07  then foxp3quart=2;
if 13.56=< nuclei_ca_foxp3 <26.36 then foxp3quart=1; 
if      0=< nuclei_ca_foxp3 <13.56   then foxp3quart=0;

%indic3(vbl=cd3quart, prefix=cd3quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4'); 
%indic3(vbl=cd8quart, prefix=cd8quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4'); 
%indic3(vbl=cd45roquart, prefix=cd45roquart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4');
%indic3(vbl=foxp3quart, prefix=foxp3quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4');

/*stroma region quartile*/
if       nuclei_sa_cd3 >=461.5    then scd3quart=3;
if 209.8=< nuclei_sa_cd3 <461.5  then scd3quart=2;
if 85=< nuclei_sa_cd3 <209.8 then scd3quart=1; 
if      0=< nuclei_sa_cd3 <85   then scd3quart=0;

if       nuclei_sa_cd8 >=330.5    then scd8quart=3;
if 140.2=< nuclei_sa_cd8 <330.5  then scd8quart=2;
if 49.4=< nuclei_sa_cd8 <140.2 then scd8quart=1; 
if      0=< nuclei_sa_cd8 <49.4   then scd8quart=0;

if       nuclei_sa_cd45 >=917.9    then scd45roquart=3;
if 414.9=< nuclei_sa_cd45 <917.9  then scd45roquart=2;
if 169.4=< nuclei_sa_cd45 <414.9 then scd45roquart=1; 
if      0=< nuclei_sa_cd45 <169.4   then scd45roquart=0;

if       nuclei_sa_foxp3 >=46.2   then sfoxp3quart=3;
if 22.1=< nuclei_sa_foxp3 <46.2  then sfoxp3quart=2;
if 9.8=< nuclei_sa_foxp3 <22.1 then sfoxp3quart=1; 
if      -300=< nuclei_sa_foxp3 <9.8   then sfoxp3quart=0;

%indic3(vbl=scd3quart, prefix=scd3quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4'); 
%indic3(vbl=scd8quart, prefix=scd8quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4'); 
%indic3(vbl=scd45roquart, prefix=scd45roquart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4');
%indic3(vbl=sfoxp3quart, prefix=sfoxp3quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4');

/*whole core quartile*/
if       nuclei_wa_cd3 >=512.4    then wcd3quart=3;
if 239.1=< nuclei_wa_cd3 <512.4  then wcd3quart=2;
if 100=< nuclei_wa_cd3 <239.1 then wcd3quart=1; 
if      0=< nuclei_wa_cd3 <100   then wcd3quart=0;

if       nuclei_wa_cd8 >=448.7    then wcd8quart=3;
if 184.4=< nuclei_wa_cd8 <448.7  then wcd8quart=2;
if 66.2=< nuclei_wa_cd8 <184.4 then wcd8quart=1; 
if      0=< nuclei_wa_cd8 <66.2   then wcd8quart=0;

if       nuclei_wa_cd45 >=910.0    then wcd45roquart=3;
if 429.4=< nuclei_wa_cd45 <910.0  then wcd45roquart=2;
if 188.9=< nuclei_wa_cd45 <429.4 then wcd45roquart=1; 
if      0=< nuclei_wa_cd45 <188.9   then wcd45roquart=0;

if       nuclei_wa_foxp3 >=50.0    then wfoxp3quart=3;
if 25.5=< nuclei_wa_foxp3 <50.0  then wfoxp3quart=2;
if 14.2=< nuclei_wa_foxp3 <25.5   then wfoxp3quart=1; 
if      0=< nuclei_wa_foxp3 <14.2   then wfoxp3quart=0;

%indic3(vbl=wcd3quart, prefix=wcd3quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4'); 
%indic3(vbl=wcd8quart, prefix=wcd8quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4'); 
%indic3(vbl=wcd45roquart, prefix=wcd45roquart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4');
%indic3(vbl=wfoxp3quart, prefix=wfoxp3quart, min=1, max=3, reflev=0, missing=.,usemiss=1,
        label1='meanscoreq2', label2='meanscoreq3', label3='meanscoreq4');

/*cancer neoplastic cell region dichotomy*/
if       nuclei_ca_cd3 >=244.97     then cd3di=1;
if      0=< nuclei_ca_cd3 <244.97   then cd3di=0;

if       nuclei_ca_cd8 >=236.65     then cd8di=1;
if      0=< nuclei_ca_cd8 <236.65   then cd8di=0;

if       nuclei_ca_cd45 >=726.55    then cd45rodi=1;
if      0=< nuclei_ca_cd45 <726.55  then cd45rodi=0;

if       nuclei_ca_foxp3 >=26.36    then foxp3di=1;
if      0=< nuclei_ca_foxp3 <26.36  then foxp3di=0;


/* CTNNB1 (beta-catenin) read by Teppei Morikawa (JAMA 2011) */

/*CTNNB1 for TMAnon12*/
     if    bcateoverallcytoTMnon12  =1  then ctbc4TM=1; 
else if    bcateoverallcytoTMnon12  =2  then ctbc4TM=2;  
else if    bcateoverallcytoTMnon12  =3  then ctbc4TM=3; 
else if    bcateoverallcytoTMnon12  =4  then ctbc4TM=4; 

     if    bcateoverallnucTMnon12  =1  then ctbn4TM=1; 
else if    bcateoverallnucTMnon12  =2  then ctbn4TM=2;  
else if    bcateoverallnucTMnon12  =3  then ctbn4TM=3; 
else if    bcateoverallnucTMnon12  =4  then ctbn4TM=4; 

     if    bcateoverallmembTMnon12 =1 then ctmembTM=0; 
else if    bcateoverallmembTMnon12 =2 then ctmembTM=1; 
else if 3<=bcateoverallmembTMnon12<=4 then ctmembTM=2;

 /*CTNNB1 for TMA12 */
ctbc4TM12=(bcateoverallcytoTM121+bcateoverallcytoTM122)/2;
if bcateoverallcytoTM121=. and bcateoverallcytoTM122 ne . then ctbc4TM12=bcateoverallcytoTM122;
if bcateoverallcytoTM122=. and bcateoverallcytoTM121 ne . then ctbc4TM12=bcateoverallcytoTM121;

ctbn4TM12=(bcateoverallnuclearTM121+bcateoverallnuclearTM122)/2;
if bcateoverallnuclearTM121=. and bcateoverallnuclearTM122 ne . then ctbn4TM12=bcateoverallnuclearTM122;
if bcateoverallnuclearTM122=. and bcateoverallnuclearTM121 ne . then ctbn4TM12=bcateoverallnuclearTM121;

ctmembTM12=(bcateoverallmembTM121+bcateoverallmembTM122)/2;
if bcateoverallmembTM121=. and bcateoverallmembTM122 ne . then ctmembTM12=bcateoverallmembTM122;
if bcateoverallmembTM122=. and bcateoverallmembTM121 ne . then ctmembTM12=bcateoverallmembTM121;

 /*CTNNB1 non TMA */
     if    bcateoverallcytofullsec  =1  then ctbc4TMfull=1; 
else if    bcateoverallcytofullsec  =2  then ctbc4TMfull=2;  
else if    bcateoverallcytofullsec  =3  then ctbc4TMfull=3; 
else if    bcateoverallcytofullsec  =4  then ctbc4TMfull=4; 

     if    bcateoverallnuclearfullsec  =1  then ctbn4TMfull=1; 
else if    bcateoverallnuclearfullsec  =2  then ctbn4TMfull=2;  
else if    bcateoverallnuclearfullsec  =3  then ctbn4TMfull=3; 
else if    bcateoverallnuclearfullsec  =4  then ctbn4TMfull=4; 

if         bcateoverallmembfullsec =1 then ctmembTMfull=0; 
else if    bcateoverallmembfullsec =2 then ctmembTMfull=1; 
else if 3<=bcateoverallmembfullsec<=4 then ctmembTMfull=2;


 /* for nuclei4 total*/
     if    1<= ctbn4TMfull  < 1.5  then ctbn4total = 1;
else if    1<= ctbn4TM      < 1.5  then ctbn4total = 1;
else if    1<= ctbn4TM12    < 1.5  then ctbn4total = 1;
else if    bcateonucTM1314 = 1     then ctbn4total = 1; /* nuclear CTNNB1, negative */
else if  1.5<= ctbn4TMfull  < 2.5  then ctbn4total = 2;
else if  1.5<= ctbn4TM      < 2.5  then ctbn4total = 2;
else if  1.5<= ctbn4TM12    < 2.5  then ctbn4total = 2;
else if    bcateonucTM1314 = 2     then ctbn4total = 2; /* nuclear CTNNB1, weak */
else if  2.5<= ctbn4TMfull  < 3.5  then ctbn4total = 3;
else if  2.5<= ctbn4TM      < 3.5  then ctbn4total = 3;
else if  2.5<= ctbn4TM12    < 3.5  then ctbn4total = 3;
else if    bcateonucTM1314 = 3     then ctbn4total = 3; /* nuclear CTNNB1, moderate */
else if        ctbn4TMfull >= 3.5  then ctbn4total = 4;
else if        ctbn4TM     >= 3.5  then ctbn4total = 4;
else if        ctbn4TM12   >= 3.5  then ctbn4total = 4;
else if    bcateonucTM1314 = 4     then ctbn4total = 4; /* nuclear CTNNB1, strong */


 /* for nuclei2 total*/
     if    ctbn4total = 1 then ctbn2total = 0;
else if    ctbn4total = 2 then ctbn2total = 0; /* nuclear CTNNB1, negative */
else if    ctbn4total = 3 then ctbn2total = 1;
else if    ctbn4total = 4 then ctbn2total = 1; /* nuclear CTNNB1, positive */

     if    ctbn2total = 0 then ctnnb1nuc = 0;/* nuclear CTNNB1, negative */
else if    ctbn2total = 1 then ctnnb1nuc = 1;/* nuclear CTNNB1, positive */




 /* for cyto4 total*/
     if    1<= ctbc4TMfull  < 1.5  then ctbc4total = 1;
else if    1<= ctbc4TM      < 1.5  then ctbc4total = 1;
else if    1<= ctbc4TM12    < 1.5  then ctbc4total = 1;
else if    bcateocytoTM1314 = 1    then ctbc4total = 1; /* cytoplasmic CTNNB1, negative */
else if  1.5<= ctbc4TMfull  < 2.5  then ctbc4total = 2;
else if  1.5<= ctbc4TM      < 2.5  then ctbc4total = 2;
else if  1.5<= ctbc4TM12    < 2.5  then ctbc4total = 2; 
else if    bcateocytoTM1314 = 2    then ctbc4total = 2; /* cytoplasmic CTNNB1, weak */
else if  2.5<= ctbc4TMfull  < 3.5  then ctbc4total = 3;
else if  2.5<= ctbc4TM      < 3.5  then ctbc4total = 3;
else if  2.5<= ctbc4TM12    < 3.5  then ctbc4total = 3; 
else if    bcateocytoTM1314 = 3    then ctbc4total = 3; /* cytoplasmic CTNNB1, moderate */
else if        ctbc4TMfull >= 3.5  then ctbc4total = 4;
else if        ctbc4TM     >= 3.5  then ctbc4total = 4;
else if        ctbc4TM12   >= 3.5  then ctbc4total = 4; 
else if    bcateocytoTM1314 = 4    then ctbc4total = 4; /* cytoplasmic CTNNB1, strong */

 /* for cyto2 total*/
     if    ctbc4total = 1 then ctbc2total = 0;
else if    ctbc4total = 2 then ctbc2total = 0; /* cytoplasmic CTNNB1, negative */
else if    ctbc4total = 3 then ctbc2total = 1;
else if    ctbc4total = 4 then ctbc2total = 1; /* cytoplasmic CTNNB1, positive */

     if    ctbc2total = 0 then ctnnb1cyto = 0;/* cytoplasmic CTNNB1, negative */
else if    ctbc2total = 1 then ctnnb1cyto = 1;/* cytoplasmic CTNNB1, positive */




 /* for memb3 total*/
     if    0<= ctmembTMfull  < 1  then memb3total = 2;
else if    0<= ctmembTM      < 1  then memb3total = 2;
else if    0<= ctmembTM12    < 1  then memb3total = 2; 
else if    bcateomembTM1314  = 1  then memb3total = 2; /*membrane CTNNB1,negative (loss)*/
else if  1<= ctmembTMfull  < 2  then memb3total = 1;
else if  1<= ctmembTM      < 2  then memb3total = 1;
else if  1<= ctmembTM12    < 2  then memb3total = 1; 
else if    bcateomembTM1314 = 2 then memb3total = 1; /* membrane CTNNB1, weak */
else if        ctmembTMfull >= 2  then memb3total = 0;
else if        ctmembTM     >= 2  then memb3total = 0;
else if        ctmembTM12   >= 2  then memb3total = 0; 
else if   bcateomembTM1314  >= 3  then memb3total = 0; /* membrane CTNNB1, positive (intact) */

 /* for memb2 total*/
     if    memb3total = 2 then memb2total = 1; /*membrane CTNNB1, loss*/
else if    memb3total = 1 then memb2total = 1; /*membrane CTNNB1, loss*/
else if    memb3total = 0 then memb2total = 0; /*membrane CTNNB1, intact*/

     if    memb2total = 0 then ctnnb1memb = 0;/*membrane CTNNB1, intact*/
else if    memb2total = 1 then ctnnb1memb = 1; /*membrane CTNNB1, loss*/


/* for Jass score */
       if    ctbc4total = 1 then ctbcjass = 0;
else   if    ctbc4total = 2 then ctbcjass = 1;
else   if    ctbc4total = 3 then ctbcjass = 2;
else   if    ctbc4total = 4 then ctbcjass = 2;

       if    ctbn4total = 1 then ctbnjass = 0;
else   if    ctbn4total = 2 then ctbnjass = 1;
else   if    ctbn4total = 3 then ctbnjass = 2;
else   if    ctbn4total = 4 then ctbnjass = 2;

       if     memb3total = 2 then membjass = 1;
else   if     memb3total = 1 then membjass = 1;
else   if     memb3total = 0 then membjass = 0;

jassscore = ctbcjass + ctbnjass + membjass; /* Jass score.  Jass et al. J Clin Pathol 1999 */

/* Nuclear CTNNB1, missing=> majority category */
if ctbn2total=1 then ctnnb1pos=1; else ctnnb1pos=0; 


/*p-STAT3*/
if stat3strongestnuc = 1  then stat3scat3=1; /*negative*/
else if stat3strongestnuc = 2 then stat3scat3=2; /*weak*/
else if 3<=stat3strongestnuc<=4 then stat3scat3=3; /*moderate to strong*/

/*STAT3 TMA12*/
if 1<=STAT3TMA121strongestnuclear<=4 or 1<=STAT3TMA122strongestnuclear<=4 
then STAT3TMA12 =  (STAT3TMA121strongestnuclear + STAT3TMA122strongestnuclear)/2;

if stat3strongestnuc=. and STAT3TMA121strongestnuclear=. and STAT3TMA122strongestnuclear ne . then STAT3TMA12=STAT3TMA122strongestnuclear;
if stat3strongestnuc=. and STAT3TMA122strongestnuclear=. and STAT3TMA121strongestnuclear ne . then STAT3TMA12=STAT3TMA121strongestnuclear;

if  STAT3TMA12=1 then stat3scat3=1; /*negative*/
else if STAT3TMA12=1.5  then stat3scat3=2; /*weak*/
else if STAT3TMA12=>2 then stat3scat3=3; /*moderate to strong*/
%indic3(vbl=stat3scat3, prefix=stat3scat3, min=2, max=3, reflev=1, missing=.,usemiss=0,
label1='neg', label2='weak', label3='mod to strong'); 


/*definition STAT3 2 category*/
if stat3scat3=1 then stat3=1;  /*negative*/
else if 2<=stat3scat3<=3 then stat3=2;   /*positive*/


/*CDH1*/
    if 1<=CDH1overallmem<=2 then CDH1mem=1; /*loss*/
else if 3<=CDH1overallmem<=4 then CDH1mem=0; /*pos*/


/*CDH1 TMA12*/
if CDH1overallmem=. then CDH1TMA12 = (CDH1TMA121overallmem + CDH1TMA122overallmem)/2;

if CDH1overallmem=. and CDH1TMA121overallmem=. and CDH1TMA122overallmem ne . then CDH1TMA12=CDH1TMA122overallmem;
if CDH1overallmem=. and CDH1TMA122overallmem=. and CDH1TMA121overallmem ne . then CDH1TMA12=CDH1TMA121overallmem;

     if 1<=CDH1TMA12<=2 then CDH1mem=1; /*loss*/
else if 2.5<=CDH1TMA12<=4 then CDH1mem=0; /*pos*/



/* CDKN1A (p21, CIP1) */
	 if    p21overall = 1                      then p21d=2; 
else if    p21overall = 2					   then p21d=2; 
else if    p21overall = 3 and 0<= p21perc <20  then p21d=2; 
else if    p21overall = 3 and     p21perc>=20  then p21d=1;
else if    p21overall = 4					   then p21d=1; 
     if p21d=2 then p21=1; else if p21d=1 then p21=0;
	 if p21=1 then p21loss=1; else p21loss=0; 

/* CDKN1B (p27, KIP1)*/
	 if    p27Noverall = 1                      then p27nb=1; 
else if 2<=p27Noverall<= 4 and 0<= p27Nperc <10 then p27nb=1; 
else if 2<=p27Noverall<= 4 and 10<=p27Nperc <20 then p27nb=2; 
else if 2<=p27Noverall<= 4 and     p27Nperc>=20 then p27nb=3; 

     if    p27nb =3             then p27nuc=0; /* nuclear positive */
else if 1<=p27nb<=2             then p27nuc=1; /* nuclear loss */ 

if    p27Coverall =1 then p27cb=1; /* cyto negative */
if p27Coverall>=2    then p27cb=2; /* cyto positive */

     if                 p27cb=2	then p27a=1; /* altered */
else if 1<=p27nb<=2             then p27a=1; 
else if    p27nb =3             then p27a=0; /* nuclear positive. ref */
if p27a=1 then p27=1; else p27=0; 

if p27cb=2 then p27d=2; /* cyto positive */
else if p27cb=1 and  p27nb =3 then p27d=1; /* nuclear positive */
else if p27cb=1 and  1<=p27nb<=2 then p27d=0; /* loss */



/*cimp*/
if cimphigh=1 then cimp=1; else cimp=0; 

/*msi*/
if msin=1 then msi=1; else msi=0; 

/*braf*/
if brafmt=1 then braf=1; else braf=0; 

/*kras*/

if Kras12mut=1 or Kras13mut=1 or Kras61mut=1 or Kras146mut=1 then krasmut4=1; /* all krasmut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krasmut4=0; /* allWT */

%indic3(vbl=krasmut4, prefix=krasmut4, min=0, max=1, reflev=0, usemiss=0,
        label0='wt', label1='kras mutation');

if Kras12mutgt=1 then krasmut6=1;
else if Kras12mutgt=0 and Kras13mut=1 and Kras61mut=1 and Kras146mut=1 then krasmut6=0;

%indic3(vbl=krasmut6, prefix=krasmut6, min=0, max=1, reflev=0, usemiss=0,
        label1='Kras12mutgt', label0='other than Kras12mutgt');

if Kras12mutgt=1 then krasmut6=1;
else if Kras12mutgt=0 and Kras13mut=1 and Kras61mut=1 and Kras146mut=1 then krasmut6=0;


if mutate =1 then kras=1; else kras =0; 

if Kras12mut=1 or Kras13mut=1 or Kras61mut=1 or Kras146mut=1 then krasmut5=1;
else if Kras12mut=0 and Kras13mut=0 then krasmut5=0;

if Kras12mutgt=1 then krasmut6=1;
else if Kras12mutgt=0 and Kras13mut=1 and Kras61mut=1 and Kras146mut=1 then krasmut6=0;

/*kras mutation defined by codons 12, 13, 61 and 146 status*/
if Kras12mut=1 or Kras13mut=1 or Kras61mut=1 or Kras146mut=1 then mutate=1;
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then mutate=2;

if mutate=1 then krasmut=1; 
else if mutate=2 then krasmut=0; 
%indic3(vbl=krasmut, prefix=krasmut, min=1, max=1, reflev=0, usemiss=0,
        label0='wt', label1='kras mutation');

if mutate=1 then kras=1; else kras =0; 
/*kras mutation defined by codons 12, 13, 61 and 146 status*/
if Kras12mut=1 or Kras13mut=1 or Kras61mut=1 or Kras146mut=1 then mutate=1;
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then mutate=2;

if mutate=1 then krasmut=1; 
else if mutate=2 then krasmut=0; 
%indic3(vbl=krasmut, prefix=krasmut, min=1, max=1, reflev=0, usemiss=0,
        label0='wt', label1='kras mutation');

if mutate=1 then kras=1; else kras =0; 



/*kras all codons mutation */
	 if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krasall=0; /* allWT */
else if Kras12mut=1 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krasall=1; /* 12mut */
else if Kras12mut=0 and Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then krasall=2; /* 13mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then krasall=3; /* 61mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then krasall=4; /* 146mut */
else if Kras12mut=1 and Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then krasall=5; /* 12&13mut */
else if Kras12mut=1 and Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then krasall=6; /* 12&61mut */
else if Kras12mut=1 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then krasall=7; /* 12&146mut */
else if Kras12mut=0 and Kras13mut=1 and Kras61mut=1 and Kras146mut=0 then krasall=8; /* 13&61mut */
else if Kras12mut=0 and Kras13mut=1 and Kras61mut=0 and Kras146mut=1 then krasall=9; /* 13&146mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras146mut=1 then krasall=10; /* 61&146mut */
else if Kras12mut=1 and Kras13mut=1 and Kras61mut=1 and Kras146mut=0 then krasall=11; /* 12&13&61mut */
else if Kras12mut=1 and Kras13mut=1 and Kras61mut=0 and Kras146mut=1 then krasall=12; /* 12&13&146mut */
else if Kras12mut=1 and Kras13mut=0 and Kras61mut=1 and Kras146mut=1 then krasall=13; /* 12&61&146mut */
else if Kras12mut=0 and Kras13mut=1 and Kras61mut=1 and Kras146mut=1 then krasall=14; /* 13&61&146mut */
else if Kras12mut=1 and Kras13mut=1 and Kras61mut=1 and Kras146mut=1 then krasall=15; /* 12&13&61&146mut */

%indic3(vbl=krasall, prefix=krasall, min=1, max=15, reflev=0, usemiss=0,
label0='allWT', 
label1='12mut', 
label2='13mut', 
label3='61mut',
label4='146mut',
label5='12&13mut',
label6='12&61mut', 
label7='12&146mut', 
label8='13&61mut',
label9='13&146mut',
label10='61&146mut', 
label11='12&13&61mut', 
label12='12&13&146mut',
label13='12&61&146mut',
label14='13&61&146mut',
label15='12&13&61&146mut');



/*kras 4 codons mutation */
	 if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then kras4=0; /* allWT */
else if Kras12mut=1 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then kras4=1; /* 12mut */
else if Kras12mut=0 and Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then kras4=2; /* 13mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then kras4=3; /* 61mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then kras4=4; /* 146mut */

%indic3(vbl=kras4, prefix=kras4, min=1, max=4, reflev=0, usemiss=0,
label0='allWT',
label1='12mut', 
label2='13mut', 
label3='61mut',
label4='146mut');


/*kras 4 codons mutation */
	 if brafmt=0 and Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then kras4b=0; /* allWT */
else if brafmt=0 and Kras12mut=1 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then kras4b=1; /* 12mut */
else if brafmt=0 and Kras12mut=0 and Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then kras4b=2; /* 13mut */
else if brafmt=0 and Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then kras4b=3; /* 61mut */
else if brafmt=0 and Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then kras4b=4; /* 146mut */
else if brafmt=1 and Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then kras4b=5; /* brafmut */

%indic3(vbl=kras4b, prefix=kras4b, min=0, max=5, reflev=0, usemiss=0,
label0='kwtbwt',
label1='12mut', 
label2='13mut', 
label3='61mut',
label4='146mut',
label5='brafmut');




/*kras mutation 12or13 vs 61or146*/
	 if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k1213_61146=0; /* allWT */
else if Kras12mut=1 or  Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then k1213_61146=1; /*12 or 13 mutaion*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 or  Kras146mut=1 then k1213_61146=2; /*61 or 146 mutaion*/
%indic3(vbl=k1213_61146, prefix=k1213_61146, min=1, max=2, reflev=0, usemiss=0,
        label0='allWT', label1='12or13 mutation', label2='61or146 mutation');



/*kras mutation 12 vs 13or61or146*/
	 if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k12_1361146=0; /* allWT */
else if Kras12mut=1 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k12_1361146=1; /*12 mutaion*/
else if Kras12mut=0 and Kras13mut=1 or  Kras61mut=1 or  Kras146mut=1 then k12_1361146=2; /*13or61or146 mutaion*/
%indic3(vbl=k12_1361146, prefix=k12_1361146, min=1, max=2, reflev=0, usemiss=0,
        label0='allWT', label1='12 mutation', label2='13or61or146 mutation');


/*kras mutation 12or13or61 vs 146*/
	 if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k121361_146=0; /* allWT */
else if Kras12mut=1 or  Kras13mut=1 or  Kras61mut=1 and Kras146mut=0 then k121361_146=1; /*12or13or61 mutation*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then k121361_146=2; /*146 mutation*/
%indic3(vbl=k121361_146, prefix=k121361_146, min=1, max=2, reflev=0, usemiss=0,
        label0='allWT', label1='12or13or61 mutation', label2='146 mutation');




/*only 4 codons mutation */
	 if Kras12mut=1 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then only4mut=0; /* 12mut */
else if Kras12mut=0 and Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then only4mut=1; /* 13mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then only4mut=2; /* 61mut */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then only4mut=3; /* 146mut */

%indic3(vbl=only4mut, prefix=only4mut, min=1, max=3, reflev=0, usemiss=0,
label0='12mut', 
label1='13mut', 
label2='61mut',
label3='146mut');


/*only 12or13 vs 61 vs 146*/
	 if Kras12mut=1 or  Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then only1213_61_146=0; /* 12 or 13 mutaion*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then only1213_61_146=1; /* 61 mutaion*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then only1213_61_146=2; /* 146 mutaion*/
%indic3(vbl=only1213_61_146, prefix=only1213_61_146, min=1, max=2, reflev=0, usemiss=0,
        label0='12or13 mutation', label1='61 mutation', label2='146 mutation');


/*only 12or13or61 vs 146*/
	 if Kras12mut=1 or  Kras13mut=1 or Kras61mut=1 and Kras146mut=0 then only121361_146=0; /* 12 or 13 or 61 mutaion*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then only121361_146=1; /* 146 mutaion*/
%indic3(vbl=only121361_146, prefix=only121361_146, min=1, max=1, reflev=0, usemiss=0,
        label0='12or13or61 mutation', label1='146 mutation');



/*only 12or13 vs 61or146*/
	 if Kras12mut=1 or  Kras13mut=1 and Kras61mut=0 and Kras146mut=0 then only1213_61146=0; /*12 or 13 mutaion*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 or  Kras146mut=1 then only1213_61146=1; /*61 or 146 mutaion*/
%indic3(vbl=only1213_61146, prefix=only1213_61146, min=1, max=1, reflev=0, usemiss=0,
        label0='12or13 mutation', label1='61or146 mutation');



/*only 12or13 vs 61or146*/
	 if Kras61mut=1 and Kras146mut=0 then only61146=0; /*61 mutaion*/
else if Kras61mut=0 and Kras146mut=1 then only61146=1; /*146 mutaion*/
%indic3(vbl=only61146, prefix=only61146, min=1, max=1, reflev=0, usemiss=0,
        label0='61 mutation', label1='146 mutation');



/*61 or 146*/
	 if Kras12mut=0 and  Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then wt61146=0; /*wt*/
else if Kras12mut=0 and  Kras13mut=0 and Kras61mut=1 and Kras146mut=0 then wt61146=1; /*61 mutation*/
else if Kras12mut=0 and  Kras13mut=0 and Kras61mut=0 and Kras146mut=1 then wt61146=2; /*146 mutation*/
%indic3(vbl=wt61146, prefix=wt61146, min=1, max=2, reflev=0, usemiss=0,
        label0='wt', label1='61 mutation', label2='146 mutation');



/*61 or 146*/
	 if Kras61mut=0 and Kras146mut=0 then k61146=0; /*wt*/
else if Kras61mut=1 or  Kras146mut=1 then k61146=1; /*61 or 146 mutation*/
%indic3(vbl=k61146, prefix=k61146, min=1, max=1, reflev=0, usemiss=0,
        label0='wt', label1='61 or 146 mutation');


/* counting all krasubtypes*/
	 if Kras12mut=1 and Kras12nuc = 'agt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=1; /* c.34G>A */
else if Kras12mut=1 and Kras12nuc = 'cgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=2; /* c.34G>C */
else if Kras12mut=1 and Kras12nuc = 'tgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=3; /* c.34G>T */
else if Kras12mut=1 and Kras12nuc = 'gat' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=4; /* c.35G>A */
else if Kras12mut=1 and Kras12nuc = 'gct' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=5; /* c.35G>C */
else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=6; /* c.35G>T */
else if Kras12mut=1 and Kras12nuc = 'gca' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then krascodonsuball=7; /* c.35_36delinsCA */

else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'cgc' and Kras61mut=0 and Kras146mut=0 then krascodonsuball=8; /* c.37G>C */
else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'tgc' and Kras61mut=0 and Kras146mut=0 then krascodonsuball=9; /* c.37G>T */
else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=0 and Kras146mut=0 then krascodonsuball=10; /* c.38G>A */
else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'gtc' and Kras61mut=0 and Kras146mut=0 then krascodonsuball=11; /* c.38G>T */

else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cga' and Kras146mut=0 then krascodonsuball=12; /* c.182A>G */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cta' and Kras146mut=0 then krascodonsuball=13; /* c.182A>T */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cac' and Kras146mut=0 then krascodonsuball=14; /* c.183A>C */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cat' and Kras146mut=0 then krascodonsuball=15; /* c.183A>T , but no event as single mutant*/
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'zzz' and Kras146mut=0 then krascodonsuball=16; /* c.180_181delinsAA */

else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then krascodonsuball=17; /* c.436G>A */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'cca' then krascodonsuball=18; /* c.436G>C */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'gta' then krascodonsuball=19; /* c.437C>T */


%indic3(vbl=krascodonsuball, prefix=krascodonsuball, min=1, max=19, reflev=1, usemiss=0,
label1='c.34G>A',
label2='c.34G>C',
label3='c.34G>T', 
label4='c.35G>A', 
label5='c.35G>C',
label6='c.35G>T', 
label7='c.35_36delinsCA',

label8='c.37G>C',
label9='c.37G>T',
label10='c.38G>A',
label11='c.38G>T',

label12='c.182A>G',
label13='c.182A>T',
label14='c.183A>C',
label15='c.183A>T'
label16='c.180_181delinsAA',

label17='c.436G>A',
label18='c.436G>C',
label19='c.437C>T');


/*counting multiple mutation */
	
	 if Kras12mut=1 and Kras12nuc = 'gat' and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=0 and Kras146mut=0 then krasmulti=1; /* c.35G>A & c.38G>A*/
else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=1 and Kras13nuc = 'tgc' and Kras61mut=0 and Kras146mut=0 then krasmulti=2; /* c.35G>T & c.37G>T*/

else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'zzz' and Kras146mut=0 then krasmulti=3; /* c.35G>T & c.180_181delinsAA */


else if Kras12mut=1 and Kras12nuc = 'cgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then krasmulti=4; /* c.34G>C & c.436G>A*/
else if Kras12mut=1 and Kras12nuc = 'tgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then krasmulti=5; /* c.34G>T & c.436G>A*/
else if Kras12mut=1 and Kras12nuc = 'tgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'gta' then krasmulti=6; /* c.34G>T & c.437C>T*/
else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then krasmulti=7; /* c.35G>T & c.436G>A*/

else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then krasmulti=8; /* c.38G>A & c.436G>A*/

else if Kras12mut=1 and Kras12nuc = 'gat' and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=1 and Kras61nuc = 'cat' and Kras146mut=0 then krasmulti=9; /* c.35G>A & c.38G>A & c.183A>T*/


%indic3(vbl=krasmulti, prefix=krasmulti, min=1, max=9, reflev=1, usemiss=0,
label1='c.35G>A & c.38G>A',
label2='c.35G>T & c.37G>T',
label3='c.35G>T & c.180_181delinsAA', 
label4='c.34G>C & c.436G>A',
label5='c.34G>T & c.436G>A', 
label6='c.34G>T & c.437C>T',
label7='c.35G>T & c.436G>A', 
label8='c.38G>A & c.436G>A',
label9='c.35G>A & c.38G>A & c.183A>T');


/*kras wt, single mutant and double mutant*/
  if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then kras_sd=0; /* allWT */ 
else if 1<=krascodonsuball<=19 then kras_sd=1; /* sigle mutation */ 	
else if 1<=krasmulti<=8 then kras_sd=2; /* double mutation */ 
 
%indic3(vbl=kras_sd, prefix=kras_sd, min=1, max=2, reflev=0, usemiss=0,
label0='wt',
label1='single',
label2='double');



/* codon12 counting all krasubtypes, including double mutant*/

     if Kras12mut=1 and Kras12nuc = 'agt' then k12codonsuball=1; /* c.34G>A */
else if Kras12mut=1 and Kras12nuc = 'cgt' then k12codonsuball=2; /* c.34G>C */
else if Kras12mut=1 and Kras12nuc = 'tgt' then k12codonsuball=3; /* c.34G>T */
else if Kras12mut=1 and Kras12nuc = 'gat' then k12codonsuball=4; /* c.35G>A */
else if Kras12mut=1 and Kras12nuc = 'gct' then k12codonsuball=5; /* c.35G>C */
else if Kras12mut=1 and Kras12nuc = 'gtt' then k12codonsuball=6; /* c.35G>T */
else if Kras12mut=1 and Kras12nuc = 'gca' then k12codonsuball=7; /* c.35_36delinsCA */
%indic3(vbl=k12codonsuball, prefix=k12codonsuball, min=1, max=7, reflev=1, usemiss=0,
label1='c.34G>A',label2='c.34G>C',label3='c.34G>T', label4='c.35G>A', label5='c.35G>C',label6='c.35G>T', 
label7='c.35_36delinsCA');

     if Kras12nuc = 'tgt' then tgtmut = 1;
    else tgtmut = 0;
%indic3(vbl=tgtmut, prefix=tgtmut, min=0,max=1,reflev=1, usemiss=0,
label0='other',label1='c.34G>T');


/*counting all mutaiton, wild type,c.34G>T,other kras mutations*/
	 if Kras12mut=0 				      and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=0; /* all WT */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=. and Kras146mut=.  then k_allkinds=0; /* 12,13 wild, 61,146 missing */
else if Kras12mut=1 and Kras12nuc = 'tgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=1; /* c.34G>T */
else if Kras12mut=1 and Kras12nuc = 'tgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then k_allkinds=2; /* c.34G>T & c.436G>A*/
else if Kras12mut=1 and Kras12nuc = 'tgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'gta' then k_allkinds=2; /* c.34G>T & c.437C>T*/

else if Kras12mut=1 and Kras12nuc = 'agt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.34G>A */
else if Kras12mut=1 and Kras12nuc = 'cgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.34G>C */

else if Kras12mut=1 and Kras12nuc = 'gat' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.35G>A */
else if Kras12mut=1 and Kras12nuc = 'gct' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.35G>C */
else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.35G>T */
else if Kras12mut=1 and Kras12nuc = 'gca' and Kras13mut=0 and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.35_36delinsCA */

else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'cgc' and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.37G>C */
else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'tgc' and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.37G>T */
else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.38G>A */
else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'gtc' and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.38G>T */

else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cga' and Kras146mut=0 then k_allkinds=2; /* c.182A>G */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cta' and Kras146mut=0 then k_allkinds=2; /* c.182A>T */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cac' and Kras146mut=0 then k_allkinds=2; /* c.183A>C */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'cat' and Kras146mut=0 then k_allkinds=2; /* c.183A>T, but no event as single mutant */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'zzz' and Kras146mut=0 then k_allkinds=2; /* c.180_181delinsAA */

else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then k_allkinds=2; /* c.436G>A */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'cca' then k_allkinds=2; /* c.436G>C */
else if Kras12mut=0 and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'gta' then k_allkinds=2; /* c.437C>T */



else if Kras12mut=1 and Kras12nuc = 'gat' and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.35G>A & c.38G>A*/
else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=1 and Kras13nuc = 'tgc' and Kras61mut=0 and Kras146mut=0 then k_allkinds=2; /* c.35G>T & c.37G>T*/

else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=0 and Kras61mut=1 and Kras61nuc = 'zzz' and Kras146mut=0 then k_allkinds=2; /* c.35G>T & c.180_181delinsAA */


else if Kras12mut=1 and Kras12nuc = 'cgt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then k_allkinds=2; /* c.34G>C & c.436G>A*/


else if Kras12mut=1 and Kras12nuc = 'gtt' and Kras13mut=0 and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then k_allkinds=2; /* c.35G>T & c.436G>A*/

else if Kras12mut=0 and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=0 and Kras146mut=1 and Kras146nuc = 'aca' then k_allkinds=2; /* c.38G>A & c.436G>A*/

else if Kras12mut=1 and Kras12nuc = 'gat' and Kras13mut=1 and Kras13nuc = 'gac' and Kras61mut=1 and Kras61nuc = 'cat' and Kras146mut=0 then k_allkinds=2; /* c.35G>A & c.38G>A & c.183A>T*/


%indic3(vbl=k_allkinds, prefix=k_allkinds, min=0, max=2, reflev=0, usemiss=0,
label0='wt and 12,13 wild, 61,146 missing',
label1='34gt',
label2='kras mut other than 34gt');


if 1=<IRS1cyto_overall<=2 then irs1b=0; /* IRS1 cyto negative */
if 3=<IRS1cyto_overall<=4 then irs1b=1; /* IRS1 cyto positive */

/* IRS-2 */
if 1=<IRS2cytooverall=<2 then irs2cyto2=0; /* IRS2 cyto negative */
if 3=<IRS2cytooverall=<4 then irs2cyto2=1; /* IRS2 cyto positive */


/* IGF2BP3 (IMP3) */
     if 1=<IGF2BP3overall=<2 then igf2bp3mod=0; /* negative */
else if IGF2BP3overall>=3 then igf2bp3mod=1; /* positive */


/*** PTGS2 (cox-2) ***/
if cox2allIHCoverall^=. then 
do; 
ptgs2raw=cox2allIHCoverall;
ptgs2method=1;
end;
else if cox2allIHCoverall=. and cox2newIHCoverall^=. then 
do; 
ptgs2raw=cox2newIHCoverall;
ptgs2method=2;
end;
else if cox2allIHCoverall=. and cox2newIHCoverall=. then 
do;
ptgs2raw=max(cox2tma121overall,cox2tma122overall);
ptgs2method=3;
end;

     if 1=<ptgs2raw<=2 or 1=<ptgs2tma1314overall<=2 then ptgs2=0; /*ptgs2(cox-2) negative*/
else if 3=<ptgs2raw<=4 or 3=<ptgs2tma1314overall<=4 then ptgs2=1; /*ptgs2(cox-2) positive*/


/* FASN4 Ogino et al. JCO 2008 */
/*fasn TMA12*/
if fasntma121overall=4 or fasntma122overall=4 then fasn4=1;
else if 1<=fasntma121overall<=3 or 1<=fasntma122overall<=3 then fasn4=0;

if fasnIHCoverall =4 then fasn4=1; /*FASN strong pos*/
else if 1<=fasnIHCoverall<=3 then fasn4=0; /*FASN neg-mod*/

if fasnnewIHCoverall =4 then fasn4=1; /*FASN strong pos*/
else if 1<=fasnnewIHCoverall<=3 then fasn4=0; /*FASN neg-mod*/


/*** FASN Kuchiba et al. JNCI 2012***/
if fasnIHCoverall^=. then 
do; 
fasnexplevel=fasnIHCoverall;
fasnexpmethod=1;
end;

else if fasnIHCoverall=. and fasnnewIHCoverall^=. then 
do; 
fasnexplevel=fasnnewIHCoverall;
fasnexpmethod=2;
end;

else if fasnIHCoverall=. and fasnnewIHCoverall=. then 
do;
fasnexplevel=max(fasntma121overall,fasntma122overall);
fasnexpmethod=3;
end;
     if 1=<fasnexplevel<=2 then fasn=0; /*FASN negative*/
else if 3=<fasnexplevel<=4 then fasn=1; /*FASN positive*/
if fasn=0 then fas=0; else fas=1; 


/*SIRT1 full section*/
     if sirt1ComparedNstrongest=4 then sirt1raw=4; /* strong */
else if sirt1ComparedNstrongest=3 then sirt1raw=3; /* moderate */
else if sirt1ComparedNstrongest=2 then sirt1raw=2; /* weak */
else if sirt1ComparedNstrongest=1 then sirt1raw=1; /* negative */

/*SIRT1 TMA 12*/
if sirt1ComparedNstrongest=. and sirt1sub2ComparedNstrongest ne . 
 then sirt1raw=sirt1sub2ComparedNstrongest;
if sirt1ComparedNstrongest=. and sirt1sub2ComparedNstrongest=. and sirt1sub1ComparedNstrongest ne . 
 then sirt1raw=sirt1sub1ComparedNstrongest;

     if 3<= sirt1raw <=4 then sirt1=1; /*sirt1 pos*/
else if 1<= sirt1raw <=2 then sirt1=0; /*sirt1 neg*/


/* MAGEA */ /* specifically upregulated in LINE-1 extreme-hypomethylators by DASL */ /* T.M. read slides */
     if  MAGEA121overall=4 or MAGEA122overall=4 then MAGEAoverall=4;
else if  MAGEA121overall=3 or MAGEA122overall=3 then MAGEAoverall=3;
else if  MAGEA121overall=2 or MAGEA122overall=2 then MAGEAoverall=2;
else if  MAGEA121overall=1 or MAGEA122overall=1 then MAGEAoverall=1;

     if MAGEAoverall=1 then mageacat2=0;
else if MAGEAoverall>=2 then mageacat2=1;

     if MAGEAoverall=1 then mageacat3=0;
else if 2=<MAGEAoverall=<3 then mageacat3=1;
else if MAGEAoverall=4 then mageacat3=2;

%indic3(vbl=mageacat3, prefix=mageacat3, min=1, max=2, reflev=0, missing=.,usemiss=0,
        label2='MAGEA strong',  label1='MAGEA weak-mod', label0='MAGEA negative');
%indic3(vbl=MAGEAoverall, prefix=MAGEAoverall, min=2, max=4, reflev=1, missing=.,usemiss=0,
        label4='MAGEA strong', label3='MAGEA moderate',  label2='MAGEA weak', label0='MAGEA negative');


/* LINE-1 */
if 75<=lineavgr<=100 then line4f=1; 
else if 60<=lineavgr <75  then line4f=2;
else if 45<=lineavgr <60  then line4f=3;
else if 0<= lineavgr <45  then line4f=4; 
	 if 70<=lineavgr<100  then line3f=1; 
else if 50<=lineavgr <70  then line3f=2;
else if 0<= lineavgr <50  then line3f=3; 
	 if 60<=lineavgr <=100 then linecat=0; 
else if 0<= lineavgr <60   then linecat=1; 
lineavg = (100 - lineavgr)/30; 
	 if lineavgr = . then line1=0; else line1=lineavg; 
	 if lineavgr = . then linemis=1; else linemis=0; 
	 if lineavgr = . then line=1.3; else line=lineavg; 

	 

/* YAP1 */ /* with Fernando Camargo @ CHB */

if YAP1cytostrongest=. then YAP1cytostrongest= YAP1cytooverall;
if YAP1nuclearstrongest=. then YAP1nuclearstrongest = YAP1nuclearoverall;

if YAP1cytostrongest=1 then yapcytos=0;
if YAP1cytostrongest=2 then yapcytos=1;
if 3=<YAP1cytostrongest=<4 then yapcytos=2;

if yapcytos=0 then yap1cytoloss=1; /* YAP1 cyto loss */
if 1=<yapcytos=<2 then yap1cytoloss=0;/* YAP1 cyto pos */

if YAP1nuclearstrongest=1 then yapnucs=0;
if YAP1nuclearstrongest=2 then yapnucs=1;
if 3=<YAP1nuclearstrongest=<4 then yapnucs=2;

if   yapnucs=0 then yap1nuclear=0;/* YAP1 nuclear neg */
if   1=<yapnucs then yap1nuclear=1;/* YAP1 nuclear pos */

if yap1cytoloss=1 and yap1nuclear=0 then yap1allloss=1; /* YAP1 cyto+nuc loss */
else if yap1cytoloss=0 or yap1nuclear=>1 then yap1allloss=0; /* YAP1 cyto or nuc pos */


/* HGF */
if HGF_cytostrongest=. then HGF_cytostrongest=HGF_cytooverall;
     if hgf_cytooverall=1 then hgf2over=0;/* HGF neg */
else if 2=<hgf_cytooverall<=4 then hgf2over=1;/* HGF pos */
     if hgf_cytostrongest=1 then hgf2str=0;
else if 2=<hgf_cytostrongest<=4 then hgf2str=1;

/* MET */
if MET_cytostrongest=. then MET_cytostrongest=MET_cytooverall;
     if MET_cytooverall=1 then met2over=0;/* MET neg */
else if 2=<MET_cytooverall<=4 then met2over=1;/* MET pos */


/* Old variable of CD274(PD-L1) read by Teppei Morikawa */
     if  CD274strongesttma121=4 or CD274strongesttma122=4 then CD274strongest=4;
else if  CD274strongesttma121=3 or CD274strongesttma122=3 then CD274strongest=3;
else if  CD274strongesttma121=2 or CD274strongesttma122=2 then CD274strongest=2;
else if  CD274strongesttma121=1 or CD274strongesttma122=1 then CD274strongest=1;

     if CD274strongest=1 then cd274str3=0;
else if CD274strongest=2 then cd274str3=1;
else if CD274strongest>=3 then cd274str3=2;

     if CD274strongest=1 then cd274str2=0;
else if CD274strongest>=2 then cd274str2=1; 

/*CD274: Tumor CD274 expression score*
*CD274cy (1-4; 0=no result; cytoplasmic intensity in tumor cells),  
CD274me (1-3; 0=no result; membrane expression in tumor cells),
CD274st (1-3, 0=no result; CD274 expression in stromal cells)  
CD274score (0-4; overall tumor CD274 expression level (ref. Masugi Y et al, Gut 2016)*/
     if    CD274cy=1  then CD274cyscore=0; 
else if    CD274cy=2  then CD274cyscore=1;
else if    CD274cy=3  then CD274cyscore=2;
else if    CD274cy=4  then CD274cyscore=3;
     if    CD274me=1  then CD274mescore=0; 
else if    CD274me=2  then CD274mescore=1;
else if    CD274me=3  then CD274mescore=1;
CD274score = CD274cyscore + CD274mescore; 

/*Tumor CD274 expression level (low [CD274_2cate = 1] vs high [CD274_2cate = 2]; ref. Aspirin CD274 paper by Hamada T)*/
     if CD274score = 0  then CD274_2cate = 1; 
else if CD274score = 1  then CD274_2cate = 1;
else if CD274score = 2  then CD274_2cate = 2;
else if CD274score = 3  then CD274_2cate = 2;
else if CD274score = 4  then CD274_2cate = 2;

/*PDCD1LG2 (PD-L2): Tumor PDCD1LG2 expression, categorized into quartile according to 奏he percentage of PDCD1LG2-expressing tumor cells (PDCD1LG2_perpositive)・*/ 
if     0=<PDCD1LG2_perpositive<= 20  then PDCD1LG2perq=1;
else if    20< PDCD1LG2_perpositive<= 50  then PDCD1LG2perq=2;
else if    50< PDCD1LG2_perpositive<= 80  then PDCD1LG2perq=3;
else if    80< PDCD1LG2_perpositive    then PDCD1LG2perq=4;

/*PDCD1 (PD-1): Density of PDCD1+ lymphocytes in tumor core (whole)
PDCD1_me_whole (1-5; 0=no result) (ref. Masugi Y et al, Gut 2016 supplement)*/
       if    PDCD1_me_whole=1  then PDCD1_me_whole5cate=1; 
else if    PDCD1_me_whole=2  then PDCD1_me_whole5cate=2;
else if    PDCD1_me_whole=3  then PDCD1_me_whole5cate=3;
else if    PDCD1_me_whole=4  then PDCD1_me_whole5cate=4;
else if    PDCD1_me_whole=5  then PDCD1_me_whole5cate=5;

/*CASR: cytoplasm and/or membrane expression level - 3 catgories (negative/low, intermediate, high) (ref. Xuehong Zhang) */ 
     if    CASR_overall_absolute = 1  then CASRcy3cate=1;
else if    CASR_overall_absolute = 2  then CASRcy3cate=1;
else if    CASR_overall_absolute = 3  then CASRcy3cate=2;
else if    CASR_overall_absolute = 4  then CASRcy3cate=3;



/*****************cutoff for clinical features*********************/

/*sex*/
if sex =1 then female =1; else if sex =2 then female=0; 

/*location*/
     if location = 0 then left_location = 1;
else if location = 1 then left_location = 1;
else if location = 2 then left_location = 0; /* prox */

if left_location=1 then left=1; else left=0;    /* missing => right */
 if left_location=1 then right=0; else right=1; /* missing => right */

     if location=0 then rectum=1;
else if 1<=location<=2 then rectum=0;
if rectum=1 then rect=1; else rect=0; /* missing => colon */

/*age*/
if ageyr=. then ageyr=intAge;
age10=ageyr/10;
	 if   0<ageyr <65 then age65cat=0;
else if     ageyr>=65 then age65cat=1; 


/*year of diagnosis*/
	 if 70<=ydx <95 then ydxcat=0;
else if     ydx>=95 then ydxcat=1; 
	 if 70<=ydx <96 then ydx96cat=0;
else if     ydx>=96 then ydx96cat=1; 
	 if 70<=ydx <97 then ydx97cat=0;
else if     ydx>=97 then ydx97cat=1; 
   	 if 70<=ydx <98 then ydx98cat=0;
else if     ydx>=98 then ydx98cat=1; 
  
/*BMI*/
  	 if  0< predxbmi <25 then bmia = 0;
else if 25<=predxbmi <30 then bmia = 1;
else if     predxbmi>=30 then bmia = 2;

	 if  0< predxbmi <30 then bmig = 0;
else if     predxbmi>=30 then bmig = 1;

	 if  0< predxbmi <27.5 then bmi27c = 0;
else if     predxbmi>=27.5 then bmi27c = 1;

     if predxbmi >=30 then obese =1; else obese =0; 


/*****************cutoff for pathological features*********************/

/*tumor grade (differentiation)*/
	 if 1<=PatholDiff<=2 then tumorg=1; /*well-mod*/
else if    PatholDiff =3 then tumorg=2; /*poor*/
	 if 1<=PatholDiff<=2 then higrade=0; else higrade=1;

/* tumor growth pattern */ /* Morikawa T et al.  Ann Surg Oncol 2012 */
     if 1=<tumorborder=<2 then border3c=0; /* expansile */
else if tumorborder=3 then border3c=1; /* intermediate */
else if tumorborder=4 then border3c=2; /* infiltrative */
%indic3(vbl=border3c, prefix=border3c, min=1, max=2, reflev=0, missing=.,usemiss=0)
     if 1=<tumorborder=<3 then border2v=0;
else if   tumorborder=4 then border2v=1;
if border2v=1 then border2suv=1; else border2suv=0;

/*mucinous component*/
/* if mucinp=. then mucinp=0; */
     if  mucinp >50   then mucin3c=2;
else if 0< mucinp=<50 then mucin3c=1;
else if mucinp=0      then mucin3c=0; 
if mucinp>0 then mucin=1; else mucin=0;
mucin25=mucinp/25;

/*signet ring cells*/ 
/* if signetp=. then signetp=0;*/
     if    signetp >50 then sig3c=2;
else if 0< signetp=<50 then sig3c=1;
else if signetp=0      then sig3c=0; 
if signetp>0 then sig=1; else sig=0;
signet25=signetp/25;


/*immune responce*/
crov=.; cro=.; 
	 if    crohn=0  then cro=0; 
else if    crohn=1  then cro=1;
else if    crohn=2  then cro=2;
else if    crohn=3  then cro=3; if 0<=cro<=3 then cromiss=0; else cromiss=1; 
	 if    crohn=0  then crov=0; 
else if    crohn=1  then crov=1;
else if    crohn=2  then crov=2;
else if    crohn=3  then crov=3;
	 if    peritumoral=0 then pet=0; 
else if    peritumoral=1 then pet=1;
else if    peritumoral=2 then pet=2;
else if    peritumoral=3 then pet=3; if 0<=pet<=3 then petmiss=0; else petmiss=1; 
	 if    peritumoral=0 then pert3=0; 
else if    peritumoral=1 then pert3=1;
else if    peritumoral=2 then pert3=2;
else if    peritumoral=3 then pert3=2;
	 if    perinest=0 then pen=0; 
else if    perinest=1 then pen=1;
else if    perinest=2 then pen=2;
else if    perinest=3 then pen=3; if 0<=pen<=3 then penmiss=0; else penmiss=1; 
	 if    perinest=0 then pern3=0; 
else if    perinest=1 then pern3=1;
else if    perinest=2 then pern3=2;
else if    perinest=3 then pern3=2; 
	 if    til=4 then til= .; if 0<=til<=3 then tilmiss=0; else tilmiss=1; 
     if 2<= til <=3  then tilym =2; 
else if     til  =1  then tilym =1; 
else if     til  =0  then tilym =0; 

cro2=cro;
if cro =. and 0<=pet<=3 and 0<=pen<=3 and 0<=til<=3 
then cro2 = -0.08513 + 0.09146 * pet + 0.15576 * pen + 0.52458 * til; 
if crov =. and 0<=pet<=3 and 0<=pen<=3 and 0<=til<=3 
then crov = 0.11439 + 0.17266 * pert3 + 0.32054 * pern3 + 0.4698 * til; 
if  -3 < cro2 <0.5  then cro2 =0; 
if 0.5<= cro2 <1.5  then cro2 =1; 
if 1.5<= cro2 <2.5  then cro2 =2; 
if 2.5<= cro2 <10   then cro2 =3; 
if  -3 < crov <0.5  then crov =0; 
if 0.5<= crov <1.5  then crov =1; 
if 1.5<= crov <2.5  then crov =2; 
if 2.5<= crov <10   then crov =3; 

	 if    cro=0  then croh=0; 
else if    cro=1  then croh=1;
else if    cro=2  then croh=2;
else if    cro=3  then croh=2;

if    cro=1  then crosuv=1;
else if    cro=2  then crosuv=2;
else if    cro=3  then crosuv=2;
else crosuv=0;

if    peritumoral=0 then pertsuv=0; 
else if    peritumoral=2 then pertsuv=2;
else if    peritumoral=3 then pertsuv=2;
else pertsuv=1;

if    perinest=0 then pernsuv=0; 
else if    perinest=2 then pernsuv=2;
else if    perinest=3 then pernsuv=2; 
else pernsuv=1;

if 2<= til <=3  then tilsuv =2; 
else if     til  =1  then tilsuv =1; 
else tilsuv =0; 

	 if    crov=0  then crohv=0; 
else if    crov=1  then crohv=1;
else if    crov=2  then crohv=2;
else if    crov=3  then crohv=2;
lymphoscore = cro + pet + pen + til; 
lymphoscova = crov + pet + pen + til; 
lymphonopena = cro + pet + til; 
lymphonopenva = crov + pet + til; 

/*BECN1 (beclin 1) expression*/
if     beclin  =1 then beclincate3=1; 
if     beclin  =2 then beclincate3=2;
if     beclin  =3 then beclincate3=3;
if     beclin  =4 then beclincate3=3;

/*MAP1LC3A (LC3) expression*/
if LC3AB_cytooverall=1 then LC3ABcate3=1;
if LC3AB_cytooverall=2 then LC3ABcate3=2;
if LC3AB_cytooverall=3 then LC3ABcate3=3;
if LC3AB_cytooverall=4 then LC3ABcate3=3;


/*SQSTM1 (p62) expression*/
if p62_cytooverall=1 then SQSTM1cate3=1;
if p62_cytooverall=2 and p62_cytoperpositive<=50 then SQSTM1cate3=1;
if p62_cytooverall=2 and p62_cytoperpositive>50 then SQSTM1cate3=2;
if p62_cytooverall=3 then SQSTM1cate3=2;
if p62_cytooverall=4 then SQSTM1cate3=3;

/*ptgs2cate4*/
      if ptgs2raw=1   then ptgs2cate4=1;              
else  if ptgs2raw=2   then ptgs2cate4=2;              
else  if ptgs2raw=3   then ptgs2cate4=3;
else  if ptgs2raw=4   then ptgs2cate4=4;
      if ptgs2tma1314overall=1   then ptgs2cate4=1;              
else  if ptgs2tma1314overall=2   then ptgs2cate4=2;              
else  if ptgs2tma1314overall=3   then ptgs2cate4=3;
else  if ptgs2tma1314overall=4   then ptgs2cate4=4;

/*NFKB1 nuclear expression*/ 
if     NFKB1_nuc_overall = 1  then NFKB1_nuc_intensity=1;
else if    NFKB1_nuc_overall = 2  then NFKB1_nuc_intensity=2;
else if    NFKB1_nuc_overall = 3  then NFKB1_nuc_intensity=3;
NFKB1_nuc_perc_overall = NFKB1_nuc_weak_perc + NFKB1_nuc_strong_perc;
if     NFKB1_nuc_intensity = 1 or 0 =< NFKB1_nuc_perc_overall <= 50  then NFKB1_nu =1;
else if    NFKB1_nuc_intensity = 2  then NFKB1_nu =2;
else if    NFKB1_nuc_intensity = 3  then NFKB1_nu =3;

/*RELA nuclear expression*/ 
if     RELA_nuc_overall = 1  then RELA_nu=1;
else if    RELA_nuc_overall = 2  then RELA_nu=2;
else if    RELA_nuc_overall = 3  then RELA_nu=2;

/*International Tumor Budding Consensus Conference*/
/* budding_IM */
if  10=< bud_IM        then bud_IMc3=3;
if   5=< bud_IM  =<9   then bud_IMc3=2; 
if   0=< bud_IM  =<4   then bud_IMc3=1;

/* budding_CT */
if  10=< bud_CT        then bud_CTc3=3;
if   5=< bud_CT  =<9   then bud_CTc3=2; 
if   0=< bud_CT  =<4   then bud_CTc3=1;

/* PDC_IM */
if  10=< PDC_IM        then pdc_IMc3=3;
if   5=< PDC_IM  =<9   then pdc_IMc3=2; 
if   0=< PDC_IM  =<4   then pdc_IMc3=1;

/* PDC_CT */
if  10=< PDC_CT        then pdc_CTc3=3;
if   5=< PDC_CT  =<9   then pdc_CTc3=2; 
if   0=< PDC_CT  =<4   then pdc_CTc3=1;

run;


