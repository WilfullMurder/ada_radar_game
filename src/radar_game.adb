with Ada.Text_IO;
with Glfw;
with Glfw.Windows;
with Glfw.Windows.Context;
with Glfw.Windows.Hints;
with Glfw.Input; use Glfw.Input;
with Glfw.Input.Keys;
with GL.Buffers;
with GL.Types;
with GL.Types.Colors;
with GL.Fixed.Matrix;
with GL.Window;
with Tile_Map;
with Entity;
with Player_Entity;
with Entity_Manager;

procedure Radar_Game is
   
   Window_Width  : constant Glfw.Size := 1600;
   Window_Height : constant Glfw.Size := 1200;
   
   Main_Window : aliased Glfw.Windows.Window;
   
   procedure Initialize is
      use GL.Fixed.Matrix;
      use GL.Types;
      FB_Width, FB_Height : Glfw.Size;
   begin
      Glfw.Init;
      
      -- Create a window with OpenGL context
      Main_Window.Init (Width  => Window_Width,
                        Height => Window_Height,
                        Title  => "Radar Game - Sea & Landscape");
      
      -- Make the window's context current
      Glfw.Windows.Context.Make_Current (Main_Window'Access);
      
      -- Enable vertical sync
      Glfw.Windows.Context.Set_Swap_Interval (1);
      
      -- Show the window
      Main_Window.Show;
      
      -- Get actual framebuffer size (may differ due to DPI scaling)
      Main_Window.Get_Framebuffer_Size (FB_Width, FB_Height);
      
      -- Set OpenGL viewport to match framebuffer
      GL.Window.Set_Viewport (0, 0, GL.Types.Int (FB_Width), GL.Types.Int (FB_Height));
      
      -- Set up orthographic projection for 2D rendering using actual framebuffer size
      Load_Identity (Projection);
      Apply_Orthogonal (Projection,
                        Left   => 0.0,
                        Right  => Double (FB_Width),
                        Bottom => Double (FB_Height),
                        Top    => 0.0,
                        Near   => -1.0,
                        Far    => 1.0);
      Load_Identity (Modelview);
      
      Ada.Text_IO.Put_Line ("Framebuffer size: " & Glfw.Size'Image (FB_Width) & "x" & Glfw.Size'Image (FB_Height));
      
      Tile_Map.Initialize;
      Tile_Map.Load_Tileset ("resources/water.png");
      Tile_Map.Generate_Sample_Map;
      
      declare
         Player : Entity.Entity_Ref := new Player_Entity.Player_Ship'(
            Player_Entity.Create_Ship(ID => 1,
                                 X =>  GL.Types.Double (Window_Width) / 2.0,
                                 Y =>  GL.Types.Double (Window_Height) / 2.0,
                                 Filename => "resources/ships/ship_large_body.png"
         ));
      begin
      Player.Initialize;
      Entity_Manager.Register(Player);
      end;

      Ada.Text_IO.Put_Line ("Radar Game Initialized");
      Ada.Text_IO.Put_Line ("Press ESC to close");
   end Initialize;
   
   procedure Render is
      Current_Time : Glfw.Seconds := Glfw.Time;
   begin
      -- Clear the screen
      GL.Buffers.Set_Color_Clear_Value (GL.Types.Colors.Color'(0.2, 0.3, 0.4, 1.0));
      GL.Buffers.Clear ((Color => True, others => False));
      
      Tile_Map.Render (GL.Types.Double (Current_Time));

      Entity_Manager.Render_All(GL.Types.Double (Current_Time));
      
      -- Swap front and back buffers
      Glfw.Windows.Context.Swap_Buffers (Main_Window'Access);
   end Render;
   
   procedure Main_Loop is
   begin
      while not Main_Window.Should_Close loop
         Glfw.Input.Poll_Events;
         
         -- Check for ESC key
         if Main_Window.Key_State (Glfw.Input.Keys.Escape) = Glfw.Input.Pressed then
            Main_Window.Set_Should_Close (True);
         end if;

         Entity_Manager.Update_All(Main_Window, GL.Types.Double (Glfw.Time));

         Render;
      end loop;
   end Main_Loop;
   
   procedure Cleanup is
   begin
      Entity_Manager.Cleanup_All;
      Tile_Map.Cleanup;
      Main_Window.Destroy;
      Glfw.Shutdown;
      Ada.Text_IO.Put_Line ("Shutdown complete");
   end Cleanup;
   
begin
   Initialize;
   Main_Loop;
   Cleanup;
end Radar_Game;
