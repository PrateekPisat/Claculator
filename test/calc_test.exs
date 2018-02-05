defmodule CalcTest do
  use ExUnit.Case

  doctest Calc

  test "Push Test" do
	assert Calc.push([], 3) == [3]
  end

  test "Pop Test" do
  	assert Calc.pop([3,4]) == {4, [3]}
  end

  test "Postfix + Test" do
  	assert Calc.to_postfix(String.split("1 + 2"), [], []) == {["+"], [1, 2]}
  end

  test "Postfix - Test" do
  	assert Calc.to_postfix(String.split("2 - 1"), [], []) == {["-"], [2, 1]}
  end

  test "Postfix * Test" do
  	assert Calc.to_postfix(String.split("1 * 2"), [], []) == {["*"], [1, 2]}
  end

  test "Postfix / Test" do
  	assert Calc.to_postfix(String.split("2 / 1"), [], []) == {["/"], [2, 1]}
  end

  test "Postfix ( ) Test" do
  	assert Calc.to_postfix(String.split("( 2 / 1 )"), [], []) == {[], [2]}
  end

  test "GetResult + Test" do
  	assert Calc.get_result(["+"], [1, 2]) == [3]
  end

  test "GetResult - Test" do
  	assert Calc.get_result(["-"], [2, 1]) == [1]
  end

  test "GetResult * Test" do
  	assert Calc.get_result(["*"], [1, 2]) == [2]
  end

  test "GetResult / Test" do
  	assert Calc.get_result(["/"], [2, 1]) == [2]
  end

  test "Precedence + Test" do
  	assert Calc.get_prcedence("+") == 0
  end

  test "Precedence - Test" do
  	assert Calc.get_prcedence("-") == 0
  end

  test "Precedence * Test" do
  	assert Calc.get_prcedence("*") == 1
  end

  test "Precedence / Test" do
  	assert Calc.get_prcedence("/") == 1
  end

  test "Precedence ( Test" do
  	assert Calc.get_prcedence("(") == -1
  end

  test "Paranthesis Test 1" do
  	assert Calc.dealing_with_paranthesis(["(", "+"], [2, 1], ")") == {[],[3]}
  end

  test "Paranthesis Test 2" do
  	assert Calc.dealing_with_paranthesis(["(", "-"], [2, 1], ")") == {[],[1]}
  end

  test "Paranthesis Test 3" do
  	assert Calc.dealing_with_paranthesis(["(", "*"], [2, 1], ")") == {[],[2]}
  end

  test "Paranthesis Test 4" do
  	assert Calc.dealing_with_paranthesis(["(", "/"], [2, 1], ")") == {[],[2]}
  end

  test "eval" do
  	assert Calc.eval("1 + 2") == [3]
  end
end
