#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to format and display element details
display_element_details() {
  local ATOMIC_NUMBER_SELECTED=$1

    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed 's/ |/"/')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    NAME_FORMATTED=$(echo $NAME | sed 's/ |/"/')
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    SYMBOL_FORMATTED=$(echo $SYMBOL | sed 's/ |/"/')
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    TYPE_FORMATTED=$(echo $TYPE | sed 's/ |/"/')
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    ATOMIC_MASS_FORMATTED=$(echo $ATOMIC_MASS | sed 's/ |/"/')
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    MELTING_POINT_FMT=$(echo $MELTING_POINT | sed 's/ |/"/')
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
    BOILING_POINT_FMT=$(echo $BOILING_POINT | sed 's/ |/"/')
    echo -e "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $TYPE_FORMATTED, with a mass of $ATOMIC_MASS_FORMATTED amu. $NAME_FORMATTED has a melting point of $MELTING_POINT_FMT celsius and a boiling point of $BOILING_POINT_FMT celsius."
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Please provide an element as an argument."
 else

# Assign the first argument to a variable
INPUT=$1

# Check if the input is an atomic number
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER_SELECTED=$INPUT
  ATOMIC_NUMBER_EXISTS=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER_SELECTED")
  
  if [[ -z $ATOMIC_NUMBER_EXISTS ]]; then
    echo -e "I could not find that element in the database."
  else
    display_element_details $ATOMIC_NUMBER_SELECTED
  fi

# Check if the input is a symbol
elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]; then
  SYMBOL_EXISTS=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT'")
  
  if [[ -z $SYMBOL_EXISTS ]]; then
    echo -e "I could not find that element in the database."
  else
    ATOMIC_NUMBER_SELECTED=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT'")
    display_element_details $ATOMIC_NUMBER_SELECTED
  fi

# Check if the input is a name
else
  NAME_EXISTS=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT'")
  
  if [[ -z $NAME_EXISTS ]]; then
    echo -e "I could not find that element in the database."
  else
    ATOMIC_NUMBER_SELECTED=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT'")
    display_element_details $ATOMIC_NUMBER_SELECTED
  fi
 fi
fi