class MembersController < ApplicationController
    before_action :set_member, only: %i[ show edit update destroy ]
    def index
        @members = Member.order("rank asc")
    end

    def new
        @member = Member.new
    end

    def rank
      @member = Member.find(params[:id])
      
      if(!@member)
        redirect_to members_url
      end
    end

    def currentRank

      @player = Member.find_by_id(params[:id])
      if(!@player)
        redirect_to members_url
      end
      @opponent  = Member.find_by_id(params[:rank_update][:member_id])
      @player.update(games_played: @player.games_played.to_i + 1)
      @opponent.update(games_played: @opponent.games_played.to_i + 1)

      if(params[:rank_update][:score] == 'Win')
        
        if(@player.rank < @opponent.rank)
        else
          if((@player.rank.to_i - @opponent.rank.to_i) == 1 || (@player.rank.to_i < @opponent.rank.to_i) == - 1)
            @player.update(rank: (@player.rank.to_i - 1 ))
            @opponent.update(rank: @player.rank.to_i + 1)

          elsif((@player.rank.to_i - @opponent.rank.to_i) == 2 || (@player.rank.to_i < @opponent.rank.to_i) == - 2)

          else
            
            @rank = ((@player.rank.to_i - @opponent.rank.to_i) / 2)

            @below_player_rank  = Member.find_by(rank: (@opponent.rank.to_i + 1)).update(rank: @opponent.rank.to_i);
            @opponent.update(rank: @opponent.rank.to_i + 1 )
            

            @members_below_oppenent  = Member.where("rank > ? AND id != ?", @player.rank,@player.id)
            @members_below_oppenent.each do |m|
              m.update(rank: m.rank.to_i - 1)
            end

            
            @player.update(rank: @player.rank.to_i - @rank.to_i)

            @check_curent_move = Member.find(@player.id)
            @members_above_oppenent  = Member.where("rank >= ? AND id != ?", @check_curent_move.rank,@player.id)
            @members_above_oppenent.each do |m|
              m.update(rank: m.rank.to_i + 1)
            end

          end
        end
      end
      
      if(params[:rank_update][:score] == 'Draw')
        if((@player.rank.to_i - @opponent.rank.to_i) == 1 || (@player.rank.to_i - @opponent.rank.to_i) == - 1)

        else
          if(@player.rank > @opponent.rank)
            @movedRank  = Member.find_by(rank: (@player.rank.to_i - 1))
            @movedRank.update(rank: @movedRank.rank.to_i + 1)
            @player.update(rank: @player.rank.to_i - 1)
          else 
            @movedRank  = Member.find_by(rank: (@opponent.rank.to_i - 1))
            @movedRank.update(rank: @movedRank.rank.to_i + 1)
            @opponent.update(rank: @opponent.rank.to_i - 1)
          end
        end

        
      end
      
      if(params[:rank_update][:score] == 'Loose')
        if(@player.rank < @opponent.rank)
          if((@player.rank.to_i - @opponent.rank.to_i) == 1 || (@player.rank.to_i < @opponent.rank.to_i) == - 1)
            @player.update(rank: (@player.rank.to_i - 1 ))
            @opponent.update(rank: @player.rank.to_i + 1)

          elsif((@player.rank.to_i - @opponent.rank.to_i) == 2 || (@player.rank.to_i < @opponent.rank.to_i) == - 2)

          else
            
            @rank = ((@opponent.rank.to_i - @player.rank.to_i) / 2)

            @below_player_rank  = Member.find_by(rank: (@player.rank.to_i + 1)).update(rank: @player.rank.to_i);
            @player.update(rank: @player.rank.to_i + 1 )
            

            @members_below_oppenent  = Member.where("rank > ? AND id != ?", @opponent.rank,@opponent.id)
            @members_below_oppenent.each do |m|
              m.update(rank: m.rank.to_i - 1)
            end

            
            @opponent.update(rank: @opponent.rank.to_i - @rank.to_i)

            @check_curent_move = Member.find(@opponent.id)
            @members_above_oppenent  = Member.where("rank >= ? AND id != ?", @check_curent_move.rank,@opponent.id)
            @members_above_oppenent.each do |m|
              m.update(rank: m.rank.to_i + 1)
            end

          end
        else
          
        end
      end

      redirect_to members_url
    end

    def create

      @members = Member.all().count()
        @member = Member.new(:name => params[:member][:name], :surname=> params[:member][:surname],
        :email=> params[:member][:email],:birthday=> params[:member][:birthday],:games_played => 0,
        :rank => @members.to_i + 1)

        respond_to do |format|
            if @member.save
                format.html { redirect_to @member, notice: "member was successfully created." }
                format.json { render :show, status: :created, location: @member }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @member.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit

    end
    def update
      @member = Member.find_by_id(params[:id])
      
      if(!@member)
        redirect_to members_url
      end
        respond_to do |format|
            if @member.update(member_params)
              format.html { redirect_to @member, notice: "member was successfully updated." }
              format.json { render :show, status: :ok, location: @member }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @member.errors, status: :unprocessable_entity }
            end
          end
    end
    def destroy
      @member_rank = @member.rank

      @all_members  = Member.where("rank > ?", @member_rank)
      @all_members.each do |m|
        m.update(rank: m.rank.to_i - 1)
      end
        @member.destroy


        respond_to do |format|
        format.html { redirect_to members_url, notice: "member was successfully destroyed." }
        format.json { head :no_content }
        end
    end
    def show
    end

    private
    def set_member
      @member = Member.find_by_id(params[:id])
      
      if(!@member)
        redirect_to members_url
      end
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :surname,:email,:birthday,:games_played,:rank)
    end
end
