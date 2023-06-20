#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

# if no argument is given
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

# if the input is an atomic number
if [[ $1 =~ ^[1-9]+$ ]]
then
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
# if the input is given with letters
   element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# if the element is not found in the database
if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

# Display message
echo $element | while IFS=" |" read atom_num name symbol typ mass melt boil 
do
  echo -e "The element with atomic number $atom_num is $name ($symbol). It's a $typ, with a mass of $mass amu. $name has a melting point of $melt celsius and a boiling point of $boil celsius."
done
