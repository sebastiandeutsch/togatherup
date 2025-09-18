module ApplicationHelper
  include Heroicon::Engine.helpers

  def nav_link_to(name, path)
    base = "inline-flex items-center rounded-pill border border-transparent px-4 py-2 text-[11px] uppercase tracking-[0.28em] transition"
    active = current_page?(path)

    classes = [base]
    if active
      classes << "bg-white/15 text-white shadow-glow border-white/20"
    else
      classes << "text-slate-400 hover:text-white hover:bg-white/5 hover:border-white/10"
    end

    link_to name, path, class: classes.join(" ")
  end
end
