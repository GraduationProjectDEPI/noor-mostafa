double calculateBill(int units) {
  double cost = 0;
  if (units <= 50) {
    cost = units * 0.48;
  } else if (units <= 100) {
    cost = (50 * 0.48) + ((units - 50) * 0.58);
  } else if (units <= 200) {
    cost = (50 * 0.48) + (50 * 0.58) + ((units - 100) * 0.77);
  } else if (units <= 350) {
    cost = (50 * 0.48) + (50 * 0.58) + (100 * 0.77) + ((units - 200) * 1.06);
  } else if (units <= 650) {
    cost =
        (50 * 0.48) +
        (50 * 0.58) +
        (100 * 0.77) +
        (150 * 1.06) +
        ((units - 350) * 1.28);
  } else {
    cost =
        (50 * 0.48) +
        (50 * 0.58) +
        (100 * 0.77) +
        (150 * 1.06) +
        (300 * 1.28) +
        ((units - 650) * 1.45);
  }
  return cost;
}
