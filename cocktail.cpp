/* write a cocktail drink invention program */

  function inventCocktailDrink(ingredients) {
  let drinkName = '';
  let drinkIngredients = ingredients;
  let drinkInstructions = '';

  // create drink name
  for (let i = 0; i < ingredients.length; i++) {
    drinkName += ingredients[i].charAt(0).toUpperCase() + ingredients[i].slice(1);
  }

  // create drink instructions
  drinkInstructions = `In a shaker, mix ${ingredients[0]}, ${ingredients[1]}, and ${ingredients[2]}. Shake vigorously and strain into a glass. Garnish with ${ingredients[3]} and enjoy!`;
  return {
    name: drinkName,
    ingredients: drinkIngredients,
    instructions: drinkInstructions
  };
}

// example
const myIngredients = ['vodka', 'orange juice', 'cranberry juice', 'lime'];
const myDrink = inventCocktailDrink(myIngredients);
console.log(myDrink);
:
  {
    name: 'VodkaOrangeJuiceCranberryJuiceLime',
    ingredients: ['vodka', 'orange juice', 'cranberry juice', 'lime'],
    instructions: 'In a shaker, mix vodka, orange juice, and cranberry juice. Shake vigorously and strain into a glass. Garnish with lime and enjoy!'
  }

