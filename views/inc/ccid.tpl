<div aria-hidden="true" aria-labelledby="acceptModalLabel" role="dialog" tabindex="-1" id="acceptModal" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title">抄送给?</h4>
        </div>
        <div class="modal-body"> {{range .teams}}
          <label class="checkbox-inline">
          <input type="checkbox" data-value="{{.Userid}}" data-name="{{getRealname .Userid}}">
          {{getRealname .Userid}} </label>
          {{end}} </div>
        <div class="modal-footer">
          <input type="hidden" id="testid" />
          <button data-dismiss="modal" class="btn btn-default" type="button">取消</button>
          <button class="btn btn-primary js-dialog-taskcc" type="button">确定</button>
        </div>
      </div>
    </div>
  </div>