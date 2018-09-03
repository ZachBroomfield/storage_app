class SearchController < ApplicationController
  def index
    if params[:ds].present? && params[:de].present?
      search_start = Date.parse(params[:ds]).in_time_zone("Melbourne").at_beginning_of_day
      search_end = Date.parse(params[:de]).in_time_zone("Melbourne").at_end_of_day
      if params[:name].present? && params[:room].present?
        @tickets = Ticket.joins(:details).where("room = ?", "#{params[:room]}").
          where("name like ?", "#{params[:name].upcase}%").
          where(:created_at => search_start..search_end).distinct
      elsif params[:name].present?
        @tickets = Ticket.where("name like ?", "#{params[:name].upcase}%").
        where(:created_at => search_start..search_end).distinct
      elsif params[:room].present?
        @tickets = Ticket.joins(:details).where("room = ?", "#{params[:room]}").where(active: true).distinct.
        where(:created_at => search_start..search_end).distinct
      end
    end
  end

  def show
    if params[:name].present? && params[:room].present?
      @tickets = Ticket.joins(:details).where("room = ?", "#{params[:room]}").
        where("name like ?", "#{params[:name].upcase}%").where(active: true).distinct.or(
        Ticket.joins(:details).where("room = ?", "#{params[:room]}").
        where("name like ?", "#{params[:name].upcase}%").where(active: true).distinct)
    elsif params[:name].present?
      @tickets = Ticket.where("name like ?", "#{params[:name].upcase}%").where(active: true).or(
                 Ticket.where("name like ?", "#{params[:name].upcase}%").where("updated_at > ?", 1.day.ago))
    elsif params[:room].present?
      @tickets = Ticket.joins(:details).where("room = ?", "#{params[:room]}").where(active: true).distinct.or(
                 Ticket.joins(:details).where("room = ?", "#{params[:room]}").where("tickets.updated_at > ?", 1.day.ago).distinct)
    end
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js
    end
  end
end
