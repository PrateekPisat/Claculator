defmodule Calc do
	#Main function
	#Note: This function cannot be tested since, it doesn't return anything.
	#Effect: Repeatedly prints a prompt, accepts an input and returns the 
	#		 evaluated statement
	#Example: > 1 + 2
	#		  3
	#		  >
	def main() do
		input = IO.gets("> ")|>String.trim()
		result =  eval(input)
		Enum.each(result, fn(n) -> IO.puts n end)
		main()
	end
	
	# eval : String -> List<Integer> 
	#Given: a String
	#Where: the string represents an arithmatic expression
	#Returns: A list with the result of the arithmatic expression as its only 
	#		  item.
	#Example: eval("1 + 2") -> [3]
	def eval(input) do
		ops = []
		vals = []
		ip = String.split(input, " ")
		{ops, vals} = to_postfix(ip, ops, vals)
		result = get_result(ops, vals)
		result
	end

	# to_postfix : List<String>, List<String>, List<Integer> -> 
	#			   Tuple{List<String>,List<Integer>} 
	#Given: the input string represented as a list, a list of operators ues in 
	#		the expression which is initially , a list of values used in the 
	#		expression which is initially empty.
	#Returns: A list of operators  and values used in the input expression 
	#	 	  item.
	#Example: to_postfix(["1", "+", "2"], [], []) -> {["+"], [1, 2]}
	def to_postfix(ip, ops, vals) do
		if(length(ip) == 0) do
			{ops, vals}
		else
			[h|t] = ip
			cond  do
				String.starts_with?(h, "(") and String.length(h) > 1 -> 
					t = [String.slice(h, 1, String.length(h))] ++ t
					t = ["("] ++ t
					to_postfix(t, ops, vals)
				String.contains?(h, ")") and String.length(h) > 1 ->
					t = [String.trim_trailing(h, ")")] ++ [")"] ++ t
					to_postfix(t, ops, vals)
				true -> cond do
					h == "(" -> ops = push(ops, h)
					h == ")" -> {ops, vals} = dealing_with_paranthesis(ops, vals, h)	
					h == "*" || h == "-" || h == "+" || h == "/" -> {ops, vals} = 
						dealing_with_precedence(ops, vals, h)
					true -> vals = push(vals, String.to_integer(h))
				end		
			end
			to_postfix(t, ops, vals)
		end
	end

	# push : List Type -> List<Type>
	#Given: a list and data to be inserted into that list
	#Returns: the list with the data inserted
	#Example: push([], "*") -> ["*"]
	#		  push([], 3) -> [3]
	def push(list, h) do
		list = list ++ [h]
		list
	end

	# pop : List<Type> -> Tuple{Type, List<Type>}
	#Given: a list
	#Returns: the list and the data that was poped from it.
	#Example: pop([3]) -> {3, []}
	#         pop(["/"]) -> {"/", []}
	def pop(list) do
		data = List.last(list)
		list = List.delete(list, data)
		{data, list}
	end
	
	# get_result : List<String> List<Integer> -> List<Integer>
	#Given: a list of operators ues in the expression, a list of values used in 
	#       the expression.
	#Returns: A list containg the result as its only item. 
	#Example: get_result(["+"], [1, 2]) -> {[3]}
	def get_result(ops, vals) do
		if length(vals) == 1 do
			vals
		else
			{operator, ops} = pop(ops)
			{operand1, vals} = pop(vals)
			{operand2, vals} = pop(vals)
			
			case operator do
				"+" -> vals = vals ++ [operand2 + operand1]
				"-" -> vals = vals ++ [operand2 - operand1]
				"*" -> vals = vals ++ [operand2 * operand1]
				"/" -> vals = vals ++ [div(operand2,operand1)]
			end
			get_result(ops, vals)
		end
	end

	# get_precedence : String -> Integer
	#Given: A String representing an operator
	#Returns: An integer representing the precedence of the operator
	#Example: get_precedence("+") -> 0
	#		  get_precedence("/") -> 1
	#         get_precedence("(") -> -1
	def get_prcedence(operator) do
		cond do
			operator == "*" || operator == "/" -> 1
			operator == "(" -> -1
			true -> 0
		end
	end

	# dealing_with_precedence : List<String> List<Integer> String -> 
	# 							Tuple{List<String>, List<Integer>}
	# dealing_with_precedence : List, List, String -> {List, List} 
	#Given: A list of operators, a list of values, and the operator under 
	#       consideration.
	#Returns: A tuple containing the list of opertators, and a list of values.
	#Example: dealing_with_precedence([*], [3, 6], "+") -> {["+"], [18]}
	#         dealing_with_precedence([], ["3"], "+") -> {["+"], ["3"]}
	def dealing_with_precedence(ops, vals, data) do
		if length(ops) == 0 || 
		   get_prcedence(List.last(ops)) < get_prcedence(data) do
			{push(ops, data), vals}
		else
			{operator, ops} = pop(ops)
			{operand1, vals} = pop(vals)
			{operand2, vals} = pop(vals)
			case operator do
				"+" -> vals = vals ++ [operand2 + operand1]
				"-" -> vals = vals ++ [operand2 - operand1]
				"*" -> vals = vals ++ [operand2 * operand1]
				"/" -> vals = vals ++ [div(operand2,operand1)]
				"(" -> nil
			end
			dealing_with_precedence(ops, vals, to_string(data))
		end
	end

	# dealing_with_paranthesis : List, List, String -> {List, List} 
	#Given: A list of operators, a list of values, and the operator under 
	#       consideration.
	#Returns: A tuple containing the list of opertators, and a list of values.
	#Example:dealing_with_paranthesis(["(", "*"], ["3", "6"], ")") -> {[], [18]}
	def dealing_with_paranthesis(ops, vals, data) do
		if List.last(ops) == "("  do
			{_, ops} = pop(ops)
			{ops, vals}
		else
			{operator, ops} = pop(ops)
			{operand1, vals} = pop(vals)
			{operand2, vals} = pop(vals)
			case operator do
				"+" -> vals = vals ++ [operand2 + operand1]
				"-" -> vals = vals ++ [operand2 - operand1]
				"*" -> vals = vals ++ [operand2 * operand1]
				"/" -> vals = vals ++ [div(operand2,operand1)]
			end
			dealing_with_paranthesis(ops, vals, data)
		end
	end
end

