module VisitReportsHelper
    def color_for(report)
        return '#66ccff' if report.status == 'planned'
        return '#66ff66' if report.status == 'completed'
        return '#ff6666' if report.status == 'missed'

        # 担当者別色（例：user_idで分岐）
        case report.user_id
        when 1 then '#f0ad4e' # オレンジ
        when 2 then '#5bc0de' # 水色
        when 3 then '#d9534f' # 赤
        else '#999999'        # グレー
        end
    end


end
