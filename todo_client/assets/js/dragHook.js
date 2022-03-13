import Sortable from 'sortablejs';

export default {
    mounted() {
        let dragged;
        const hook = this;
        const selector = '#' + this.el.id;

        document.querySelectorAll('.dropzone').forEach((dropzone) => {
            new Sortable(dropzone, {
                animation: 0,
                delay: 50,
                delayOnTouchOnly: true,
                group: 'shared',
                draggable: '.draggable',
                ghostClass: 'sortable-ghost',
                onEnd: function (evt) {
                    hook.pushEventTo(selector, "dropped", {
                        // the id here is based on the todo priority, see list.ex
                        currentPriority: evt.item.id,
                        // since todo priority is a list starting on 1, thus we add + 1 to the draggable index
                        proposedPriority: evt.newDraggableIndex + 1,
                    });
                },
            });
        });
    }
};