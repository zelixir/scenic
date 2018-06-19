#
#  Created by Boyd Multerer April 2018.
#  Copyright © 2018 Kry10 Industries. All rights reserved.
#
# helper module for configuring Drivers during startup

defmodule Scenic.ViewPort.Config do
  alias Scenic.ViewPort.Driver
  alias Scenic.ViewPort.Config

  import IEx

  @max_depth            256

  # describe the struct. Name nil and opts as an empty list are good defaults
  defstruct name: nil, default_scene: nil, default_scene_activation: nil,
    drivers: [], max_depth: @max_depth

  #--------------------------------------------------------
  def valid?( %Config{default_scene: {mod, _}, name: name, drivers: drivers} ) do
    ok = is_atom(mod) &&
    !is_nil(mod) &&
    is_atom(name) &&
    is_list(drivers)

    Enum.reduce(drivers, ok, fn(driver_config, ok) ->
      Driver.Config.valid?(driver_config) && ok
    end)
  end

  def valid?( %Config{default_scene: scene_name, name: name, drivers: drivers} ) do
    ok = is_atom(scene_name) &&
    !is_nil(scene_name) &&
    is_atom(name) &&
    is_list(drivers)

    Enum.reduce(drivers, ok, fn(driver_config, ok) ->
      Driver.Config.valid?(driver_config) && ok
    end)
  end


  def valid?( %{} = config ), do: valid?( struct(Config, config) )


  #--------------------------------------------------------
  def valid!( %Config{default_scene: {mod, _}, name: name, drivers: drivers} ) when
    is_atom(mod) and not is_nil(mod) and is_atom(name) and is_list(drivers)
  do
    Enum.each(drivers, &Driver.Config.valid!(&1) )
    :ok
  end

  def valid!( %Config{default_scene: scene_name, name: name, drivers: drivers} ) when
    is_atom(scene_name) and not is_nil(scene_name) and is_atom(name) and is_list(drivers)
  do
    Enum.each(drivers, &Driver.Config.valid!(&1) )
    :ok
  end
    
  def valid!( %Config{default_scene: nil} ) do
    raise "Viewport Config requires a default_scene"
  end

  def valid!( %Config{name: name} ) when not is_atom(name) do
    raise "Viewport Config name must be an atom"
  end
  
  def valid!( %Config{default_scene: nil} ) do
    raise "Viewport Config requires a default_scene"
  end

  def valid!( %{} = config ) do
    valid!( struct(Config, config) )
  end

end