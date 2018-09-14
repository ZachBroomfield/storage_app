class PagesController < ApplicationController
  def new
  end

  def home
    if params[:name].present? && params[:room].present?
      @tickets = Ticket.joins(:details).where("room = ?", "#{params[:room]}").
        where("tickets.name like ?", "#{params[:name].upcase}%").
        where(active: true).distinct.or(
        Ticket.joins(:details).where("room = ?", "#{params[:room]}").
        where("tickets.name like ?", "#{params[:name].upcase}%").
        where("tickets.updated_at > ?", Time.now.in_time_zone("Melbourne").at_beginning_of_day).
        distinct).preload(details: [:stored_employee, :retrieved_employee]).
        paginate(:page => params[:page])
    elsif params[:name].present?
      @tickets = Ticket.where("name like ?", "#{params[:name].upcase}%").
        where(active: true).or(
        Ticket.where("name like ?", "#{params[:name].upcase}%").
        where("updated_at > ?", Time.now.in_time_zone("Melbourne").at_beginning_of_day)).
        preload(details: [:stored_employee, :retrieved_employee]).
        paginate(:page => params[:page])
    elsif params[:room].present?
      @tickets = Ticket.joins(:details).where("room = ?", "#{params[:room]}").
        where(active: true).distinct.or(
        Ticket.joins(:details).where("room = ?", "#{params[:room]}").
        where("tickets.updated_at > ?", Time.now.in_time_zone("Melbourne").at_beginning_of_day).
        distinct).preload(details: [:stored_employee, :retrieved_employee]).
        paginate(:page => params[:page])
    end
  end

  def current_st
    respond_to do |format|
      format.html {redirect_to st_path(params.permit(:pageST))}
      format.js
    end

    home_st
  end

  def current_rnr
    respond_to do |format|
      format.html {redirect_to rnr_path(params.permit(:pageRNR))}
      format.js
    end

    home_rnr
  end

  def current_lt

    respond_to do |format|
      format.html {redirect_to lt_path(params.permit(:pageLT))}
      format.js
    end

    home_lt
  end

  def home_st
    @current_st = find_tickets("ST")
  end

  def home_rnr
    @current_rnr = find_tickets("RNR")
  end

  def home_lt
    @current_lt = find_tickets("LT")
  end

  private

    def find_tickets(state)
      Ticket.where(active: true).where("aasm_state = ?", state).preload(details: [:stored_employee]).paginate(:page => params[:"page#{state}"], :per_page => 50)
    end
end
