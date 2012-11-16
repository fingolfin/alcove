#############################################################################
##
##  Matroid.gi                  alcove package                  Martin Leuner
##
##  Copyright 2012 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Matroid methods for alcove.
##
#############################################################################

####################################
##
## Representations
##
####################################

DeclareRepresentation( "IsAbstractMatroidRep",
	IsMatroid and IsAttributeStoringRep,
	[ "bases", "groundSet" ]
);

DeclareRepresentation( "IsVectorMatroidRep",
	IsMatroid and IsAttributeStoringRep,
	[ "generatingMatrix" ]
);

DeclareRepresentation( "IsGraphicMatroidRep",
	IsMatroid and IsAttributeStoringRep,
	[ "incidenceMatrix" ]
);


####################################
##
## Types and Families
##
####################################


BindGlobal( "TheFamilyOfMatroids",
	NewFamily( "TheFamilyOfMatroids" , IsMatroid )
);

BindGlobal( "TheTypeAbstractMatroid",
	NewType( TheFamilyOfMatroids,
		IsAbstractMatroidRep )
);

BindGlobal( "TheTypeMinorOfAbstractMatroid",
	NewType( TheFamilyOfMatroids,
		IsAbstractMatroidRep and IsMinorOfMatroid )
);

BindGlobal( "TheTypeVectorMatroid",
	NewType( TheFamilyOfMatroids,
		IsVectorMatroidRep )
);

BindGlobal( "TheTypeMinorOfVectorMatroid",
	NewType( TheFamilyOfMatroids,
		IsVectorMatroidRep and IsMinorOfMatroid )
);

BindGlobal( "TheTypeGraphicMatroid",
	NewType( TheFamilyOfMatroids,
		IsGraphicMatroidRep )
);

BindGlobal( "TheTypeMinorOfGraphicMatroid",
	NewType( TheFamilyOfMatroids,
		IsGraphicMatroidRep and IsMinorOfMatroid )
);


####################################
##
## Attributes
##
####################################


##############
## DualMatroid

InstallMethod( DualMatroid,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  local dualbases, dual;

  dualbases := Set( List( Bases( matroid ), b -> Difference( GroundSet( matroid ), b ) ) );

  dual := Matroid( GroundSet( matroid ), dualbases );
  SetDualMatroid( dual, matroid );

  return dual;

 end

);

InstallMethod( DualMatroid,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  local dualmatrix, dual, mat;
  mat := MatrixOfVectorMatroid( matroid );

  dualmatrix := NullspaceMat( TransposedMat( mat ) );

  if IsList( dualmatrix ) and IsEmpty( dualmatrix ) then dualmatrix := [ List( [ 1 .. SizeOfGroundSet(matroid) ], i -> Zero(BaseDomain(mat)) ) ]; fi;

  dual := Matroid( dualmatrix );
  SetDualMatroid( dual, matroid );

  return dual;

 end

);


##################
## SizeOfGroundSet

InstallMethod( SizeOfGroundSet,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  return Size( GroundSet( matroid ) );
 end

);

InstallMethod( SizeOfGroundSet,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
   return DimensionsMat( MatrixOfVectorMatroid(matroid) )[2];
 end

);

InstallMethod( SizeOfGroundSet,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )
  local vertnum;
  if IsBound( matroid!.incidenceMatrix ) then

   vertnum := DimensionsMat( matroid!.incidenceMatrix )[1];
   return Sum( List( [ 1 .. vertnum ], i ->
		Sum( List( [ i .. vertnum ], j -> matroid!.incidenceMatrix[i][j] ) )
	) );

  else
   Error( "this graphic matroid apparently lost its incidence matrix, this shouldn't happen" );
  fi;
 end

);


#######
## Rank

InstallMethod( RankOfMatroid,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  return Size( Bases(matroid)[1] );
 end

);

