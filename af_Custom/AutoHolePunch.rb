require 'sketchup.rb'
# Assurez-vous que le chemin est correct. 
# Si le fichier est dans Plugins/af_Custom/#HolePunchTool.rb, requirez-le ainsi :
require 'af_Custom/#HolePunchTool.rb' 

module TIG
  module AutoPuncherV2
    
    class Watcher < Sketchup::EntitiesObserver
      def onElementAdded(entities, entity)
        # Filtres rapides pour ne pas surcharger SketchUp
        return unless entity.valid?
        return unless entity.is_a?(Sketchup::ComponentInstance)
        # Le composant doit être de type "Cutting" (perceur)
        return unless entity.definition.behavior.cuts_opening?

        # On lance un timer pour laisser SketchUp finir l'action de pose
        # On augmente légèrement le délai à 0.5s pour être sûr
        UI.start_timer(0.5, false) {
          self.attempt_punch(entity)
        }
      end

      def attempt_punch(entity)
        # Vérification 1 : L'entité existe-t-elle encore ?
        if !entity.valid?
          puts "AutoPunch: L'entité n'est plus valide."
          return
        end

        # Vérification 2 : Est-elle collée à une face (Gluing) ?
        # C'est souvent ici que ça bloque.
        if entity.glued_to.nil?
          puts "AutoPunch: Le composant '#{entity.definition.name}' est posé mais PAS collé (glued_to = nil). Perçage annulé."
          # Note : Si vous posez le composant sur le sol (sans face) ou sur un groupe verrouillé, il ne collera pas.
          return
        end

        # Si tout est bon, on lance l'outil
        puts "AutoPunch: Tentative de perçage pour '#{entity.definition.name}'..."
        model = Sketchup.active_model
        
        begin
          model.start_operation("Auto Punch", true)
          
          # Appel de l'outil TIG
          # On passe l'instance en argument pour un traitement direct
          TIG::HolePunchTool.new(entity)
          
          model.commit_operation
          puts "AutoPunch: Opération terminée avec succès."
        rescue => e
          model.abort_operation
          puts "AutoPunch Erreur : #{e.message}"
          puts e.backtrace
        end
      end
    end

    class AppWatcher < Sketchup::AppObserver
      def onNewModel(model)
        reset_observer(model)
      end
      def onOpenModel(model)
        reset_observer(model)
      end
      
      def reset_observer(model)
        model.entities.remove_observer(@obs) if @obs
        @obs = Watcher.new
        model.entities.add_observer(@obs)
        puts "AutoPunch: Observateur activé sur le modèle."
      end
    end

    if !file_loaded?(__FILE__)
      watcher = AppWatcher.new
      Sketchup.add_observer(watcher)
      watcher.reset_observer(Sketchup.active_model)
      file_loaded(__FILE__)
    end

  end
end