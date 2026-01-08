require 'sketchup.rb'

module AF_Extensions
  class MirrorTool
    
    def initialize
      # Tente de charger un curseur personnalisé si l'icône existe, sinon curseur par défaut
      icon_path = File.join(File.dirname(__FILE__), 'icons', 'mirror_l.png')
      if File.exist?(icon_path)
        @cursor_id = UI.create_cursor(icon_path, 0, 0) 
      else
        @cursor_id = 0 # Curseur flèche par défaut
      end
    end

    def onSetCursor
      UI.set_cursor(@cursor_id)
    end

    def onLButtonDown(flags, x, y, view)
      ph = view.pick_helper
      ph.do_pick(x, y)
      entity = ph.best_picked
      
      if entity.is_a?(Sketchup::ComponentInstance) || entity.is_a?(Sketchup::Group)
        # 8 = La touche CTRL sur Windows (Bitwise check)
        # Si Ctrl est enfoncé : Axe Y (Vert), sinon Axe X (Rouge)
        axe = (flags & 8) == 8 ? :y : :x 
        
        flip_component(entity, axe)
      else
        UI.beep # Petit son si on clique dans le vide
      end
    end

    def flip_component(entity, axe)
      model = Sketchup.active_model
      # On démarre une opération pour que le Ctrl+Z fonctionne en un coup
      op_name = (axe == :x) ? "Miroir (Rouge)" : "Miroir (Vert)"
      model.start_operation(op_name, true)

      # 1. Trouver le centre géométrique LOCAL du composant
      # (C'est le centre de sa définition, pas sa position dans le monde)
      local_center = entity.definition.bounds.center

      # 2. Créer la transformation de miroir (Echelle -1)
      if axe == :x
        # Miroir sur l'axe Rouge local (-1 sur X)
        # On pivote autour du centre local pour que l'objet reste "sur lui-même"
        t_scale = Geom::Transformation.scaling(local_center, -1, 1, 1)
      else
        # Miroir sur l'axe Vert local (-1 sur Y) - via CTRL
        t_scale = Geom::Transformation.scaling(local_center, 1, -1, 1)
      end

      # 3. Calculer la transformation globale à appliquer à l'instance
      # Mathématique : T_Finale = T_Actuelle * T_Miroir_Local * T_Actuelle_Inverse
      # Cela permet d'appliquer la symétrie locale sans déplacer l'origine de collage
      t_instance = entity.transformation
      t_apply = t_instance * t_scale * t_instance.inverse

      # 4. Appliquer la transformation
      # On utilise transform_entities car c'est la méthode qui respecte le mieux les objets collés (Glue)
      model.active_entities.transform_entities(t_apply, [entity])

      model.commit_operation
    end
    
    def onMouseMove(flags, x, y, view)
      # Petit confort : info-bulle quand on survole un objet valide
      ph = view.pick_helper
      ph.do_pick(x, y)
      ent = ph.best_picked
      if ent.is_a?(Sketchup::ComponentInstance) || ent.is_a?(Sketchup::Group)
        view.tooltip = "Clic : Inverser Gauche/Droite (Rouge)\nCtrl+Clic : Inverser Intérieur/Extérieur (Vert)"
      else
        view.tooltip = ""
      end
      view.refresh
    end

  end
end