InstallMethod( RankOfMatroid,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  return RankMat( MatrixOfVectorMatroid(matroid) );
 end

);

InstallMethod( RankOfMatroid,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);

InstallMethod( Rank,
		"alias for Rank for matroids",
		[ IsMatroid ],

 RankOfMatroid

);


################
## Rank function

InstallMethod( RankFunction,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  return function( X )
   local b, max, s;

   max := 0;

   for b in Bases( matroid ) do
    s := Size( Intersection2( b, X ) );
    if s > max then
     max := s;
     if max = Size( X ) then return max; fi;
    fi;
   od;

   return max;
  end;
 end

);

InstallMethod( RankFunction,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  return function( X ) return RankSubMatrix( MatrixOfVectorMatroid( matroid ), [ 1 .. DimensionsMat(MatrixOfVectorMatroid(matroid))[1] ], X ); end;
 end

);

InstallMethod( RankFunction,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);


########
## Bases

InstallMethod( Bases,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  if IsBound( matroid!.bases ) and not IsEmpty( matroid!.bases ) then
   return matroid!.bases;
  else
   Error( "this matroid does not seem to have any bases, this shouldn't happen" );
  fi;
 end

);

InstallMethod( Bases,				# THIS IS AN EXTREMELY NAIVE APPROACH
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  return Filtered( Combinations( [ 1 .. SizeOfGroundSet( matroid ) ], Rank( matroid ) ),
		b -> RankSubMatrix( MatrixOfVectorMatroid(matroid), [1..DimensionsMat(MatrixOfVectorMatroid(matroid))[1]], b ) = Rank( matroid ) );
 end

);

InstallMethod( Bases,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);


###########
## Circuits

InstallMethod( Circuits,				# CPT. PLACEHOLDER BECKONS
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )

 end

);

InstallMethod( Circuits,				# CPT. PLACEHOLDER BECKONS
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )

 end

);

InstallMethod( Circuits,				# CPT. PLACEHOLDER BECKONS
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);


###########
## Cocircuits

InstallMethod( Cocircuits,				# CPT. PLACEHOLDER BECKONS
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )

 end

);

InstallMethod( Cocircuits,				# CPT. PLACEHOLDER BECKONS
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )

 end

);

InstallMethod( Cocircuits,				# CPT. PLACEHOLDER BECKONS
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);


##################
## TuttePolynomial

InstallMethod( TuttePolynomial,
		"for matroids",
		[ IsMatroid ],

 function( matroid )
  local loopNum, coloopNum, loopsColoops, x, y, p, min;

  x := Indeterminate( Integers, 1 );
  y := Indeterminate( Integers, 2 );
  if not HasIndeterminateName( FamilyObj(x), 1 ) and not HasIndeterminateName( FamilyObj(x), 2 ) then
   SetIndeterminateName( FamilyObj(x), 1, "x" );
   SetIndeterminateName( FamilyObj(x), 2, "y" );
  fi;

# Check whether Tutte polynomial of dual matroid is already known:
  if HasDualMatroid( matroid ) and HasTuttePolynomial( DualMatroid( matroid ) ) then
   return Value( TuttePolynomial( DualMatroid( matroid ) ), [ x, y ], [ y, x ] );
  fi;

  loopNum := Size( Loops( matroid ) );
  coloopNum := Size( Coloops( matroid ) );

  p := x^coloopNum * y^loopNum;

# Termination case:

  if loopNum + coloopNum = SizeOfGroundSet( matroid ) then
   return p;
  fi;

# Recursion:

  loopsColoops := Union2( Loops( matroid ), Coloops( matroid ) );

  min := Deletion( matroid, loopsColoops );

  return p * ( TuttePolynomial( Deletion( min, [1] ) ) + TuttePolynomial( Contraction( min, [1] ) ) );
 end

);


###########################
## RankGeneratingPolynomial

