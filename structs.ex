defprotocol Animal do
  @doc "Interface for animals"
  def sound(data)
end

defmodule Dog do
  @moduledoc """
    # Module to represent dogs

    - First
    - Second
  """
  defstruct name: "Rex", age: 2

  @doc """
  Set the name of dog
  """
  def set_name(dog, name) do
    %Dog{dog | name: name}
  end

  def get_name(dog) do
    dog.name
  end
end

defimpl String.Chars, for: Dog do
  def to_string(dog) do
    "Name : " <> dog.name <> ", Age : " <> Integer.to_string(dog.age)
  end
end

defimpl Animal, for: Dog do
  def sound(_data), do: IO.puts("Woof !")
end

d = struct(Dog, [name: "Tom"])
d = Dog.set_name(d, "Medor")

IO.puts("#{d}")
Animal.sound(d)