InstallMethod( RankGeneratingPolynomial,
		"for matroids",
		[ IsMatroid ],

 function( matroid )
  local x, y;
  x := Indeterminate( Integers, 1 );
  y := Indeterminate( Integers, 2 );
  return Value( TuttePolynomial( matroid ), [ x, y ], [ x+1, y+1 ] );
 end

);


########
## Loops

InstallMethod( Loops,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  return Coloops( DualMatroid( matroid ) );
 end

);

InstallMethod( Loops,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  local dims;
  dims := DimensionsMat( MatrixOfVectorMatroid( matroid ) );
  return Filtered( [ 1 .. dims[2] ], col -> ForAll( [ 1 .. dims[1] ], row -> IsZero( MatElm( MatrixOfVectorMatroid(matroid), row, col ) ) ) );
 end

);

InstallMethod( Loops,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);


########
## Coloops

InstallMethod( Coloops,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  local is, b;

  is := GroundSet( matroid );
  for b in Bases( matroid ) do
   is := Intersection2( is, b );
   if IsEmpty( is ) then break; fi;
  od;

  return is;
 end

);

InstallMethod( Coloops,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  return Loops( DualMatroid( matroid ) );
 end

);

InstallMethod( Coloops,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )

 end

);


####################################
##
## Properties
##
####################################

############
## IsUniform

InstallMethod( IsUniform,
		"for matroids",
		[ IsMatroid ],

 function( matroid )
  return Size( Bases( matroid ) ) = Binomial( SizeOfGroundSet( matroid ), Rank( matroid ) );
 end

);


##################
## IsSimpleMatroid

InstallMethod( IsSimpleMatroid,
		"for matroids",
		[ IsMatroid ],

 function( matroid )
  
 end

);

InstallMethod( IsSimple, "for matroids", [ IsMatroid ], IsSimpleMatroid );


############
## IsGraphic

InstallMethod( IsGraphic,
		"for matroids",
		[ IsMatroid ],

 function( matroid )

 end

);


############
## IsRegular

InstallMethod( IsRegular,
		"for matroids",
		[ IsMatroid ],

 function( matroid )

 end

);


####################################
##
## Methods
##
####################################

############
## GroundSet

InstallMethod( GroundSet,
		"for abstract matroids",
		[ IsAbstractMatroidRep ],

 function( matroid )
  if IsBound( matroid!.groundSet ) then
   return matroid!.groundSet;
  else
   Error( "this matroid does not seem to have a ground set, this shouldn't happen" );
  fi;
 end

);

InstallMethod( GroundSet,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
  return [ 1 .. SizeOfGroundSet(matroid) ];
 end

);

InstallMethod( GroundSet,
		"for graphic matroids",
		[ IsGraphicMatroidRep ],

 function( matroid )
  local i, j, edges, vertnum, multiplicity;

  if IsBound( matroid!.incidenceMatrix ) then

   vertnum := DimensionsMat( matroid!.incidenceMatrix )[1];
   edges := [];
   for i in [ 1 .. vertnum ] do
    for j in [ i .. vertnum ] do
     multiplicity := matroid!.incidenceMatrix[i][j];
     if multiplicity <> 0 then
      Add( edges, [Set([i,j]),multiplicity] );
     fi;
    od;
   od;
   return edges;

  else
   Error( "this graphic matroid apparently lost its incidence matrix, this shouldn't happen" );
  fi;

 end

);


########################
## MatrixOfVectorMatroid

InstallMethod( MatrixOfVectorMatroid,
		"for vector matroids",
		[ IsVectorMatroidRep ],

 function( matroid )
 
  if IsBound( matroid!.generatingMatrix ) then
   return matroid!.generatingMatrix;
  else
   Error( "this vector matroid apparently lost its matrix, this shouldn't happen" );
  fi;

 end

);


########
## Minor

InstallMethod( Minor,
		"for abstract matroids",
		[ IsAbstractMatroidRep, IsList, IsList ],

##
 function( matroid, del, contr )
  local minorBases, t, sdel, scontr, minor;

  sdel := Set( del );
  scontr := Set( contr );
  if not IsEmpty( Intersection2( sdel, scontr ) ) then Error( "<del> and <contr> must not meet" ); fi;

  minorBases := ShallowCopy( Bases( Matroid ) );

# Deletion:

  for t in sdel do
   if ForAll( minorBases, b -> t in b ) then		# t is a coloop in the current minor
    minorBases := List( minorBases, b -> Difference(b,[t]) );
   else
    minorBases := Filtered( minorBases, b -> not t in b );
   fi;
  od;

# Contraction:

  for t in scontr do
   if ForAny( minorBases, b -> t in b ) then		# t is not a loop in the current minor
    minorBases := List( Filtered( minorBases, b -> t in b ), b -> Difference(b,[t]) );
   fi;
  od;

  minor := Objectify( TheTypeMinorOfAbstractMatroid,
	rec( groundSet := Immutable( Difference( Difference( GroundSet( matroid ), sdel ), scontr ) ), bases := Immutable( minorBases ) ) );
  SetParentAttr( minor, matroid );

  return minor;
 end

);

##
InstallMethod( Minor,
		"for vector matroids",
		[ IsVectorMatroidRep, IsList, IsList ],

 function( matroid, del, contr )
  local loopsColoops, sdel, scontr, minorMat, minor, col, row, actRows, actCols, foundRow, foundCoeff, rowCoeff, calcCol;

  sdel := Set( del );
  scontr := Set( contr );

  if not IsEmpty( Intersection2( sdel, scontr ) ) then Error( "<del> and <contr> must not meet" ); fi;
  if not IsSubset( [ 1 .. SizeOfGroundSet( matroid ) ], Union2( sdel, scontr ) ) then Error( "<del> and <contr> must be subsets of the column labels of <matroid>" ); fi;

# If loops or coloops will be deleted or contracted, delete rather than contract:

  loopsColoops := Intersection2( Union2( Loops( matroid ), Coloops( matroid ) ), scontr );
  scontr := Difference( scontr, loopsColoops );
  sdel := Union2( sdel, loopsColoops );

# Delete columns and prepare matrix for contraction:

  minorMat := MutableCopyMat( MatrixOfVectorMatroid( matroid ) );
  actCols := Difference( [ 1 .. DimensionsMat( minorMat )[2] ], sdel );

# Contraction:

  actRows := [ 1 .. DimensionsMat( minorMat )[1] ];
  for col in scontr do

   actCols := Difference( actCols, [ col ] );
   foundRow := 0;
   for row in actRows do  

    rowCoeff := MatElm( minorMat, row, col );
    if not IsZero( rowCoeff ) then

     if foundRow = 0 then

      foundRow := row;
      foundCoeff := rowCoeff;

     else

      rowCoeff := rowCoeff/foundCoeff;
      for calcCol in actCols do
       SetMatElm( minorMat, row, calcCol,
	MatElm(minorMat,row,calcCol) - rowCoeff * MatElm(minorMat,foundRow,calcCol) );
      od;

     fi;

    fi;

   od;
   actRows := Difference( actRows, [ foundRow ] );

  od;

  if IsEmpty( actRows ) or IsEmpty( actCols ) then
   minorMat := Matrix( [ List( [ 1 .. Size(actCols) ], c -> Zero(BaseDomain(minorMat)) ) ], minorMat );
  else
   minorMat := ExtractSubMatrix( minorMat, actRows, actCols );
  fi;

  minor := Objectify( TheTypeMinorOfVectorMatroid, rec( generatingMatrix := Immutable( minorMat ) ) );
  SetParentAttr( minor, matroid );

  return minor;
 end

);

##
InstallMethod( Minor,
		"for graphic matroids",
		[ IsGraphicMatroidRep, IsList, IsList ],

 function( matroid, del, contr )

 end

);


###########
## Deletion

InstallMethod( Deletion,
		"for matroids",
		[ IsMatroid, IsList ],

 function( matroid, del )
  return Minor( matroid, del, [] );
 end

);


##############
## Contraction

InstallMethod( Contraction,
		"for matroids",
		[ IsMatroid, IsList ],

 function( matroid, contr )
  return Minor( matroid, [], contr );
 end

);


##########
## IsMinor

InstallMethod( IsMinor,
		"for matroids",
		[ IsMatroid, IsMinorOfMatroid ],

 function( matroid, minor )
  local parent;
  parent := ParentAttr( minor );
  if IsMinorOfMatroid( parent ) then
   return IsMinor( matroid, parent );
  else
   return matroid = parent;
  fi;
 end

);


####################################
##
## Constructors
##
####################################


##
InstallMethod( Matroid,
		"copy constructor",
		[ IsMatroid ],

 IdFunc

);


##
InstallMethod( Matroid,
		"by size of ground set and list of bases or independent sets",
		[ IsInt, IsList ],

 function( deg, indep  )
  local gset, baselist, rk, sizelist, matroid;

  if IsEmpty( indep ) then Error( "the list of independent sets must be non-empty" ); fi;

  gset := Immutable([ 1 .. deg ]);

  if ForAny( indep, i -> not IsSubset( gset, i ) ) then
   Error( "elements of <indep> must be subsets of [1..<deg>]" );
  fi;

  sizelist := List( indep, i -> Size( Set( i ) ) );
  rk := Maximum( sizelist );

# Extract bases from indep list:
  baselist := Immutable( List( Filtered( [ 1 .. Size( indep ) ], i -> sizelist[i] = rk ), i -> Set( indep[i] ) ) );

# Check base exchange axiom:
  if ForAny( baselist, b1 -> ForAny( baselist, b2 ->
	ForAny( Difference(b1,b2), e -> ForAll( Difference(b2,b1), f ->
		not Union( Difference( b1, [e] ), [f] ) in baselist
	) )
  ) ) then Error( "bases must satisfy the exchange axiom" ); fi;

  matroid := Objectify( TheTypeAbstractMatroid, rec( groundSet := gset, bases := baselist ) );
  SetRankOfMatroid( matroid, rk );

  return matroid;

 end

);


##
InstallMethod( Matroid,
		"by size of ground set and list of bases",
		[ IsInt, IsList ],

 function( deg, baselist  )
  return Objectify( TheTypeAbstractMatroid, rec( groundSet := Immutable([1..deg]), bases := Immutable(baselist) ) );
 end

);


##
InstallMethod( Matroid,
		"by ground set and list of bases or independent sets",
		[ IsList, IsList ],

 function( groundset, indep )
  local matroid, sizelist, rk, baselist;

  if IsEmpty( indep ) then Error( "the list of independent sets must be non-empty" ); fi;

  if ForAny( indep, i -> not IsSubset( groundset, i ) ) then
   Error( "elements of <indep> must be subsets of <groundset>" );
  fi;

  sizelist := List( indep, i -> Size( Set( i ) ) );
  rk := Maximum( sizelist );

# Extract bases from indep list:
  baselist := Immutable( List( Filtered( [ 1 .. Size( indep ) ], i -> sizelist[i] = rk ), i -> Set( indep[i] ) ) );

# Check base exchange axiom:
  if ForAny( baselist, b1 -> ForAny( baselist, b2 ->
	ForAny( Difference(b1,b2), e -> ForAll( Difference(b2,b1), f ->
		not Union( Difference( b1, [e] ), [f] ) in baselist
	) )
  ) ) then Error( "bases must satisfy the exchange axiom" ); fi;

  matroid := Objectify( TheTypeAbstractMatroid, rec( groundSet := Immutable(groundset), bases := baselist ) );
  SetRankOfMatroid( matroid, rk );

  return matroid;

 end

);


##
InstallMethod( MatroidNC,
		"by ground set and list of bases, no checks",
		[ IsList, IsList ],

 function( groundset, baselist )
  return Objectify( TheTypeAbstractMatroid, rec( groundSet := Immutable(groundset), bases := Immutable(baselist) ) );
 end

);



##
InstallMethod( Matroid,
		"by matrix",
		[ IsMatrix ],
		10,

 function( mat )
  local matobj;

  matobj := Immutable( MakeMatrix( mat ) );		## guess the base field and construct matrix object

  return Objectify( TheTypeVectorMatroid, rec( generatingMatrix := matobj ) );
 end

);


##
InstallMethod( Matroid,
		"by empty matrix",
		[ IsGeneralizedRowVector and IsNearAdditiveElementWithInverse and IsAdditiveElement ],

 function( mat )
  if not IsEmpty( mat[1] ) then Error( "constructor for empty vector matroids called on non-empty matrix" ); fi;

  return ObjectifyWithAttributes( TheTypeVectorMatroid, rec( generatingMatrix := Immutable(mat) ),
			SizeOfGroundSet, 0,
			RankOfMatroid, 0
	);
 end

);


##
InstallMethod( Matroid,
		"by matrix object",
		[ IsMatrixObj ],
		20,

 function( matobj )
  return Objectify( TheTypeVectorMatroid, rec( generatingMatrix := Immutable(matobj) ) );
 end

);


##
InstallMethod( Matroid,
		"given ground set and boolean function deciding independence of subsets",
		[ IsList, IsFunction ],

 function( groundset, testindep )

 end

);


##
InstallMethod( MatroidByCircuits,
		"given ground set and list of circuits",
		[ IsList, IsList ],

 function( groundset, circs )

 end

);


##
InstallMethod( MatroidByRankFunction,
		"given ground set and integer valued function",
		[ IsList, IsFunction ],

 function( groundset, rank )

 end

);


##
InstallMethod( MatroidOfGraph,
		"given an incidence matrix",
		[ IsMatrix ],

 function( incidencemat )

 end

);


####################################
##
## Display Methods
##
####################################

##
InstallMethod( PrintObj,
		"for matroids",
		[ IsMatroid ],

 function( matroid )

  if SizeOfGroundSet( matroid ) = 0 then

   Print( "<The boring matroid>" );

  else

   Print( "<A" );
 
   if HasRankOfMatroid( matroid ) then
    Print( " rank ", RankOfMatroid(matroid) );
   fi;
 
   if HasIsUniform( matroid ) and IsUniform( matroid ) then
    Print( " uniform" );
   elif HasIsSimpleMatroid( matroid ) and IsSimpleMatroid( matroid ) then
    Print( " simple" );
   fi;
 
   if IsVectorMatroidRep( matroid ) then
    Print( " vector" );
   elif IsGraphicMatroidRep( matroid ) then
    Print( " graphic" );
   fi;
 
   ## Print( " matroid over a ", SizeOfGroundSet( matroid ), " element ground set>" );
   Print( " matroid>" );

  fi;

 end

);

##
InstallMethod( Display,
		"for matroids",
		[ IsMatroid ],

 function( matroid )
  local mat;

  if IsVectorMatroidRep( matroid ) then
   mat := MatrixOfVectorMatroid( matroid );

   Print( "The vector matroid of this matrix" );
   if IsList( mat ) then Print( " over ", BaseDomain(mat) ); fi;
   Print( ":\n" );
   Display( mat );

  elif IsGraphicMatroidRep( matroid ) then

   Print( "The matroid of the (multi-)graph with this incidence matrix:\n" );

  else

   Print( "The abstract matroid on the ground set\n" );
   Display( GroundSet( matroid ) );
   Print( "with bases\n" );
   Display( Bases( matroid ) );

  fi;

 end

);
